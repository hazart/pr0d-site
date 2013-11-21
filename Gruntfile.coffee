pushStateHook = (url) ->
	path = require('path')
	request = require('request');
	return (req, res, next) ->
		ext = path.extname(req.url)
		if ((ext is "" or ext is ".html") && req.url != "/")
			req.pipe(request(url)).pipe(res)
		else
			next()

mountFolder = (connect, dir)->
	return connect.static(require('path').resolve(dir))

module.exports = (grunt)->
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-concat')
	grunt.loadNpmTasks('grunt-contrib-connect')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-cssmin')
	grunt.loadNpmTasks('grunt-contrib-htmlmin')
	grunt.loadNpmTasks('grunt-contrib-imagemin')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-jade')
	grunt.loadNpmTasks('grunt-contrib-stylus')
	grunt.loadNpmTasks('grunt-contrib-requirejs')
	grunt.loadNpmTasks('grunt-open')
	grunt.loadNpmTasks('grunt-usemin')
	grunt.loadNpmTasks('grunt-ftp-deploy')
	grunt.loadNpmTasks('grunt-notify')
	grunt.loadNpmTasks('grunt-autoprefixer')
	grunt.loadNpmTasks('grunt-text-replace')
	grunt.loadNpmTasks('grunt-escaped-seo')

	# configurable paths
	yeomanConfig = {
		app: 'assets'
		src: 'src'
		dist: 'dist'

		tmp: '.tmp'
		tmp_dist: '.tmp-dist'

		domain: 'pr0d.fr'
		domain_preprod: 'test.pr0d.fr'

		ftp_host: 'FTP.hazart.o2switch.net'
		ftp_dest: '/'

		ftp_host_preprod: 'FTP.hazart.o2switch.net'
		ftp_dest_preprod: 'test/'
	}

	#
	# Grunt configuration:
	#
	# https://github.com/cowboy/grunt/blob/master/docs/getting_started.md
	#
	grunt.initConfig

		# Project configuration
		# ---------------------
		yeoman: yeomanConfig

		watch:
			coffee:
				files: ['<%= yeoman.src %>/{,**/}*.coffee']
				tasks: ['coffee:dev']
				options: 
					livereload: true
					# interval: 500
					spawn: false

			stylus:
				files: ['<%= yeoman.src %>/{,**/}*.styl']
				tasks: ['stylus:dev','autoprefixer']
				options: 
					livereload: true
			
			jade:
				files: ['<%= yeoman.src %>/views/{,**/}*.jade']
				tasks: ['jade:dev']
				options: 
					livereload: true
					spawn: false

			livereload:
				files: [
					'<%= yeoman.tmp %>/{,**/}*.{css,js,html}'
					'<%= yeoman.app %>/{,**/}*.html'
					'<%= yeoman.app %>/css/{,**/}*.css'
					'<%= yeoman.app %>/js/{,**/}*.js'
					'<%= yeoman.app %>/images/{,**/}*.{png,jpg,jpeg}'
				]
				options:
					livereload: true

		connect:
			dev:
				options:
					port: 9000
					# Change this to 'localhost' to access the server only local.
					hostname: '0.0.0.0'
					middleware: (connect)->
						return [
							require('connect-livereload')()
							mountFolder(connect, yeomanConfig.tmp)
							mountFolder(connect, yeomanConfig.app)
						]
			dist:
				options:
					port: 9001
					# Change this to 'localhost' to access the server only local.
					hostname: '0.0.0.0'
					middleware: (connect)->
						return [
							mountFolder(connect, yeomanConfig.dist)
						]

		open:
			dev:
				path: 'http://localhost:<%= connect.livereload.options.port %>'
			dist:
				path: 'http://localhost:<%= connect.dist.options.port %>'

		clean:
			dist: ['<%= yeoman.dist %>']
			tmp: ['<%= yeoman.tmp %>']
			tmp_dist: ['<%= yeoman.tmp_dist %>']
			components: ['<%= yeoman.dist %>/components']
			templates: ['<%= yeoman.dist %>/templates']
			css: ['<%= yeoman.dist %>/css/main.css']
			js: ['<%= yeoman.dist %>/js/main.js']

		coffee:
			dev:
				expand: true
				cwd: '<%= yeoman.src %>'
				src: ['**/*.coffee']
				dest: '<%= yeoman.tmp %>/js'
				ext: '.js'
				options: 
					runtime: 'inline',
					sourceMap: true,
					sourceRoot: '<%= yeoman.src %>'
					sourceMapDir: '<%= yeoman.src %>'
			dist:
				expand: true
				cwd: '<%= yeoman.src %>'
				src: ['**/*.coffee']
				dest: '<%= yeoman.tmp %>/js'
				ext: '.js'
				options: 
					runtime: 'inline',
					sourceMap: false

		stylus:
			dev:
				options:
					linenos: true
					# firebug: true
					compress: false
					paths: ['<%= yeoman.src %>']
					urlfunc: 'embedurl'
					import: ['main.styl', 'helpers/stylus_mixin.styl']
				files:
					'<%= yeoman.tmp %>/css/main.css': '<%= yeoman.src %>/views/**/*.styl'
			dist:
				options:
					paths: ['<%= yeoman.src %>']
					urlfunc: 'embedurl'
					import: ['main.styl', 'helpers/stylus_mixin.styl']
				files:
					'<%= yeoman.tmp %>/css/main.css': '<%= yeoman.src %>/views/**/*.styl'

		autoprefixer:
			single_file:
				src: '<%= yeoman.tmp %>/css/main.css',
				dest: '<%= yeoman.tmp %>/css/main.css'

		jade: 
			dev: 
				options:
					pretty: true
					data:
						debug: true
				files: [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: ['**/*.jade']
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.html'
				]
			dist: 
				options:
					pretty: true
					data:
						debug: false
				files: [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: ['**/*.jade']
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.html'
				]
		copy:
			dist:
				files: [
					{ expand: true, cwd: '<%= yeoman.tmp %>/', src: ['**','.*'], dest: '<%= yeoman.tmp_dist %>/' }
					{ expand: true, cwd: '<%= yeoman.app %>/', src: ['**','.*'], dest: '<%= yeoman.tmp_dist %>/' }
				]

		useminPrepare:
			html: '<%= yeoman.tmp_dist %>/index.html'
			options:
				dest: '<%= yeoman.dist %>'

		usemin:
			html: ['<%= yeoman.dist %>/{,*/}*.html']
			css: ['<%= yeoman.dist %>/css/{,*/}*.css']
			options:
				dirs: ['<%= yeoman.dist %>']

		imagemin:
			dist:
				files: [{
					expand: true,
					cwd: '<%= yeoman.app %>/images'
					src: '{,*/}*.{png,jpg,jpeg}'
					dest: '<%= yeoman.dist %>/images'
				}]

		cssmin: 
			dist: 
				expand: true,
				cwd: '<%= yeoman.dist %>/css/'
				src: ['*.css', '!*.min.css']
				dest: '<%= yeoman.dist %>/css/'
				ext: '.css'

		htmlmin:
			dist:
				# options:
				#   removeCommentsFromCDATA: true
				#   # https://github.com/yeoman/grunt-usemin/issues/44
				#   collapseWhitespace: true
				#   collapseBooleanAttributes: true
				#   removeAttributeQuotes: true
				#   removeRedundantAttributes: true
				#   useShortDoctype: true
				#   removeEmptyAttributes: true
				#   removeOptionalTags: true
				files: [{
					expand: true,
					cwd: '<%= yeoman.app %>',
					src: ['*.html', 'templates/*.html'],
					dest: '<%= yeoman.dist %>'
				}]

		uglify:
			dist:
				files:[{
					expand: true,
					cwd: '<%= yeoman.dist %>',
					src: '**/*.js',
					dest: '<%= yeoman.dist %>'
				}]

		requirejs:
			compile:
				options:
					# no minification, is done by the min task
					baseUrl: 'js/'
					appDir: './<%= yeoman.tmp_dist %>/'
					dir: './<%= yeoman.dist %>/'
					wrap: true
					removeCombined: true
					keepBuildDir: true
					inlineText: true
					mainConfigFile: '<%= yeoman.tmp_dist %>/js/main.js'
					optimize: ""

					modules: [
						{ name: 'vendors', exclude: [] }
						{ name: 'app', exclude: ['vendors'] }
						{ name: 'main', exclude: ['config', 'app', 'vendors'] }
						# view modules 
						{ name: 'views/home/home_view', exclude: ['config', 'app', 'vendors'] }
						{ name: 'views/concept/concept_view', exclude: ['config', 'app', 'vendors'] }
						{ name: 'views/offer/offer_view', exclude: ['config', 'app', 'vendors'] }
						{ name: 'views/blog/blog_view', exclude: ['config', 'app', 'vendors'] }
						{ name: 'views/references/references_view', exclude: ['config', 'app', 'vendors'] }
					]

					done: (done, output) ->
						duplicates = require('rjs-build-analysis').duplicates(output)
						if (duplicates.length > 0)
							grunt.log.subhead('Duplicates found in requirejs build:')
							grunt.log.warn(duplicates)
							done(new Error('r.js built duplicate modules, please check the excludes option.'))
						done()

		replace:
			close:
				src: ['<%= yeoman.dist %>/index.html']
				overwrite: true
				replacements: [{ 
					from: 'flagClose: false'
					to: 'flagClose: true' 
				}]
			nodev:
				src: ['<%= yeoman.dist %>/index.html']
				overwrite: true
				replacements: [{ 
					from: 'flagDev: true'
					to: 'flagDev: false' 
				}]

		'escaped-seo':
			preprod:
				options:
					domain: '<%= yeoman.domain_preprod %>'
					server: 'http://localhost:9001'
					public: 'dist'
					folder: 'seo'
					changefreq: 'daily'
					delay: 2000
					replace: {}
			prod:
				options:
					domain: '<%= yeoman.domain %>'
					server: 'http://localhost:9001'
					public: 'dist'
					folder: 'seo'
					changefreq: 'daily'
					delay: 2000
					replace: {}

		'ftp-deploy':
			prod:
				auth:
					host: '<%= yeoman.ftp_host %>'
					port: 21
					authKey: 'prod'
				src: 'dist'
				dest: '<%= yeoman.ftp_dest %>'
				exclusions: ['dist/**/.DS_Store', 'dist/**/Thumbs.db', 'dist/build.txt']
			preprod:
				auth:
					host: '<%= yeoman.ftp_host_preprod %>'
					port: 21
					authKey: 'preprod'
				src: 'dist'
				dest: '<%= yeoman.ftp_dest_preprod %>'
				exclusions: ['dist/**/.DS_Store', 'dist/**/Thumbs.db', 'dist/build.txt']

		notify: 
			watch: 
				options: 
					title: 'Task Complete',  # optional
					message: 'Watch finished running', # required
					
			server: 
				options:
					message: 'Server is ready!'	

	grunt.event.on('watch', (action, filepath, target) ->
		if (target is 'coffee' and grunt.file.isMatch( grunt.config('watch.coffee.files'), filepath))
			grunt.config(['coffee', 'dev', 'src'], [filepath.replace(yeomanConfig.src+'/','')])

		if (target is 'jade' and grunt.file.isMatch( grunt.config('watch.jade.files'), filepath))
			fp = filepath.replace(yeomanConfig.src+'/views/','')
			grunt.config(['jade', 'dev', 'files'], [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: [fp]
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.html'
				])
	)

	grunt.registerTask('server', [
		'coffee:dev'
		'stylus:dev'
		'autoprefixer'
		'jade:dev'
		'connect:dev'
		# 'open:dev'
		'watch'
		'notify:server'
	])

	grunt.registerTask('server-dist', [
		'connect:dist'
		'open:dist'
		'watch'
	])

	grunt.registerTask('compile', [
		'jade:dist'
		'coffee:dist'
		'stylus:dist'
	])

	grunt.registerTask('seo', [
		'connect:dist'
		'escaped-seo:prod'
	])

	grunt.registerTask('seo-preprod', [
		'connect:dist'
		'escaped-seo:preprod'
	])

	grunt.registerTask('deploy', [
		'replace:close'
		'replace:nodev'
		'ftp-deploy:prod'
	])

	grunt.registerTask('deploy-preprod', [
		'ftp-deploy:preprod'
	])

	grunt.registerTask('build', [
		'clean:dist'
		'clean:tmp'
		'clean:tmp_dist'
		'jade:dist'
		'coffee:dist'
		'stylus:dist'
		'copy:dist'
		'useminPrepare'
		'imagemin'
		'htmlmin'
		'concat'
		'usemin'
		'requirejs:compile'
		'clean:css'
		'cssmin'
		'clean:js'
		'clean:tmp_dist'
		'clean:components'
		'clean:templates'
		'uglify'
	])
	grunt.option('force', true)

	grunt.registerTask('default', ['server'])	