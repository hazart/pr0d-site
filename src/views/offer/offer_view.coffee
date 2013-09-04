define [
	'backbone'
	'underscore'
	'text!templates/offer/offer.html'
	'views/common/ui/slider/slider_view'
	'collections/concepts_collection'
	'collections/offers_collection'
	'views/app/app_view'	
], (Backbone, _, tpl, Slider, Concepts, Offers, AppView)->

	class OfferView extends Backbone.View

		el: '.offer'
		
		events: {}
		
		slider: null

		initialize: (options)->
			@render()
			Backbone.mediator.on 'move', @onMove
			
		render: ->
			@$el.html _.template( tpl, {  } )
			@slider = new Slider(steps:Offers, el: @$('.slider'))
			@slider.bind('position', @onSliderUpdate)

		setSection: (section) ->
			# console.log "section "+section

		onSliderUpdate: (pos) =>
			AppView.setPosition(100+Concepts.length*100+(Offers.length-1)*pos)

		onMove: (pos) =>
			return unless (100+Concepts.length*100 < pos < Concepts.length*100+Offers.length*100)
			@slider.setPosition( (pos-(Concepts.length+1)*100) / (Offers.length-1), false)