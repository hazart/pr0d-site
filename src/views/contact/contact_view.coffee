define [
	'backbone'
	'underscore'
	'text!templates/contact/contact.html'
	'css!templates/contact/contact.css'
	'views/common/ui/effect/revelation'
	'gsap'
], (Backbone, _, tpl, css, Revelation, gsap)->

	class ContactView extends Backbone.View

		el: ".contact"

		events: {}

		revelation: null
		
		initialize: (options)->
			@render()
			Backbone.mediator.on 'currentPart', @onChangePart
			
		render: ->
			@$el.html _.template( tpl, {  } )
			if (Modernizr.canvas)
				@revelation = new Revelation(@$('.district'), '/images/quartier.jpg')
			styleMap = [ { "featureType": "landscape", "stylers": [ { "invert_lightness": true } ] },{ "featureType": "road.arterial", "stylers": [ { "lightness": 57 }, { "gamma": 1 } ] },{ "featureType": "poi.government", "stylers": [ { "visibility": "simplified" } ] },{ "featureType": "poi.medical", "stylers": [ { "color": "#80d9fc" }, { "visibility": "off" } ] },{ "featureType": "poi.park", "stylers": [ { "saturation": -50 }, { "invert_lightness": true } ] },{ "featureType": "poi.place_of_worship", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.school", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.sports_complex", "stylers": [ { "color": "#ed1dec" }, { "visibility": "off" } ] },{ "featureType": "poi.business", "stylers": [ { "visibility": "on" }, { "saturation": -100 }, { "lightness": -47 } ] },{ "elementType": "geometry.stroke", "stylers": [ { "visibility": "off" } ] },{ "featureType": "landscape", "elementType": "labels.icon", "stylers": [ { "visibility": "off" }, { "color": "#808080" } ] },{ "featureType": "poi", "stylers": [ { "visibility": "simplified" } ] },{ "featureType": "poi.medical", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.school", "stylers": [ { "visibility": "off" } ] },{ "featureType": "transit.station", "stylers": [ { "visibility": "on" }, { "invert_lightness": true } ] },{ "elementType": "labels" } ]

		onChangePart: (part)=>
			if (Modernizr.canvas)
				if part is "contact"
					@revelation?.on()
				else
					@revelation?.off()


