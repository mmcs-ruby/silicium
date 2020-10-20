require 'lib/linear_regression'
require 'test_helper'

class LinearRegressionTest < MiniTest::Test

  include Silicium
  @@delta = 0.0001

  plot1 = {-3 => -6, -2 => -4, -1 => -2, 0 => 0, 1=> 2, 2 => 4, 3 => 6, 4=>8, 5=>10, 6=>12, 7=>14, 8=>16}
  plot2 = {-5 => 1, -4 => 1, -3 => 1, -2 => 1, -1 => 1, 0 => 1, 1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1}
  plot3 = {-8 => 4, -6 => 3, -4 => 2, -2 => 1, 0 => 0, 2 => -1, 4 => -2, 6 => -3, 8 => -4}

  def test_linear_regression1
    theta0, theta1 = LinearRegression::LinearRegressionByGradientDescent::generate_function(plot1)
    assert_in_delta theta0, 0, @@delta
    assert_in_delta theta1, 2, @@delta
  end

  def test_linear_regression2
    theta0, theta1 = LinearRegression::LinearRegressionByGradientDescent::generate_function(plot2)
    assert_in_delta theta0, 1, @@delta
    assert_in_delta theta1, 0, @@delta
  end

  def test_linear_regression3
    theta0, theta1 = LinearRegression::LinearRegressionByGradientDescent::generate_function(plot3)
    assert_in_delta theta0, 0, @@delta
    assert_in_delta theta1, -0.5, @@delta
  end
end