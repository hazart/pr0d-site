define [
	'backbone'
], (Backbone)->
	
	class OfferModel extends Backbone.Model
		
		defaults:
			key: "value"