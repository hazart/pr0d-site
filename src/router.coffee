define [
	'backbone'
	'views/app/app_view'
], (Backbone, appView)->

	class Router extends Backbone.Router

		routes:
			'/' : 'home'
			'*actions' : 'defaultAction'

		initialize: ()->
			appView.render()
			Backbone.history.start()

		home: (actions)->
			console.log "okkkk"

		defaultAction: (actions)->
			console.log "Unhandled route #{actions}"
