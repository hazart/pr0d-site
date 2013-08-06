define [
	'backbone'
	'underscore'
	'text!templates/app/app.html'
], (Bacbone, _, tpl)->

	class App extends Backbone.View
		
		el: "#total"
		
		events: {}
		
		initialize: (options)->
			
			
		render: ->
			@$el.html _.template( tpl, {  } )
			element = @$('.test')
			
	appView = new App()