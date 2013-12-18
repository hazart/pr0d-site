define [
	'backbone'
	'underscore'
	'text!templates/blog/blog.html'
	'css!templates/blog/blog.css'
], (Backbone, _, tpl, css)->

	class BlogView extends Backbone.View

		el: '.blog'
		
		events: {}
		
		
		initialize: (options)->
			@render()
			
		render: ->
			@$el.html _.template( tpl, {  } )