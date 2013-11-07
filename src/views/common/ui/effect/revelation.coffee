define [
	'backbone'
	'underscore'	
], (Backbone, _)->

	class CommonUiEffectRevelation

		target: null
		img: null
		srcImage: null
		w: 0
		h: 0
		
		canvasCopy: null
		canvasMask: null

		ctxCopy: null
		ctxMask: null
		
		imageDataCopy: null
		imageDataMask: null

		mouseX: -10000
		mouseY: -10000
		currentX: - 10000
		currentY: - 10000
		hasMove: 0

		ticker: null
		isOn: false

		constructor: (target, srcImage) ->
			@target = target
			@srcImage = srcImage
		
			target.after('<canvas class="revelation revelation-mask"></canvas>')
			target.after('<canvas class="revelation revelation-copy" style="opacity: 0"></canvas>')
			
			@canvasCopy = $('.revelation-copy')
			@canvasMask = $('.revelation-mask')

			@ctxCopy = @canvasCopy[0].getContext('2d')
			@ctxMask = @canvasMask[0].getContext('2d')

			$(window).bind 'resize',@onResize

			@setImages()

		on: () ->
			@isOn = true
			$(document).bind('mousemove',@updatePosition)
			@ticker = setTimeout(@updateMask, 20)

		off: () ->
			@isOn = false
			$(document).unbind('mousemove',@updatePosition)
			clearInterval(@ticker)
			@shutdown()

		setImages: ->
			@img = new Image();
			@img.onload = =>
				@onResize()
				@on()
			@img.src = @srcImage

		createCopy: =>
			ratioSrc = @img.width / @img.height
			ratioOut = @w / @h

			if ratioSrc > ratioOut
				sh = @img.height
				sw = sh * @w / @h
				sx = (@img.width - sw)/2
				sy = 0

			else
				sw = @img.width
				sh = sw * @h / @w
				sx = 0
				sy = (@img.height - sh)/2

			@ctxCopy.drawImage(@img, sx, sy, sw, sh, 0, 0, @w, @h)
			@imageDataCopy = @ctxCopy.getImageData(0, 0, @w, @h)
			@imageDataMask = @ctxMask.createImageData(@w, @h)

		updatePosition: (e) =>
			@mouseX = e.clientX
			@mouseY = e.clientY
			if @currentX is -10000
				@currentX = @mouseX
				@currentY = @mouseY
			@hasMove = Math.max(0, @hasMove - 30)
			
		updateMask: () =>
			if @currentX is - 10000 or @hasMove is @w * 1.3 or @img.width < 10
				@ticker = setTimeout(@updateMask, 20) if @isOn
				return
			pos = 0
			@currentX = @currentX + (@mouseX - @currentX) / 4
			@currentY = @currentY + (@mouseY - @currentY) / 4
			for y in [0..@h-1] by 1
				for x in [0..@w-1] by 1
					x2 = x - @currentX
					y2 = y - @currentY
					d = Math.sqrt(x2*x2 + y2*y2)
					a = @imageDataMask.data[pos+3]
					n = 80 + @hasMove - d
					if a > n
						a = a + (n - a) / 80
					else
						a = a + (n - a)

					@imageDataMask.data[pos++] = @imageDataCopy.data[pos-1]
					@imageDataMask.data[pos++] = @imageDataCopy.data[pos-1]
					@imageDataMask.data[pos++] = @imageDataCopy.data[pos-1]
					@imageDataMask.data[pos++] = Math.max(0,Math.min(255, a))

			@ctxMask.putImageData(@imageDataMask, 0, 0)
			@hasMove = Math.min(@w*1.3, @hasMove + 2)
			@ticker = setTimeout(@updateMask, 10) if @isOn

		shutdown: () ->
			return if @currentX is - 10000 or @hasMove is @w * 1.3 or @img.width < 10
			pos = 0
			for y in [0..@h-1] by 1
				for x in [0..@w-1] by 1
					@imageDataMask.data[pos++] = 0
					@imageDataMask.data[pos++] = 0
					@imageDataMask.data[pos++] = 0
					@imageDataMask.data[pos++] = 0
			@ctxMask.putImageData(@imageDataMask, 0, 0) 					

		onResize:=>
			@w = @target.width()
			@h = @target.height()
			$('.revelation').attr('width',@w)
			$('.revelation').attr('height',@h)
			@createCopy()
