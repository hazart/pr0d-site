define [
	'backbone'
	'models/offer_model'
], (Backbone, Offer)->
	
	class OffersCollection extends Backbone.Collection
		
		model: Offer

		initialize: (options)->
			@add([
				new Offer({title: 'Tarifs', url: 'offre'})
				new Offer({title: 'Conseil et Accompagnement', url: 'offre/accompagnement'})
				new Offer({title: 'Estimations', url: 'offre/estimations'})
				new Offer({title: 'Architecture technique ou réalisation de prototypes', url: 'offre/architecture'})
				new Offer({title: 'Technologies et supports', url: 'offre/technos'})
			])		

		getTitleBySection: (section) ->
			c = @where({url:"concept/"+section})[0]
			return c.get("title")			
		
	Offers = new OffersCollection()