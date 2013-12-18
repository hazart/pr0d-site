chai = require("../../../assets/components/chai/chai.js")
chaiAsPromised = require("../../../assets/components/chai-as-promised/lib/chai-as-promised.js")
chai.use(chaiAsPromised)
chai.should()
# mocha.setup({ignoreLeaks: true})

fs = require('fs')

global.writeScreenshot = (data, name) ->
	name = name || 'ss.png'
	screenshotPath = 'tests/func/screenshots/'
	fs.writeFileSync(screenshotPath + name, data, 'base64')

describe 'Test initialization', ->
	it 'browser defined', () ->
		global.browser = @browser
		browser.on 'status', (info) ->
			console.log(info.cyan)

		browser.on 'command', (meth, path, data) ->
			console.log('\n> ' + meth.yellow, path.grey, data || '')