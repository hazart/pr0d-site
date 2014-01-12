define [
	'backbone'
	'underscore'
	'text!templates/header/header.html'
	'css!templates/header/header.css'
], (Backbone, _, tpl, css)->

	class HeaderView extends Backbone.View

		el: '#header'

		hFooter: 60

		currentPart: null
		twnContact: null

		events: {
			# 'click .bt-blog' : 'onClick'
			# 'click #logo-home' : 'onLogoClick'
			'mouseover #logo-home' : 'onLogoOver'
			'mouseout #logo-home' : 'onLogoOut'
			'click .bt-contact' : 'checkContact'
		}
		
		initialize: (options)->
			Backbone.mediator.on 'move', @onMove
			Backbone.mediator.on 'currentPart', @onChangePart
			$(window).bind 'resize',@onResize
			@render()

		render: ->
			@$el.html _.template( tpl, {  } )
			@updatePosition(0)

		updatePosition: (pos) ->
			dh = if ($(window).scrollTop() > $(window).height()-@hFooter) then 0 else $(window).height()-@hFooter-$(window).scrollTop()
			dh = 0 if @currentPart is 'blog' or $('.bt-contact').hasClass('inverted')

			@$('.bt-menu.moving').css('top', dh + 20)
			@$('#logo-shadow').css('top', dh + 5)
			topLogo = Math.min(dh+5,70)
			@$('#logo-home').css('top', topLogo)
			if topLogo >= 70 then @$('#logo-home').addClass('open') else @$('#logo-home').removeClass('open')

		checkBlog: ->
			if @currentPart is 'blog'
				@$('a').addClass('inverted')
			else
				@$('a').removeClass('inverted')
			@updatePosition()

		checkContact: (e)->
			if e? and $(e.target).parents().index($('.contact')) is -1 and $(e.target).parents().index($(header)) is -1
				if $('.bt-contact').hasClass('inverted')
					Backbone.history.navigate('blog',{trigger:true})
				else
					$(window).scrollTop($(window).scrollTop()+1)
					$(window).scrollTop($(window).scrollTop()-1)
				return
			else if e? and $(e.target).parents().index($(header)) is -1
				return

			flagOpen = true
			if @currentPart is 'contact'
				flagOpen = true
				flagOpen = false if (e)
			else
				flagOpen = false

			if flagOpen
				unless @twnContact?
					@twnContact = new TweenMax('.bt-contact',.6,{top:$(window).height()-@hFooter + 20})
				else unless TweenMax.isTweening('.bt-contact') and !@twnContact.reversed()
					@twnContact.play()
				@$('.bt-contact').css({color: "#000"})
				$('.bt-contact').addClass('.selected')
				$(document).bind('click', (e) => @checkContact(e))
			else if @twnContact?
				if @currentPart is 'contact'
					if $('.bt-contact').hasClass('inverted')
						Backbone.history.navigate('blog',{trigger:true})
					else
						$(window).scrollTop($(window).scrollTop()+1)
						$(window).scrollTop($(window).scrollTop()-1)
					e.stopPropagation()
					e.preventDefault()
					return
				@twnContact.reverse() unless (parseInt(@$('.bt-contact').css('top')) is 20) or (TweenMax.isTweening('.bt-contact') and @twnContact.reversed())
				@$('.bt-contact').css({color: "#FFF"})
				$('.bt-contact').removeClass('.selected')
				$(document).unbind('click')
					
		# Events
		# onLogoClick: (e)->
		# 	Backbone.history.navigate('home',{trigger:true})
		# 	e.preventDefault()

		onLogoOver: (e)->
			$('#logo-home').addClass('open')

		onLogoOut: (e)->
			if parseInt(@$('#logo-home').css('top')) >= 60 then @$('#logo-home').addClass('open') else @$('#logo-home').removeClass('open')

		onMove: (pos)=>
			@updatePosition(pos)

		onChangePart: (part)=>
			@currentPart = part
			@$('.bt-menu').removeClass('selected')
			@$('.bt-'+part).addClass('selected')
				
		onResize: (e) =>
			@updatePosition()
			@twnContact = null

