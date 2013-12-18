(function() {
  var chai, chaiAsPromised, fs;

  chai = require("../../../assets/components/chai/chai.js");

  chaiAsPromised = require("../../../assets/components/chai-as-promised/lib/chai-as-promised.js");

  chai.use(chaiAsPromised);

  chai.should();

  fs = require('fs');

  global.writeScreenshot = function(data, name) {
    var screenshotPath;
    name = name || 'ss.png';
    screenshotPath = 'tests/func/screenshots/';
    return fs.writeFileSync(screenshotPath + name, data, 'base64');
  };

  describe('Test initialization', function() {
    return it('browser defined', function() {
      global.browser = this.browser;
      browser.on('status', function(info) {
        return console.log(info.cyan);
      });
      return browser.on('command', function(meth, path, data) {
        return console.log('\n> ' + meth.yellow, path.grey, data || '');
      });
    });
  });

}).call(this);

/*
//@ sourceMappingURL=base.js.map
*/