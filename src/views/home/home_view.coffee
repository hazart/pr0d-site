define [
	'backbone'
	'underscore'
	'text!templates/home/home.html'
	'config'
	'gsap'
], (Backbone, _, tpl, Config, gsap)->

	class HomeView extends Backbone.View

		el: ".home"
		
		events: {
			'mouseover .cell' : 'onCellOver'
			'mouseout .cell' : 'onCellOut'
			'click .cell' : 'onCellClick'
		}
		
		initialize: (options)->
			@render()
			
		render: ->
			@$el.html _.template( tpl, {Config: Config} )
			inquire = [@$('p.vous'),@$('.level1:nth-child(1)'),@$('.level1:nth-child(2)'),@$('.level1:nth-child(3)'),@$('.level1:nth-child(4)'),@$('.level1:nth-child(5)'),@$('.level1:nth-child(6)')]
			TweenMax.staggerTo(inquire, .3, {opacity:1, delay:0}, .2)

		setProfil: (profil) ->

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
			if lvl is "1" and $('.cell.selected .cell').length
				$('.cell.selected[level=1] > .strut').hide()
				$('.cell.selected[level=1] > .label').hide()
				$('.cell.selected[level=1] .group').show()
				txt = '<a href="javascript:test(1)">' + $('.cell.selected[level=1] > .label').html()+'</a>'
				txt = txt.replace("<br>"," ")
				@$('p.vous').html("Vous êtes "+txt+" et ...")
			else if lvl is "1"
				$('.cell').hide()
				txt = $('.cell.selected[level=1] > .label').html()
				txt = '<a href="javascript:test(1)">' + txt.replace("<br>"," ")+'</a>'
				@$('p.vous').html("Vous êtes "+txt+" :")
				@$('p.advices').html($('.cell.selected[level=1] > .txt').html())
			else if lvl is "2"
				$('.cell').hide()
				txt = $('.cell.selected[level=2] > .label').html()
				txt = '<a href="javascript:test(2)">' + txt.replace("<br>"," ")+'</a>'
				console.log txt
				txt = @$('p.vous').html().replace("...","")+txt+" :"
				console.log txt
				@$('p.vous').html(txt)
				@$('p.advices').html($('.cell.selected[level=2] > .txt').html())
				e.stopPropagation()

			test: (lvl)->
				alert lvl
