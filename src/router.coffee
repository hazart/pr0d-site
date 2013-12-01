define [
	'backbone'
	'views/app/app_view'
	'config'
	'collections/concepts_collection'
	'collections/offers_collection'
	'collections/references_collection'
], (Backbone, appView, Config, Concepts, Offers, References)->

	class Router extends Backbone.Router

		routes:
			'' 							: 'home'
			'/'							: 'home'
			'concept' 					: 'concept'
			'concept/:section' 			: 'concept'
			'offre'			 			: 'offer'
			'offre/:section' 			: 'offer'
			'references'	 			: 'references'
			'references/:filtre'		: 'references'
			'references/detail/:id'		: 'references'
			'blog'			 			: 'blog'
			'blog/tags/:tags'	 		: 'blog'
			'blog/post/:name'	 		: 'blog'
			'contact'	 				: 'contact'
			'*actions' 					: 'home'

		refViews: [
			{ route:'' }
		]

		views : {}

		lockUpdateRoute: false

		initialize: ()->
			appView.render()

			@refViews.push {route: concept.get('url')} for concept in Concepts.toArray()
			@refViews.push {route: offer.get('url')} for offer in Offers.toArray()
			@refViews.push {route: 'references'}

			Backbone.mediator.on 'move', @onMove
			Backbone.mediator.on 'lockUpdateRoute', (value) =>
				@lockUpdateRoute = value
			@bind 'route', @_trackPageview
			# Pour utiliser pushstate il faudrait que requirejs génère des balises scripts avec des sources en /
			Backbone.history.start( {pushState: true} )
			$(document).on 'click', 'a:not([data-bypass])', (evt) =>
				href = $(evt.currentTarget).attr('href');
				protocol = this.protocol + '//';
				if (href.slice(protocol.length) != protocol)
					evt.preventDefault();
					@navigate(href, true);

		home: (profil)->
			# console.log 'HOME'
			@goto view: 'views/home/home_view', callback: (view)->
				@.setProfil(profil) if (profil)
			Backbone.mediator.trigger('currentPart', 'home')
			@checkPos()

		concept: (section)->
			# console.log 'CONCEPT '+ section
			@goto view: 'views/concept/concept_view', callback: (view)->
				@.setSection(section) if (section)
			Backbone.mediator.trigger('currentPart', 'concept')
			@checkPos()

		offer: (section)->
			# console.log 'OFFER '+ section
			@goto view: 'views/offer/offer_view', callback: (view)->
				@.setSection(section) if (section)
			Backbone.mediator.trigger('currentPart', 'offer')
			@checkPos()

		references: (filtre, id)->
			# console.log 'REFERENCES : ' + filtre + ' : ' + id
			@goto view: 'views/references/references_view', callback: (view)->
				@.setFiltre(filtre) if (filtre) 
				@.setId(id) if (id)
			Backbone.mediator.trigger('currentPart', 'references')
			@checkPos()

		blog: (tags, name)->
			# console.log 'BLOG : ' + tags + ' : ' + name
			@goto view: 'views/blog/blog_view'
			Backbone.mediator.trigger('currentPart', 'blog')
			appView.checkContact()
			appView.checkBlog()

		contact: ()->
			# console.log 'CONTACT'
			@goto view: 'views/contact/contact_view'
			Backbone.mediator.trigger('currentPart', 'contact')
			appView.checkContact()

		goto: ({view, options, callback})->
			if @views[view]?
				callback.apply(@views[view]) if callback
				return
			else
				@loadView(view, options, callback)

		loadView: (view, options, callback) ->
			return if @views[view]?
			require [view], (View)=>
				@views[view] = new View(options)
				callback.apply(@views[view]) if callback

		checkPreload: (pos) ->
			@loadView('views/concept/concept_view') if 20 < pos < 100
			@loadView('views/offer/offer_view') if (Concepts.length+.7)*100 < pos < (Concepts.length+1)*100
			@loadView('views/references/references_view') if (Concepts.length+Offers.length+.7)*100 < pos < (Concepts.length+Offers.length+1)*100

		checkPos: ()->
			current = Backbone.history.getFragment()
			appView.checkContact()
			appView.checkBlog()
			for i in [0..@refViews.length-1] by 1
				if current is @refViews[i].route
					appView.checkPosition(i*100)

		onMove: (pos)=>
			return if @lockUpdateRoute or Backbone.history.getFragment() is 'blog' or appView.isBlogLayout
			for i in [0..@refViews.length-1] by 1
				if (i*100 <= pos < (i+1)*100)
					if Backbone.history.getFragment() isnt @refViews[i].route
						route = if @refViews[i].route is "" then "//" else @refViews[i].route
						Backbone.history.navigate(route,{trigger:true})
			@checkPreload(pos)

		_trackPageview: (e)->
			url = Backbone.history.getFragment()
			ga('send', {'hitType':'pageview','page':url}) unless Config.flagDev
			# console.log "Trackin ::> /#{url}"
