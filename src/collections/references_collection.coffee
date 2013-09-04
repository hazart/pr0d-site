define [
	'backbone'
	'models/reference_model'
], (Backbone, Reference)->
	
	class ReferencesCollection extends Backbone.Collection
		
		model: Reference

	References = new ReferencesCollection()
		