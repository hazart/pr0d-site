define [
	'backbone'
], (Backbone)->

	class CommonUiEffectCrosslinesLine

		ctx: null
		x: null
		y: null
		dir: 0
		alpha: 0
		tic: 0
		nextX: null
		nextY: null

		constructor: (ctx, x, y) ->
			@ctx = ctx
			@x = x
			@y = y
			@dir = Math.round(Math.random()*4)
			@alpha = .1 + Math.random()*.2
			@gray = 190 + Math.round(Math.random()*65)
			@ctx.fillStyle = "rgba("+@gray+","+@gray+","+@gray+","+@alpha+")"
			@ctx.fillRect(x, y, 1, 1)

		update: () =>
			@tic++

			switch @dir
				when 0
					@nextX = @x + @tic
					@nextY = @y - @tic
				when 1
					@nextX = @x + @tic
					@nextY = @y + @tic
				when 2
					@nextX = @x - @tic
					@nextY = @y + @tic
				when 3
					@nextX = @x - @tic
					@nextY = @y - @tic

			@ctx.fillStyle = "rgba("+@gray+","+@gray+","+@gray+","+@alpha+")"
			@ctx.fillRect(@nextX, @nextY, 1, 1)

		turn: () ->
			@x = @nextX
			@y = @nextY
			@dir = Math.round(Math.random()*4)
			@tic = 0

			
