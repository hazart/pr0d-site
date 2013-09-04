define [
	'backbone'
	'underscore'
	'text!templates/blog/blog.html'
], (Backbone, _, tpl)->

	class BlogView extends Backbone.View

		el: '.blog'
		
		events: {}
		
		
		initialize: (options)->
			@render()
			
		render: ->
			@$el.html _.template( tpl, {  } )