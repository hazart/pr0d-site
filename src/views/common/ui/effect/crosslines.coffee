define [
	'backbone'
	'views/common/ui/effect/crosslines-line'
], (Backbone, Line)->

	class CommonUiEffectCrosslines

		target: null
		w: 0
		h: 0		
		isOn: false

		canvas: null
		ctx: null
		lines: []

		tic: 0

		constructor: (target, srcImage) ->
			@target = target
			target.append('<canvas class="crosslines"></canvas>')
			@canvas = $('.crosslines')
			@ctx = @canvas[0].getContext('2d')
			$(window).bind 'resize',@onResize
			@onResize()
			@on()

		on: () ->
			@isOn = true
			@tic = 0
			@lines = []
			@update()

		off: () ->
			@isOn = false

		update: () =>
			@tic++
			# if @tic > 30
			# 	for i in [0...10] by 1
			# 		@lines.shift()

			if @tic <= Math.round(@w*@h/20000)
				# for i in [0...10] by 1
				y = Math.random() * @h
				p = y/@h
				p = Math.cos(p*1.2)
				x = 100 + @w - (@w*(1-p) + Math.random()*@w/3)
				@lines.push new Line(@ctx, x, y)

			for line in @lines
				line.update()
				if @tic % 10 is 0
					line.turn()

			@ticker = setTimeout(@update,15) if @isOn

		onResize:=>
			@w = @target.width()
			@h = @target.height()
			$('.crosslines').attr('width',@w)
			$('.crosslines').attr('height',@h)
												