(function() {
  define(['collections/concepts_collection'], function(Concepts) {
    return describe('Concepts collection', function() {
      it('class is not undefined', function() {
        return Concepts.should.not.be.undefined;
      });
      return it('return 8 values', function() {
        return Concepts.length.should.be.equal(8);
      });
    });
  });

}).call(this);

/*
//@ sourceMappingURL=concepts_test.js.map
*/