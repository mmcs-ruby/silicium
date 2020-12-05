require "test_helper"
require './lib/theory_of_probability'
require 'plotter'
require 'chunky_png'

class Test < Minitest::Test

	include Combinatorics
	include Silicium::Plotter
	include Dice
	include BernoulliTrials

	def test_bernoulli_formula_and_laplace_theorem
		assert_in_delta bernoulli_formula_and_laplace_theorem(5,3,100, 93), 0.0394, 0.0001
		assert_in_delta bernoulli_formula_and_laplace_theorem(6,4, 0.2), 0.0153, 0.0001
		assert_in_delta bernoulli_formula_and_laplace_theorem(400, 280, 0.75), 0.0033, 0.0001
		assert_in_delta bernoulli_formula_and_laplace_theorem(100, 13, 100, 15), 0.095, 0.001
	end

	def test_gaussian_function
		assert_in_delta gaussian_function(-0.23), 0.3885, 0.0001
		assert_in_delta gaussian_function(1.82), 0.0761, 0.0001
		assert_in_delta gaussian_function(0), 0.3989, 0.0001
		assert_in_delta gaussian_function(3.99), 0.0001, 0.0001
	end

	def test_factorial
		assert_equal factorial(10), 3628800
	end

	def test_fact
		assert_equal fact(7, 3), [5040, 24, 6]
	end

	def test_combination
		assert_equal combination(5, 3), 10
	end
	
	def test_arrangement
		assert_equal arrangement(5, 3), 60
	end

	def test_chance1
		s = PolyhedronSet.new([6, 6])
		assert s.percentage[5] - 0.1111111 < 0.0000001
	end

	def test_chance2
		s = PolyhedronSet.new([6, 6, 6])
		assert_equal s.percentage[10] - 0.125, 0
	end

	def test_chance3
		s = PolyhedronSet.new([[1,3,5], [2, 4, 6]])
		assert s.percentage[7] - 0.3333333 < 0.0000001
	end

end