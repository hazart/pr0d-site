define [
	'backbone'
	'underscore'
	'text!templates/home/home.html'
	'config'
], (Backbone, _, tpl, Config)->

	class HomeView extends Backbone.View

		el: ".home"
		
		events: {
			'click .cell' : 'onCellClick'
		}
		
		initialize: (options)->
			@render()
			
		render: ->
			@$el.html _.template( tpl, {Config: Config} )

		setProfil: (profil) ->

		onCellClick: (e) ->
			lvl = $(e.currentTarget).attr('level')
			@$('.cell[level='+lvl+']').removeClass('selected')
			@$('.cell[level='+lvl+']').addClass('notselected')
			$(e.currentTarget).removeClass('notselected')
			$(e.currentTarget).addClass('selected')
			if lvl is "1"
				$('.cell.selected[level=1] > .label').hide()
				$('.cell.selected[level=1] .group').show()
