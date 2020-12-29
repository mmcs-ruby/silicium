require "test_helper"
require './lib/theory_of_probability'
require 'plotter'
require 'chunky_png'

class Test < Minitest::Test

	include Combinatorics
	include Silicium::Plotter
	include Dice
	include Distribution

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


	def test_binomial_coefficient2
		assert_equal binomial_coefficient(3, 2), 3
	end

	def test_binomial_func
		assert_equal binomial_func(1134, 0.015,20 ), 0.06962037106916616
	end

	def test_binomial_func1
		assert_equal binomial_func(-1,0.1,3), -1
	end

	def test_binomial_func2

		assert_equal binomial_func(200,2,3), -1
	end

	def test_binomial_func3
		assert_equal binomial_func(1,0.1,3), -1
	end

	def test_Posson
		assert_equal poisson_func(1700,0.01,17).round(5), 0.09628
	end

	def test_Posson1
		assert_equal poisson_func(-1,0.01,17), -1
	end

	def test_Posson2
		assert_equal poisson_func(-1,2,17), -1
	end

	def test_Posson3
		assert_equal poisson_func(1,0.01,17), -1
	end

	def test_Posson4
		assert_equal poisson_func(10,0.001,1).round(7), 0.0099005
	end

	def test_binomial_distribution
		assert_equal binomial_distribution(3,0.01,0).round(4), 0.9703
	end

	def test_binomial_distribution1
		assert_equal binomial_distribution(1,0.01,17), -1
	end

	def test_binomial_distribution2
		assert_equal binomial_distribution(-1,0.01,17), -1
	end

	def test_binomial_distribution3
		assert_equal binomial_distribution(3,0.01,1).round(4), 0.9997
	end



end