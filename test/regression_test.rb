require 'regression'
require 'test_helper'

class RegressionTest < MiniTest::Test

  include Silicium

  # LINEAR REGRESSION

  @@delta = 0.001
  @@delta2 = 0.01
  @@delta3 = 0.1

  @@plot1 = {-3 => -6, -2 => -4, -1 => -2, 0 => 0, 1=> 2, 2 => 4, 3 => 6, 4=>8, 5=>10, 6=>12, 7=>14, 8=>16}
  @@plot2 = {-5 => 1, -4 => 1, -3 => 1, -2 => 1, -1 => 1, 0 => 1, 1 => 1, 2 => 1, 3 => 1, 4 => 1, 5 => 1}
  @@plot3 = {-8 => 4, -6 => 3, -4 => 2, -2 => 1, 0 => 0, 2 => -1, 4 => -2, 6 => -3, 8 => -4}

  def test_linear_regression1
    theta0, theta1 = Regression::LinearRegressionByGradientDescent::generate_function(@@plot1)
    assert_in_delta theta0, 0, @@delta
    assert_in_delta theta1, 2, @@delta
  end

  def test_linear_regression2
    theta0, theta1 = Regression::LinearRegressionByGradientDescent::generate_function(@@plot2)
    assert_in_delta theta0, 1, @@delta
    assert_in_delta theta1, 0, @@delta
  end

  def test_linear_regression3
    theta0, theta1 = Regression::LinearRegressionByGradientDescent::generate_function(@@plot3)
    assert_in_delta theta0, 0, @@delta
    assert_in_delta theta1, -0.5, @@delta
  end

  # POLYNOMIAL REGRESSION

  # -x^2 + 3x + 2
  @@pol_plot1 = {0 => 2, -1 => -2, -2 => -8, -3 => -16, 1 => 4, 2 => 4, 3 => 2, 4 => -2, -4 => -26}

  def test_polynomial_regression1
    array = Regression::PolynomialRegressionByGradientDescent::generate_function(@@pol_plot1, 2, 0.001, 0.00000001 )
    assert_equal_arrays_in_delta array, [2, 3, -1], @@delta2
  end

  # -x^3 + x^2 - 3x + 5
  @@pol_plot2 = {-5 => 170, -4 => 97, -3 => 50, -2 => 23, -1 => 10, 0 => 5, 1 => 2, 2 => -5, 3 => -22, 4 => -55, 5 => -110}

  def test_polynomial_regression2
    array = Regression::PolynomialRegressionByGradientDescent::generate_function(@@pol_plot2, 3,0.00001, 0.0000001)
    assert_equal_arrays_in_delta array, [5, -3, 1, -1], @@delta3
  end

  def test_polynomial_plot_scaling1
    result = Regression::PolynomialRegressionByGradientDescent::feature_scaled_plot(@@pol_plot1, 2)
    assert_equal_arrays result, [0.03125, -0.03125, -0.125, -0.25, 0.0625, 0.0625, 0.03125, -0.03125, -0.40625]
  end

  def test_polynomial_plot_scaling2
    result = Regression::PolynomialRegressionByGradientDescent::feature_scaled_plot(@@pol_plot2, 3)
    assert_equal_arrays result, [0.17, 0.097, 0.05, 0.023, 0.01, 0.005, 0.002, -0.005, -0.022, -0.055, -0.11]
  end
end