require "test_helper"
require './lib/theory_of_probability'

class Test < Minitest::Test

	include Combinatorics

	def test_fact
		assert_equal fact(7, 3), [5040, 24, 6]
	end

	def test_combination
		assert_equal combination(5, 3), 10
	end
	
	def test_arrangement
		assert_equal arrangement(5, 3), 60
	end

end