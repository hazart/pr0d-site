define [
	'collections/concepts_collection'
], (Concepts)->
	describe 'Concepts collection', ->
		it 'class is not undefined', () ->
			Concepts.should.not.be.undefined
		# it 'instance is not undefined', () ->
		# 	concepts.should.not.be.undefined
		it 'return 8 values', () ->
			Concepts.length.should.be.equal(8)
