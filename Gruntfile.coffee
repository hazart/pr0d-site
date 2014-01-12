module.exports = (grunt)->
	grunt.loadNpmTasks('grunt-contrib-watch')
	grunt.loadNpmTasks('grunt-contrib-clean')
	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-connect')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-concat')
	grunt.loadNpmTasks('grunt-contrib-cssmin')
	grunt.loadNpmTasks('grunt-contrib-htmlmin')
	grunt.loadNpmTasks('grunt-contrib-imagemin')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-jade')
	grunt.loadNpmTasks('grunt-contrib-stylus')
	grunt.loadNpmTasks('grunt-contrib-requirejs')
	grunt.loadNpmTasks('grunt-mocha')
	grunt.loadNpmTasks('grunt-mocha-webdriver')
	grunt.loadNpmTasks('grunt-mocha-selenium')
	grunt.loadNpmTasks('grunt-open')
	grunt.loadNpmTasks('grunt-usemin')
	grunt.loadNpmTasks('grunt-ftp-deploy')
	grunt.loadNpmTasks('grunt-notify')
	grunt.loadNpmTasks('grunt-autoprefixer')
	grunt.loadNpmTasks('grunt-text-replace')
	grunt.loadNpmTasks('grunt-escaped-seo')

	# configurable variables
	yeomanConfig = {
		app: 'assets'
		src: 'src'
		dist: 'dist'
		test: 'tests'

		tmp: '.tmp'
		tmp_dist: '.tmp-dist'

		domain: 'pr0d.fr'
		domain_preprod: 'test.pr0d.fr'

		ftp_host: 'FTP.hazart.o2switch.net'
		ftp_dest: '/'

		ftp_host_preprod: 'FTP.hazart.o2switch.net'
		ftp_dest_preprod: 'test/'

		saucelabs_username: 'hazart'
		saucelabs_key: '759c578b-04fd-42b8-aafa-140670ae10b0'
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
				files: ['<%= yeoman.src %>/views/{,**/}*.styl']
				tasks: ['stylus:dev','autoprefixer']
				options: 
					livereload: true
					spawn: false
			
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
					'<%= yeoman.test %>/{,**/}*.js'
				]
				options:
					livereload: true

			dist:
				files: [
					'<%= yeoman.dist %>/{,**/}*.{css,js,html,png,jpg,jpeg}'
				]
				options:
					livereload: false

			unit:
				files: [
					'<%= yeoman.test %>/unit/{,**/}*.coffee'
				]
				tasks: ['coffee:unit','mocha:test']
				options: 
					livereload: false
					spawn: false

			func:
				files: [
					'<%= yeoman.test %>/func/{,**/}*.coffee'
				]
				tasks: ['coffee:func','mochaSelenium']
				options: 
					livereload: false
					spawn: false

		connect:
			dev:
				options:
					port: 9000
					# Change this to 'localhost' to access the server only local.
					hostname: '0.0.0.0'
					livereload: true
					middleware: (connect)->
						return [
							require('connect-modrewrite')([
								'/?(components/.*)$  /$1 [L]'
								'.*/?(js/.*)$  /$1 [L]'
								'!\\.(.*)$ / [L]'
							])
							connect.static(require('path').resolve(yeomanConfig.tmp))
							connect.static(require('path').resolve(yeomanConfig.app))
						]
			dist:
				options:
					port: 9001
					# Change this to 'localhost' to access the server only local.
					hostname: '0.0.0.0'
					middleware: (connect)->
						return [
							require('connect-modrewrite')([
								'/?(components/.*)$  /$1 [L]'
								'.*/?(js/.*)$  /$1 [L]'
								'!\\.(.*)$ / [L]'
							])
							connect.static(require('path').resolve(yeomanConfig.dist))
						]
			test:
				options:
					port: 9002
					hostname: '0.0.0.0'
					livereload: true
					middleware: (connect)->
						return [
							connect.static(require('path').resolve(yeomanConfig.test+"/unit/"))
							connect.static(require('path').resolve(yeomanConfig.tmp))
							connect.static(require('path').resolve(yeomanConfig.app))
						]				

		open:
			dev:
				path: 'http://localhost:<%= connect.livereload.options.port %>'
			dist:
				path: 'http://localhost:<%= connect.dist.options.port %>'
			test:
				path: 'http://localhost:<%= connect.test.options.port %>'

		clean:
			dist: ['<%= yeoman.dist %>']
			tmp: ['<%= yeoman.tmp %>']
			tmp_dist: ['<%= yeoman.tmp_dist %>']
			components: ['<%= yeoman.dist %>/components']
			templates: ['<%= yeoman.dist %>/templates']
			js: ['<%= yeoman.dist %>/js/config/init.js']
			build: ['<%= yeoman.dist %>/build.txt']

		coffee:
			dev:
				expand: true
				cwd: '<%= yeoman.src %>'
				src: ['**/*.coffee']
				dest: '<%= yeoman.tmp %>/js'
				ext: '.js'
				options: 
					runtime: 'inline'
					sourceMap: true
			dist:
				expand: true
				cwd: '<%= yeoman.src %>/'
				src: ['**/*.coffee']
				dest: '<%= yeoman.tmp %>/js'
				ext: '.js'
				options: 
					runtime: 'inline'
					sourceMap: false
			unit:
				expand: true
				cwd: '<%= yeoman.test %>/unit/src'
				src: ['**/*.coffee']
				dest: '<%= yeoman.test %>/unit/js'
				ext: '.js'
				options: 
					runtime: 'inline'
					sourceMap: false
			func:
				expand: true
				cwd: '<%= yeoman.test %>/func/src'
				src: ['**/*.coffee']
				dest: '<%= yeoman.test %>/func/js'
				ext: '.js'
				options: 
					runtime: 'inline'
					sourceMap: false

		stylus:
			dev:
				options:
					linenos: true
					# firebug: true
					sourcemaps: true
					compress: false
					paths: ['<%= yeoman.src %>']
					urlfunc: 'embedurl'
					import: ['config/config.styl', 'helpers/stylus_mixin.styl']
				files: [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: ['**/*.styl']
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.css'
				]

			dist:
				options:
					paths: ['<%= yeoman.src %>']
					urlfunc: 'embedurl'
					import: ['config/config.styl', 'helpers/stylus_mixin.styl']
				files: [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: ['**/*.styl']
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.css'
				]

		autoprefixer:
			options:
				browsers: ['last 3 version', 'ie 8']
			all: 
				expand: true
				src: '<%= yeoman.tmp %>/templates/**/*.css'

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
				# options:
				# 	report: 'gzip'
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
					mainConfigFile: '<%= yeoman.tmp_dist %>/js/config/init.js'
					optimize: ""

					modules: [
						{ name: 'vendors', exclude: [] }
						{ name: 'init', exclude: ['vendors', 'normalize'] }
						{ name: 'app', exclude: ['init', 'vendors', 'normalize'] }
						# view modules 
						{ name: 'views/home/home_view', exclude: ['vendors', 'init', 'app', 'normalize'] }
						{ name: 'views/concept/concept_view', exclude: ['vendors', 'init', 'app', 'normalize'] }
						{ name: 'views/offer/offer_view', exclude: ['vendors', 'init', 'app', 'normalize'] }
						{ name: 'views/blog/blog_view', exclude: ['vendors', 'init', 'app', 'normalize'] }
						{ name: 'views/references/references_view', exclude: ['vendors', 'init', 'app', 'normalize'] }
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
			server: 
				options:
					message: 'Server is ready!'					

			build: 
				options:
					# title: 'Task Complete', 
					message: 'Build is finished!'

		mocha:
			test:
				options:
					mocha:
						ignoreLeaks: false
					urls: ['http://localhost:<%= connect.test.options.port %>/']
					run: false
					reporter: 'Spec'
					log: true
					timeout: 60000

		mochaSelenium:
			options:
				timeout: 1000 * 60
				reporter: 'spec'
				useChaining: true
			phantom:
				src: ['<%= yeoman.test %>/func/**/*.js']
				options:
					browserName: 'phantomjs'
			# firefox:
			# 	src: ['<%= yeoman.test %>/func/**/*.js']
			# chrome:
			# 	src: ['<%= yeoman.test %>/func/**/*.js']
			# 	options:
			# 		browserName: 'chrome'

		mochaWebdriver:
			options:
				timeout: 1000 * 60
				reporter: 'spec'
				usePromises: true
				tunnelTimeout: 1000 * 180
				username: '<%= yeoman.saucelabs_username %>'
				key: '<%= yeoman.saucelabs_key %>'
			# phantom:
			# 	src: ['<%= yeoman.test %>/func/**/*.js']
			# 	options:
			# 		testName: 'phantom test'
			# 		usePhantom: true
			saucePromises:
				src: ['<%= yeoman.test %>/func/**/*.js']
				options:
					testName: 'PR0D sauce promises test 2'
					concurrency: 2
					usePromises: true
					browsers: [
						# {browserName: 'internet explorer', platform: 'Windows 7', version: '9'}
						# {browserName: 'internet explorer', platform: 'Windows 7', version: '8'}
						{browserName: 'chrome', platform: 'Windows 7', version: ''}
					]

	grunt.event.on('watch', (action, filepath, target) ->
		src = new RegExp('^'+yeomanConfig.src+'[\\/\\\\]', 'i');
		srcViews = new RegExp('^'+yeomanConfig.src+'[\\/\\\\]'+'views'+'[\\/\\\\]', 'i');

		if (target is 'coffee' and grunt.file.isMatch( grunt.config('watch.coffee.files'), filepath))
			grunt.config(['coffee', 'dev', 'src'], [filepath.replace(src,'')])

		if (target is 'coffee' and grunt.file.isMatch( grunt.config('watch.coffee.unit'), filepath))
			grunt.config(['coffee', 'unit', 'src'], [filepath.replace(src,'')])

		if (target is 'coffee' and grunt.file.isMatch( grunt.config('watch.coffee.func'), filepath))
			grunt.config(['coffee', 'func', 'src'], [filepath.replace(src,'')])

		if (target is 'jade' and grunt.file.isMatch( grunt.config('watch.jade.files'), filepath))
			fp = filepath.replace(srcViews,'')
			grunt.config(['jade', 'dev', 'files'], [
					expand: true
					cwd: '<%= yeoman.src %>/views'
					src: [fp]
					dest: '<%= yeoman.tmp %>/templates'
					ext: '.html'
				])

		if (target is 'stylus' and grunt.file.isMatch( grunt.config('watch.stylus.files'), filepath))
			fp = filepath.replace(srcViews,'')
			grunt.config(['stylus', 'dev', 'files', '0', 'src'], [filepath.replace(srcViews,'')])
			grunt.config(['autoprefixer', 'all', 'src'], '<%= yeoman.tmp %>/' + filepath.replace(srcViews,'templates/').replace('.styl','.css'))
	)

	grunt.registerTask('server', [
		'coffee:dev'
		'stylus:dev'
		'autoprefixer'
		'jade:dev'
		'connect:dev'
		'notify:server'
		'watch'
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
		'cssmin'
		'clean:js'
		'clean:tmp_dist'
		'clean:components'
		'clean:templates'
		'clean:build'
		'uglify:dist'
		'connect:dist'
		'notify:build'
		'watch:dist'
	])

	grunt.registerTask('server-dist', [
		'connect:dist'
		'open:dist'
		'watch:dist'
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

	grunt.registerTask('test-unit', [
		'coffee:unit'
		'connect:test'
		'mocha:test'
		'watch:unit'
	])

	grunt.registerTask('test-selenium', [
		'coffee:func'
		'mochaSelenium'
		'watch:func'
	])

	grunt.registerTask('test-sauce', [
		'coffee:func'
		'mochaWebdriver'
	])

	grunt.registerTask('deploy-preprod', [
		'ftp-deploy:preprod'
	])

	grunt.option('force', true)

	grunt.registerTask('default', ['server'])	