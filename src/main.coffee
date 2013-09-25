requirejs.config
	baseUrl: './js'
	shim:
		'underscore':
			exports: '_'
		'jquery':
			exports: '$'
		'backbone':
			deps: ['underscore', 'jquery']
			exports: 'Backbone'
		'modernizr':
			exports: 'Modernizr'
		'gsap':
			exports: 'TweenMax'
		'jquery.cookie':
			deps: ['jquery']
			exports: '$'

	paths:
		'underscore': 	'../components/underscore/underscore'
		'backbone': 	'../components/backbone/backbone'
		'jquery': 		'../components/jquery/jquery'
		'text' : 		'../components/requirejs-text/text'
		'domReady': 	'../components/domReady/domReady'
		'modernizr':	'../components/modernizr/modernizr'
		'gsap':		 	'../components/gsap/src/uncompressed/TweenMax'
		'templates':	'../templates'

		'jquery.cookie':'../components/jquery.cookie/jquery.cookie'

		'config': 		'config/config_base'

if !window.isTest
	require ['vendors'], ->

		require ['app'], (App) ->
			App.initialize()