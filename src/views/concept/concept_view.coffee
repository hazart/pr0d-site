define [
	'backbone'
	'underscore'
	'text!templates/concept/concept.html'
	'views/common/ui/slider/slider_view'
	'collections/concepts_collection'
	'views/app/app_view'
	'gsap'
], (Backbone, _, tpl, Slider, Concepts, AppView, gsap)->

	class ConceptView extends Backbone.View

		el: '.concept'
		
		events: {}

		slider: null
		tl: null

		initialize: (options)->
			@tl = new TimelineLite()
			@render()
			Backbone.mediator.on 'move', @onMove
			
		render: ->
			@$el.html _.template( tpl, { Concepts: Concepts } )
			@slider = new Slider(steps:Concepts, el: @$('.slider'))
			@slider.bind('position', @onSliderUpdate)
			@tl.from('.page1 h2', .5, {autoAlpha:0, left: 100})
			.from('.page1 .txt-concept', .5, {autoAlpha:0, left: 100})
			.from('.page1 .txt-convictions', .5, {autoAlpha:0, left: 100})
			.to('.page1 .txt-concept', .5, {autoAlpha:0, left: 100}, "+=5.5")
			.to('.page1 .txt-convictions', .5, {autoAlpha:0, left: 100})
			.to('.page1 h2', .5, {autoAlpha:0, left: 100})
			.from('.page2 h2', .5, {autoAlpha:0, left: 100})
			.from('.page2 .txt-concept', .5, {autoAlpha:0, left: 100})
			.from('.page2 .txt-convictions', .5, {autoAlpha:0, left: 100})

			.to('.page2 .txt-concept', .5, {autoAlpha:0, left: 100}, "+=8")
			.to('.page2 .txt-convictions', .5, {autoAlpha:0, left: 100})
			.to('.page2 h2', .5, {autoAlpha:0, left: 100})
			.from('.page3 h2', .5, {autoAlpha:0, left: 100})

			.to('.page3 h2', .5, {autoAlpha:0, left: 100}, "+=9")
			.from('.page4 h2', .5, {autoAlpha:0, left: 100})

			.to('.page4 h2', .5, {autoAlpha:0, left: 100}, "+=9")
			.from('.page5 h2', .5, {autoAlpha:0, left: 100})

			.to('.page5 h2', .5, {autoAlpha:0, left: 100}, "+=9")
			.from('.page6 h2', .5, {autoAlpha:0, left: 100})

			.to('.page6 h2', .5, {autoAlpha:0, left: 100}, "+=9")
			.from('.page7 h2', .5, {autoAlpha:0, left: 100})

			.to('.page7 h2', .5, {autoAlpha:0, left: 100}, "+=9")
			.from('.page8 h2', .5, {autoAlpha:0, left: 100})
			@tl.pause()

		setSection: (section) ->
			# console.log "section "+section

		onSliderUpdate: (pos) =>
			AppView.setPosition(100+(Concepts.length-1)*pos)

		onMove: (pos) =>
			return unless (100 < pos < Concepts.length*100)
			p = (pos-100)/(Concepts.length-1)
			@slider.setPosition(p, false)
			@tl.progress(p/100)
			