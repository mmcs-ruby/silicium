require "test_helper"
require './lib/theory_of_probability'

class Test < Minitest::Test

	include Combinatorics

	def test_combination
		assert_equal Combination(5, 3), 10
	end
	
	def test_arrangement
		assert_equal Arrangement(5, 3), 60
	end


end