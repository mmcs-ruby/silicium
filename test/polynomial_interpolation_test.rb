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

  def test_lagrange_polynomials_with_wrong_variable_z
    assert_raises ArgumentError do
      Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([0, 1, 2, 6], [-7, -1, 1, 43], 'z')
    end
  end

  def test_lagrange_polynomials_with_wrong_variable_x
    assert_raises ArgumentError do
      Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials("x", [-7, -1, 1, 43], 2 )
    end
  end

  def test_lagrange_polynomials_with_wrong_type_of_arrays
    assert_raises ArgumentError do
      Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([[1, 2], [2, 3]], [-7, -1, 1, 43], 2 )
    end
  end

  def test_lagrange_polynomials_with_size_problem
    assert_raises ArgumentError do
      Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([1], [-7, -1, 1, 43], 2 )
    end
  end

  def test_lagrange_polynomials_with_empty_arrays
    assert_raises ArgumentError do
      Silicium::Algebra::PolynomialInterpolation::lagrange_polynomials([], [-7, -1, 1, 43], 2 )
    end
  end

end