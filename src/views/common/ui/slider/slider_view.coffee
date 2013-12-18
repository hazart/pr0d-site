define [
	'backbone'
	'underscore'
	'text!templates/common/ui/slider/slider.html'
	'css!templates/common/ui/slider/slider.css'
	'views/common/ui/slider/slider-step'
], (Backbone, _, tpl, css, SliderStep)->

	class CommonUiSliderSliderView extends Backbone.View

		events:
			'mousedown .cursor': 'onCursorDown'

		steps: null
		
		initialize: (options)->
			@$el = options.el
			@steps = options.steps
			@render()
			
		render: ->
			@$el.html _.template( tpl, {  } )
			$('.cursor')
			if @steps.length >= 2
				firstStep = new SliderStep(
					pos: 0
					step: @steps.at(0)
					ref: @
				)
				lastStep = new SliderStep(
					pos: 100
					step: @steps.at(length-1)
					ref: @
				)
				if @steps.length >= 3
					for i in [1..@steps.length-2] by 1
						new SliderStep(
							pos: i*100/(@steps.length-1)
							step: @steps.at(i)
							ref: @
						)

		setPosition: (pos, flagTrigger = true) =>
			@$('.cursor').css('left',pos+"%")
			@.trigger('position', Math.round(pos)) if flagTrigger

		onCursorDown: (e) =>
			$(window).bind('mousemove',@onCursorMove)
			$(window).bind('mouseup',@onCursorUp)
			Backbone.mediator.trigger('lockScrollAnimation', true)
			@onCursorMove(e)
					
		onCursorUp: (e) =>
			$(window).unbind('mousemove', @onCursorMove)
			$(window).unbind('mouseup',@onCursorUp)
			Backbone.mediator.trigger('lockScrollAnimation', false )

		onCursorMove: (e) =>
			p = e.pageX - @$el.offset().left
			p = Math.max(0,p)
			p = Math.min(@$el.width(),p)
			@setPosition(Math.round(p/@$el.width()*100))
