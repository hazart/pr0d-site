define [
	'backbone'
	'models/concept_model'
], (Backbone, Concept)->
	
	class ConceptsCollection extends Backbone.Collection
		
		model: Concept

		initialize: (options)->
			@add([
				new Concept({title: 'Concepts et Convictions', url: 'concept'})
				new Concept({title: 'Externaliser la production', url: 'concept/externalisation'})
				new Concept({title: 'Optimiser les coûts', url: 'concept/couts'})
				new Concept({title: 'Agilité et modularité', url: 'concept/agilite'})
				new Concept({title: 'Un modèle optimal', url: 'concept/modele'})
				new Concept({title: 'Qualité du rendu', url: 'concept/qualite'})
				new Concept({title: 'Développement durable et équitable', url: 'concept/durable'})
				new Concept({title: 'Mise en place de process', url: 'concept/process'})
			])


	Concepts = new ConceptsCollection()
		