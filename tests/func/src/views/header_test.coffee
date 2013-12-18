describe 'Test Header view', ->

	it 'title should change when the page change', (done) ->
		browser.get('http://localhost:9001/')
		.title()
		.should.become('PR0D - Production digitale')
		setTimeout( () ->
			browser.takeScreenshot()
			# .then (data) ->
			# 	writeScreenshot(data, 'out_0.png')
			.elementByCss('.bt-offer')
			.click()
			.waitForElementByCss('.offer .slider', 10000)
			setTimeout( () ->
				browser.title()
				# .should.become('PR0D - Offre')
				.then()
				.takeScreenshot()
				# .then (data) ->
				# 	writeScreenshot(data, 'out_1.png')
				.then().nodeify(done)
			, 3000)
		, 2000)

		
