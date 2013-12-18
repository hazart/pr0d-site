define [
	'backbone'
	'underscore'
	'text!templates/references/references.html'
	'css!templates/references/references.css'
], (Backbone, _, tpl, css)->

	class ReferencesView extends Backbone.View

		el: '.references'
		
		events: {}
		
		initialize: (options)->
			@render()	
			
		render: ->
			@$el.html _.template( tpl, {  } )

		setFiltre: (filtre) ->
			console.log "filtre -> "+filtre

		setId: (id) ->
			console.log "id -> "+id