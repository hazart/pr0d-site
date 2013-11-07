define [
	'backbone'
	'underscore'
	'text!templates/home/home.html'
	'config'
	'views/common/ui/effect/crosslines'
	'gsap'
], (Backbone, _, tpl, Config, Crosslines, gsap)->

	class HomeView extends Backbone.View

		el: ".home"
		crosslines: null
		
		events: {
			'mouseover .cell' : 'onCellOver'
			'mouseout .cell' : 'onCellOut'
			'click .cell' : 'onCellClick'
			'click p.vous' : 'onClickSelection'
		}

		initialize: (options)->
			@render()
			Backbone.mediator.on 'currentPart', @onChangePart
			
		render: ->
			@$el.html _.template( tpl, {Config: Config} )

			directAdvices = false
			if $.cookie('homeChoice')
				lvl1 = $.cookie('homeChoice').split('+')[0]
				lvl2 = $.cookie('homeChoice').split('+')[1]
				
				@$('.cell[level=1]').addClass('notselected')
				@$('.level1:nth-child('+lvl1+')').removeClass('notselected')
				@$('.level1:nth-child('+lvl1+')').addClass('selected')
				@setLevel1()

				if lvl2?
					@$('.level1.selected .cell:nth-child('+lvl2+')').addClass('selected')
					@setLevel2()
					directAdvices = true
				else if @$('.level1:nth-child('+lvl1+') .cell').length < 1
						directAdvices = true
				
			inquire = [@$('p.vous')]
			if directAdvices
				inquire.push(@$('p.advices'))
			else
				inquire.push(@$('.level1:nth-child(1)'),@$('.level1:nth-child(2)'),@$('.level1:nth-child(3)'),@$('.level1:nth-child(4)'),@$('.level1:nth-child(5)'),@$('.level1:nth-child(6)'))

			TweenMax.staggerTo(inquire, .3, {opacity:1, delay:0}, .2)
			
			@crosslines = new Crosslines(@$('.back'))

		setProfil: (profil) ->

		setLevel1: () ->
			if $('.cell.selected[level=1] .cell').length > 0
				@$('.cell.selected[level=1] > .strut').hide()
				@$('.cell.selected[level=1] > .label').hide()
				@$('.cell.selected[level=1] .group').show()
				txt = '<a href="javascript:backTo(1)">' + $('.cell.selected[level=1] > .label').html()+'</a>'
				txt = txt.replace("<br>"," ")
				@$('p.vous').html("Vous êtes "+txt+" et ...")
			else
				$('.cell').hide()
				txt = $('.cell.selected[level=1] > .label').html()
				txt = '<a href="javascript:backTo(1)">' + txt.replace("<br>"," ")+'</a>'
				@$('p.vous').html("Vous êtes "+txt+".")
				@$('p.advices').html($('.cell.selected[level=1] > .txt').html())
				TweenMax.to(@$('p.advices'), .3, ({opacity:1}))
			for i in [0...$('.cell[level=1]').length] by 1
				if $($('.cell[level=1]')[i]).hasClass('selected')
					$.cookie('homeChoice',i+1)

		setLevel2: () ->
			$('.cell').hide()
			txt = $('.cell.selected[level=2] > .label').html()
			txt = '<a href="javascript:backTo(2)">' + txt.replace("<br>"," ")+'</a>'
			txt = @$('p.vous').html().replace("...","")+txt+"."
			@$('p.vous').html(txt)
			@$('p.advices').html($('.cell.selected[level=2] > .txt').html())
			TweenMax.to(@$('p.advices'), .3, ({opacity:1}))
			for i in [0...$('.cell[level=1]').length] by 1
				if $($('.cell[level=1]')[i]).hasClass('selected')
					for j in [0...$('.cell.selected[level=1] .cell[level=2]').length] by 1
						if $($('.cell.selected[level=1] .cell[level=2]')[j]).hasClass('selected')
							$.cookie('homeChoice',(i+1)+'+'+(j+1))

		resetLevel1: () ->
			TweenMax.to(@$('.cell[level=1]'), .3, ({opacity:1}))
			@$('.cell[level=1] > .strut').show()
			@$('.cell[level=1] > .label').show()
			@$('.cell[level=1] .group').hide()			
			@$('.cell[level=1]').removeClass('selected')
			@$('.cell[level=1]').removeClass('notselected')
			@$('.cell[level=1]').removeClass('striped')
			@$('p.vous').html("Vous êtes ...")
			@$('p.advices').html("")
			TweenMax.to(@$('p.advices'), .3, ({opacity:0}))
			$.removeCookie('homeChoice')

		resetLevel2: () ->
			TweenMax.to(@$('.cell[level=1]'), .3, ({opacity:1}))
			@$('.cell[level=2]').removeClass('selected')
			@$('.cell[level=2]').removeClass('notselected')
			@$('.cell[level=2]').removeClass('striped')
			txt = '<a href="javascript:backTo(1)">' + $('.cell.selected[level=1] > .label').html()+'</a>'
			txt = txt.replace("<br>"," ")
			@$('p.vous').html("Vous êtes "+txt+" et ...")
			@$('p.advices').html("")
			TweenMax.to(@$('p.advices'), .3, ({opacity:0}))
			for i in [0...$('.cell[level=1]').length] by 1
				if $($('.cell[level=1]')[i]).hasClass('selected')
					$.cookie('homeChoice',i+1)

		onCellOver: (e) ->
			lvl = $(e.currentTarget).attr('level')
			@$('.cell[level='+lvl+']').addClass('striped')
			$(e.currentTarget).removeClass('striped')

		onCellOut: (e) ->
			lvl = $(e.currentTarget).attr('level')
			@$('.cell[level='+lvl+']').removeClass('striped')

		onCellClick: (e) ->
			lvl = $(e.currentTarget).attr('level')
			@$('.cell[level='+lvl+']').removeClass('selected')
			@$('.cell[level='+lvl+']').addClass('notselected')
			$(e.currentTarget).removeClass('notselected')
			$(e.currentTarget).addClass('selected')
			if lvl is "1"
				@setLevel1()
			else if lvl is "2"
				@setLevel2()
				e.stopPropagation()

		onClickSelection: (e)->
			if e.target.href is "javascript:backTo(1)"
				@resetLevel2()
				@resetLevel1()
				$('.cell').show()
			else if e.target.href is "javascript:backTo(2)"
				@resetLevel2()
				$('.cell').show()
			e.preventDefault()

		onChangePart: (part)=>
			if part is "home"
				@crosslines.on()
			else
				@crosslines.off()

