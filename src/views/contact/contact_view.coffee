define [
	'backbone'
	'underscore'
	'text!templates/contact/contact.html'
], (Backbone, _, tpl)->

	class ContactView extends Backbone.View

		el: ".contact"

		events: {}
		
		initialize: (options)->
			console.log "ok"
			@render()
			
		render: ->
			@$el.html _.template( tpl, {  } )

			styleMap = [ { "featureType": "landscape", "stylers": [ { "invert_lightness": true } ] },{ "featureType": "road.arterial", "stylers": [ { "lightness": 57 }, { "gamma": 1 } ] },{ "featureType": "poi.government", "stylers": [ { "visibility": "simplified" } ] },{ "featureType": "poi.medical", "stylers": [ { "color": "#80d9fc" }, { "visibility": "off" } ] },{ "featureType": "poi.park", "stylers": [ { "saturation": -50 }, { "invert_lightness": true } ] },{ "featureType": "poi.place_of_worship", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.school", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.sports_complex", "stylers": [ { "color": "#ed1dec" }, { "visibility": "off" } ] },{ "featureType": "poi.business", "stylers": [ { "visibility": "on" }, { "saturation": -100 }, { "lightness": -47 } ] },{ "elementType": "geometry.stroke", "stylers": [ { "visibility": "off" } ] },{ "featureType": "landscape", "elementType": "labels.icon", "stylers": [ { "visibility": "off" }, { "color": "#808080" } ] },{ "featureType": "poi", "stylers": [ { "visibility": "simplified" } ] },{ "featureType": "poi.medical", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi.school", "stylers": [ { "visibility": "off" } ] },{ "featureType": "transit.station", "stylers": [ { "visibility": "on" }, { "invert_lightness": true } ] },{ "elementType": "labels" } ]


