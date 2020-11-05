require 'test_helper'
require 'algebra'
#require 'polynomial_interpolation'
require './lib/polynomial_interpolation'

class PolynomialInterpolationTest < MiniTest::Test

  def test_lagrange_polynomials_work
    assert_equal Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([-1,0, 1, 4], [-7, -1, 1, 43], 2 ), 5.0
  end

  def test_lagrange_polynomials_work_2
    assert_equal Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([0, 1, 2, 6], [-1, -3, 3, 1187], 4), 255.0
  end


  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test
    skip 'Not implemented'
  end
end