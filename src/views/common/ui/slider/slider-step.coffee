define [
	'backbone'
	'underscore'
	'models/concept_model'
], (Backbone, _, Concept)->

	class CommonUiSliderSliderView extends Backbone.View

		events: {
			'mouseover' : 'onRollOver'
			'mouseout' : 'onRollOut'
			'click' : 'onClick'
		}

		el: null
		ref: null
		step: null
		pos: 0

		initialize: (options)->
			@ref = options.ref
			@step = options.step
			@pos= options.pos
			@render()
			
		render: ->
			@$el.addClass('step')
			@$el.css 'left', @pos*$(@ref.el).width()/100
			$('.steps',@ref.$('.bar')).append(@$el)

		onRollOver: (e) ->

		onRollOut: (e) ->

		onClick: (e) ->
			@ref.setPosition(@pos)