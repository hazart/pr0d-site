define [
	'backbone'
], (Backbone)->
	
	class ConceptModel extends Backbone.Model
		
		defaults:
			title: ""
			url: ""
