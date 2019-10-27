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

	include Cubes

	def test_chance1
		s = Set_Of_Polyhedrons.new([6, 6])
		assert s.percentage["5"] - 0.1111111 < 0.0000001
	end

	def test_chance2
		s = Set_Of_Polyhedrons.new([6, 6, 6])
		assert_equal s.percentage["10"] - 0.125, 0
	end

	def test_chance3
		s = Set_Of_Polyhedrons.new([[1,3,5], [2, 4, 6]])
		assert s.percentage["7"] - 0.3333333 < 0.0000001
	end

end