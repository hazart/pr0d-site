define [
	'backbone'
], (Backbone)->
	
	class ReferenceModel extends Backbone.Model
		
		defaults:
			key: "value"