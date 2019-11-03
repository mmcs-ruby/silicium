require 'test_helper'
require 'numerical_integration'

class NumericalIntegrationTest < Minitest::Test
  include Silicium
  @@delta = 0.0001

  def test_log_three_eights_integration
    assert_in_delta Math.log(1.25),
                    NumericalIntegration.three_eights_integration(4, 5) { |x| 1 / x }, @@delta
  end

  def test_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 7) { |x| 1 / x }
    end
  end

  def test_nan_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 1) { |x| 1 / Math.log(x) }
    end
  end

  def test_domain_sqrt_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-8, 7) { |x| Math.sqrt(x) }
    end
  end

  def test_domain_log_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-8, 7) { |x| Math.log(x) }
    end
  end

  def test_domain_asin_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-6, 16) { |x| Math.asin(x + 6) }
    end
  end

  def test_domain_sqrt2_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(-1, 7) { |x| 1 / Math.sqrt(x) + 23 }
    end
  end

  def test_domain_log_difference_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 2) { |x| Math.log(x) - Math.log(x) }
    end
  end

  def test_domain_log_quotient_error_three_eights_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.three_eights_integration(0, 3) { |x| Math.log(x) / Math.log(x) }
    end
  end

  def test_sin_three_eights_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    NumericalIntegration.three_eights_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_three_eights_integration
    assert_in_delta Math.atan(Math::PI),
                    NumericalIntegration.three_eights_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    NumericalIntegration.three_eights_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_three_eights_integration
    assert_in_delta 442.818,
                    NumericalIntegration.three_eights_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_three_eights_integration
    assert_in_delta 442.82,
                    NumericalIntegration.three_eights_integration(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_three_eights_integration
    assert_in_delta 442.8,
                    NumericalIntegration.three_eights_integration(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_three_eights_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    NumericalIntegration.three_eights_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_three_eights_integration
    assert_in_delta 0,
                    NumericalIntegration.three_eights_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def test_polynom_accuracy_0_0001_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.0001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.0001
  end

  def test_polynom_accuracy_0_001_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.three_eights_integration(-10, 18, 0.001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.001
  end

  def test_log_simpson_integration
    assert_in_delta Math.log(3.5),
                    NumericalIntegration.simpson_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_simpson_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    NumericalIntegration.simpson_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_simpson_integration
    assert_in_delta Math.atan(Math::PI),
                    NumericalIntegration.simpson_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_simpson_integration
    assert_in_delta Math::PI / 6,
                    NumericalIntegration.simpson_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_simpson_integration
    assert_in_delta 442.818,
                    NumericalIntegration.simpson_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_simpson_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    NumericalIntegration.simpson_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_simpson_integration
    assert_in_delta 0,
                    NumericalIntegration.simpson_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_simpson_integration
    assert_in_delta 16519216 / 3.0,
                    NumericalIntegration.simpson_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(0, 7) { |x| 1 / x }
    end
  end

  def test_nan_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(0, 1) { |x| 1 / Math.log(x) }
    end
  end

  def test_domain_error1_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-8, 7) { |x| Math.sqrt(x) }
    end
  end

  def test_domain_error2_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-8, 7) { |x| Math.log(x) }
    end
  end

  def test_domain_error3_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-6, 16) { |x| Math.asin(x + 6) }
    end
  end

  def test_domain_error_simpson_integration
    assert_raises IntegralDoesntExistError do
      NumericalIntegration.simpson_integration(-1, 7) { |x| 1 / Math.sqrt(x) + 23 }
    end
  end

  def test_log_left_rect_integration
    wrap_log(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_sin_left_rect_integration
    wrap_sin(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_arctan_left_rect_integration
    wrap_arctan(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_arcsin_left_rect_integration
    wrap_arcsin(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_something_scary_left_rect_integration
    wrap_something_scary(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_something_scary_accuracy_001_left_rect_integration
    wrap_something_scary_accuracy_001(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_something_scary_accuracy_01_left_rect_integration
    wrap_something_scary_accuracy_01(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_reverse_left_rect_integration
    wrap_reverse(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_one_point_left_rect_integration
    wrap_one_point(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_polynom_left_rect_integration
    wrap_polynom(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_polynom_accuracy_left_rect_integration
    wrap_polynom_accuracy(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_error_left_rect_integration
    wrap_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_nan_error_left_rect_integration
    wrap_nan_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_sqrt_error_left_rect_integration
    wrap_domain_sqrt_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_log_error_left_rect_integration
    wrap_domain_log_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_asin_error_left_rect_integration
    wrap_domain_asin_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_sqrt2_error_left_rect_integration
    wrap_domain_sqrt2_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_log_difference_error_left_rect_integration
    wrap_domain_log_difference_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_domain_log_quotient_error_left_rect_integration
    wrap_domain_log_quotient_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_number_of_iter_out_of_range_error_left_rect_integration
    wrap_number_of_iter_out_of_range_error(&NumericalIntegration.method(:left_rect_integration))
  end

  def test_log_right_rect_integration
    wrap_log(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_sin_right_rect_integration
    wrap_sin(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_arctan_right_rect_integration
    wrap_arctan(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_arcsin_right_rect_integration
    wrap_arcsin(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_something_scary_right_rect_integration
    wrap_something_scary(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_something_scary_accuracy_001_right_rect_integration
    wrap_something_scary_accuracy_001(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_something_scary_accuracy_01_right_rect_integration
    wrap_something_scary_accuracy_01(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_reverse_right_rect_integration
    wrap_reverse(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_one_point_right_rect_integration
    wrap_one_point(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_polynom_right_rect_integration
    wrap_polynom(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_polynom_accuracy_right_rect_integration
    wrap_polynom_accuracy(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_sqrt_error_right_rect_integration
    wrap_domain_sqrt_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_log_error_right_rect_integration
    wrap_domain_log_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_asin_error_right_rect_integration
    wrap_domain_asin_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_sqrt2_error_right_rect_integration
    wrap_domain_sqrt2_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_log_difference_error_right_rect_integration
    wrap_domain_log_difference_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_domain_log_quotient_error_right_rect_integration
    wrap_domain_log_quotient_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_number_of_iter_out_of_range_error_right_rect_integration
    wrap_number_of_iter_out_of_range_error(&NumericalIntegration.method(:right_rect_integration))
  end

  def test_log_trapezoid
    wrap_log(&NumericalIntegration.method(:trapezoid))
  end

  def test_sin_trapezoid
    wrap_sin(&NumericalIntegration.method(:trapezoid))
  end

  def test_arctan_trapezoid
    wrap_arctan(&NumericalIntegration.method(:trapezoid))
  end

  def test_arcsin_trapezoid
    wrap_arcsin(&NumericalIntegration.method(:trapezoid))
  end

  def test_something_scary_trapezoid
    wrap_something_scary(&NumericalIntegration.method(:trapezoid))
  end

  def test_something_scary_accuracy_001_trapezoid
    wrap_something_scary_accuracy_001(&NumericalIntegration.method(:trapezoid))
  end

  def test_something_scary_accuracy_01_trapezoid
    wrap_something_scary_accuracy_01(&NumericalIntegration.method(:trapezoid))
  end

  def test_reverse_trapezoid
    wrap_reverse(&NumericalIntegration.method(:trapezoid))
  end

  def test_one_point_trapezoid
    wrap_one_point(&NumericalIntegration.method(:trapezoid))
  end

  def test_polynom_trapezoid
    wrap_polynom(&NumericalIntegration.method(:trapezoid))
  end

  def test_polynom_accuracy_trapezoid
    wrap_polynom_accuracy(&NumericalIntegration.method(:trapezoid))
  end

  def test_error_trapezoid
    wrap_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_nan_error_trapezoid
    wrap_nan_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_sqrt_error_trapezoid
    wrap_domain_sqrt_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_log_error_trapezoid
    wrap_domain_log_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_asin_error_trapezoid
    wrap_domain_asin_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_sqrt2_error_trapezoid
    wrap_domain_sqrt2_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_log_difference_error_trapezoid
    wrap_domain_log_difference_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_domain_log_quotient_error_trapezoid
    wrap_domain_log_quotient_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_number_of_iter_out_of_range_error_trapezoid
    wrap_number_of_iter_out_of_range_error(&NumericalIntegration.method(:trapezoid))
  end

  def test_log_middle_rectangles
    wrap_log(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_sin_middle_rectangles
    wrap_sin(&NumericalIntegration.method(:middle_rectangles))
  end
  
  def test_arctan_middle_rectangles
    wrap_arctan(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_arcsin_middle_rectangles
    wrap_arcsin(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_something_scary_middle_rectangles
    wrap_something_scary(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_something_scary_accuracy_001_middle_rectangles
    wrap_something_scary_accuracy_001(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_something_scary_accuracy_01_middle_rectangles
    wrap_something_scary_accuracy_01(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_reverse_middle_rectangles
    wrap_reverse(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_one_point_middle_rectangles
    wrap_one_point(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_polynom_middle_rectangles
    wrap_polynom(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_polynom_accuracy_middle_rectangles
    wrap_polynom_accuracy(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_error_middle_rectangles
    wrap_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_nan_error_middle_rectangles
    wrap_nan_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_domain_sqrt_error_middle_rectangles
    wrap_domain_sqrt_error(&NumericalIntegration.method(:middle_rectangles))
  end
  def test_domain_log_error_middle_rectangles
    wrap_domain_log_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_domain_asin_error_middle_rectangles
    wrap_domain_asin_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_domain_sqrt2_error_middle_rectangles
    wrap_domain_sqrt2_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_domain_log_difference_error_middle_rectangles
    wrap_domain_log_difference_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_domain_log_quotient_error_middle_rectangles
    wrap_domain_log_quotient_error(&NumericalIntegration.method(:middle_rectangles))
  end

  def test_number_of_iter_out_of_range_error_middle_rectangles
    wrap_number_of_iter_out_of_range_error(&NumericalIntegration.method(:middle_rectangles))
  end

  private

  def wrap_log(&block)
    assert_in_delta 0.182322, block.call(1, 1.2){ |x| 1 / x }, @@delta
  end
 
  def wrap_sin(&block)
    assert_in_delta 0.04446, block.call(-0.5, -0.45){ |x| Math.cos(x) }, @@delta
  end

  def wrap_arctan(&block)
    assert_in_delta Math.atan(Math::PI / 12),
                    block.call(0, Math::PI / 12){ |x| 1 / (1 + x ** 2) }, @@delta
  end

  def wrap_arcsin(&block)
    assert_in_delta Math::PI / 6,
                    block.call(-0.5, 0){ |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def wrap_something_scary(&block)
    assert_in_delta 13.8479,
                    block.call(4.5, 4.55, 0.001){ |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def wrap_something_scary_accuracy_001(&block)
    assert_in_delta 74.5912,
                    block.call(4.5, 4.75, 0.01){ |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def wrap_something_scary_accuracy_01(&block)
    assert_in_delta 74.5912,
                    block.call(4.5, 4.75, 0.1){ |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def wrap_reverse(&block)
    assert_in_delta (-0.247404),
                    block.call(0, -0.25){ |x| Math.cos(x) }, @@delta
  end

  def wrap_one_point(&block)
    assert_in_delta 0,
                    block.call(42, 42){ |x| Math.sin(x) / x }, @@delta
  end

  def wrap_polynom(&block)
    assert_in_delta (-0.32),
                    block.call(-0.001, 0.001){ |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def wrap_polynom_accuracy(&block)
    assert_in_delta (-0.32),
                    block.call(-0.001, 0.001, 0.00001){ |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def wrap_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(0, 0.5){ |x| 1 / x }
    end
  end

  def wrap_nan_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(1, 1.2){ |x| 1 / Math.log(x) }
    end
  end

  def wrap_domain_sqrt_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(-2, -1){ |x| Math.sqrt(x) }
    end
  end

  def wrap_domain_log_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(-2, -1){ |x| Math.log(x) }
    end
  end

  def wrap_domain_asin_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(10, 12){ |x| Math.asin(x + 6) }
    end
  end

  def wrap_domain_sqrt2_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(-2, -1){ |x| 1 / Math.sqrt(x) + 23 }
    end
  end

  def wrap_domain_log_difference_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(-2, -1){ |x| Math.log(x) - Math.log(x) }
    end
  end

  def wrap_domain_log_quotient_error(&block)
    assert_raises IntegralDoesntExistError do
      block.call(-2, -1){ |x| Math.log(x) / Math.log(x) }
    end
  end

  def wrap_number_of_iter_out_of_range_error(&block)
    assert_raises NumberofIterOutofRangeError do
      block.call(1, 200){ |x| 1 / x }
    end
  end

end