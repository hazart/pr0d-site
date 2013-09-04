define [
	'backbone'
	'underscore'
	'config'
	'text!templates/app/app.html'
	'gsap'
	'views/header/header_view'	
	'views/contact/contact_view'	
	'gsap'
], (Backbone, _, Config, tpl, gsap, Header, Contact, Gsap)->

	class App extends Backbone.View
		
		el: "#total"
		
		events: {
		}

		header: null
		hFooter: 60
		hWindow: 0
		twnContact: null

		currentPart: null
		isBlogLayout: false

		currentPosition: 0
		nbScreenConcept: 8
		nbScreenOffer: 6

		lockScrollAnimation: false
		
		initialize: (options)->
			Backbone.mediator = _.extend({}, Backbone.Events)
			$(window).bind 'resize',@onResize
			$(window).bind 'scroll', @onScroll

			Backbone.mediator.on 'lockUpdateRoute', (value) =>
				@lockUpdateRoute = value

			Backbone.mediator.on 'lockScrollAnimation', (value) =>
				@lockScrollAnimation = value

			Backbone.mediator.on 'currentPart', (value) =>
				@currentPart = value

		render: ->
			@$el.html _.template( tpl, {  } )
			@header = new Header()
			@updateHeight()

			if Config.flagClose
				@$('.dummy').hide()
				@$('.concept').hide()
				@$('.offer').hide()
				@$('.references').hide()
				@$('#header').hide()				
				@$('.blog').hide()				
				@$('.contact').hide()				

		updateHeight:->
			@hWindow = $(window).height()
			@$('.dummy').css('height', (@hWindow - @hFooter) + (@nbScreenConcept + @nbScreenOffer)* @hWindow)
			@$('.home').css('height', @hWindow)
			@$('.contents').css('top', @hWindow - @hFooter)
			@$('.contents>div').css('height', @hWindow)
			@$('.contents .references').css('top', @hWindow)
			@$('div.contact').css('height', @hWindow - @hFooter)
			@$('div.contact').css('top', -@hWindow + @hFooter + 5)
			# @$('div.contact').css('top', if parseInt(@$('div.contact').css('top')) < 0 then -@hWindow + @hFooter + 5 else 0)
			@updatePosition()


		checkPosition: (pos) ->
			@setPosition(pos) unless Math.abs(@currentPosition - pos) < 100

		setPosition: (pos) =>
			d = Math.round(@hWindow-@hFooter + (pos-100)/100*@hWindow)
			if Math.abs($(window).scrollTop() - d) > 2
				Backbone.mediator.trigger('lockUpdateRoute', true) unless @lockScrollAnimation
				t = if @lockScrollAnimation then 0 else 800
				$('body,html').animate({scrollTop: d}, t, (e)=>
					Backbone.mediator.trigger('lockUpdateRoute', false) unless @lockScrollAnimation
				)
				@updatePosition()

		updatePosition: ()->
			return unless @currentPart? or @currentPart is 'blog' or @currentPart is 'contact'
			nextScroll = $(window).scrollTop()
			
			if (nextScroll < @hWindow-@hFooter)
				@currentPosition = nextScroll/(@hWindow-@hFooter)*100
			else
				@currentPosition = 100 + (nextScroll-(@hWindow-@hFooter))/@hWindow*100
			
			if @currentPosition < 100
				@$('.contents').css('top', @hWindow - @hFooter - nextScroll)
			else if 100 <= @currentPosition < (@nbScreenConcept)*100
				@$('.contents').css('top', 0)
			# else if (@nbScreenConcept)*100 <= @currentPosition < (@nbScreenConcept+@nbScreenOffer-1)*100
			# 	@$('.contents').css('top', - Math.min( @hWindow, (@currentPosition/100-(@nbScreenConcept))*@hWindow ))
			# else if (@nbScreenConcept+@nbScreenOffer-1)*100 <= @currentPosition
			# 	@$('.contents').css('top', - @hWindow - Math.min( @hWindow, (@currentPosition/100-(@nbScreenConcept+@nbScreenOffer-1))*@hWindow ))
			else if (@nbScreenConcept)*100 <= @currentPosition
				@$('.contents').css('top', - Math.min( @hWindow, (@currentPosition/100-(@nbScreenConcept))*@hWindow ))
				if (@nbScreenConcept+@nbScreenOffer-1)*100 <= @currentPosition
					dh = $(window).width() - (@currentPosition/100 - (@nbScreenConcept+@nbScreenOffer-1)) * $(window).width()
				else 
					dh = $(window).width()
				@$('.contents .references').css('left', dh)
			Backbone.mediator.trigger('move', @currentPosition)

		checkContact: ->
			if @currentPart is 'contact'
				unless @twnContact?
					@twnContact = new TweenMax('div.contact',.6,{top:0})
				else unless TweenMax.isTweening('.bt-contact') and !@twnContact.reversed()
					@twnContact.play()
			else if @twnContact?
				@twnContact.reverse() unless (TweenMax.isTweening('div.contact') and @twnContact.reversed())
			@header.checkContact()

		checkBlog: ->
			if @currentPart is 'blog' and !@isBlogLayout
				@currentPosition = null
				@$('.contents').css('top', 0)
				@$('.dummy').hide()
				@$('.concept').hide()
				@$('.offer').hide()
				@$('.references').hide()
				@$('.home').hide()
				@$('.blog').show()
				$(window).scrollTop(0)
				@isBlogLayout = true

			else if @currentPart isnt 'blog' and @isBlogLayout
				@$('.dummy').show()
				@$('.concept').show()
				@$('.offer').show()
				@$('.references').show()
				@$('.home').show()
				@$('.blog').hide()
				Backbone.mediator.trigger('lockUpdateRoute', true)
				$(window).scrollTop(0)
				Backbone.mediator.trigger('lockUpdateRoute', false)
				@isBlogLayout = false

			else
				return

			@header.checkBlog()

		# Events
		onScroll: (e) =>
			@updatePosition()

		onResize:=>
			@updateHeight()

	appView = new App()