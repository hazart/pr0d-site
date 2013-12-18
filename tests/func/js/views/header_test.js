(function() {
  describe('Test Header view', function() {
    return it('title should change when the page change', function(done) {
      browser.get('http://localhost:9001/').title().should.become('PR0D - Production digitale');
      return setTimeout(function() {
        browser.takeScreenshot().elementByCss('.bt-offer').click().waitForElementByCss('.offer .slider', 10000);
        return setTimeout(function() {
          return browser.title().then().takeScreenshot().then().nodeify(done);
        }, 3000);
      }, 2000);
    });
  });

}).call(this);

/*
//@ sourceMappingURL=header_test.js.map
*/