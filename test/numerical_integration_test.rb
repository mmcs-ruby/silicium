require 'test_helper'
require 'numerical_integration'

class NumericalIntegrationTest < Minitest::Test
  @@delta = 0.0001

  def test_log_three_eights_integration
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_error_three_eights_integration
    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(0, 7) { |x| 1 / x }
    end
  end

  def test_nan_error_three_eights_integration
    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(0, 1) { |x| 1 / Math::log(x) }
    end
  end

  def test_domain_error_three_eights_integration
    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(-8, 7) { |x| Math::sqrt(x) }
    end

    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(-8, 7) { |x| Math::log(x) }
    end

    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(-6, 16) { |x| Math::asin(x + 6) }
    end

    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(-1, 7) { |x| 1 / Math::sqrt(x) + 23 }
    end
    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(0, 2) { |x| Math::log(x) - Math::log(x) }
    end

    assert_raises ::Silicium::IntegralDoesntExistError do
      ::Silicium::NumericalIntegration.three_eights_integration(0, 3) { |x| Math::log(x) / Math::log(x) }
    end
  end

  def test_sin_three_eights_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.three_eights_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_three_eights_integration
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.three_eights_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.three_eights_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end


  def test_something_scary_three_eights_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_three_eights_integration
    assert_in_delta 442.82,
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_three_eights_integration
    assert_in_delta 442.8,
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_three_eights_integration
    assert_in_delta (-(Math.sin(3) + Math.sin(4))),
                    ::Silicium::NumericalIntegration.three_eights_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_three_eights_integration
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.three_eights_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    ::Silicium::NumericalIntegration.three_eights_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_three_eights_integration
    assert_in_delta 16519216 / 3.0,
                    ::Silicium::NumericalIntegration.three_eights_integration(-10, 18, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

# TODO: Write tests with non-determined function (such as integral of 1/x from -1 to 1)

  def test_log_simpson_integration
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.simpson_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_simpson_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.simpson_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_simpson_integration
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.simpson_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_simpson_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.simpson_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_simpson_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.simpson_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_simpson_integration
    assert_in_delta -(Math.sin(3) + Math.sin(4)),
                    ::Silicium::NumericalIntegration.simpson_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_simpson_integration
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.simpson_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_simpson_integration
    assert_in_delta 16519216 / 3.0,
                    ::Silicium::NumericalIntegration.simpson_integration(-10, 18) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

#
  def test_log_left_rect_integration
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.left_rect_integration(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_left_rect_integration
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.left_rect_integration(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_left_rect_integration
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.left_rect_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_left_rect_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_left_rect_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.left_rect_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_left_rect_integration
    assert_in_delta -(Math.sin(3) + Math.sin(4)),
                    ::Silicium::NumericalIntegration.left_rect_integration(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_left_rect_integration
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.left_rect_integration(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_left_rect_integration
    assert_in_delta -159.75,
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0.5) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end


  def test_polynom_accuracy_left_rect_integration
    assert_in_delta -159.75,
                    ::Silicium::NumericalIntegration.left_rect_integration(-0.5, 0.5, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end

  def test_log_middle_rectangles
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 7) { |x| 1 / x }, @@delta
  end

  def test_sin_middle_rectangles
    assert_in_delta Math.sin(8) + Math.sin(10),
                    ::Silicium::NumericalIntegration.middle_rectangles(-10, 8) { |x| Math.cos(x) }, @@delta
  end

  def test_arctan_middle_rectangles
    assert_in_delta Math.atan(Math::PI),
                    ::Silicium::NumericalIntegration.middle_rectangles(0, Math::PI) { |x| 1 / (1 + x ** 2) }, @@delta
  end

  def test_arcsin_middle_rectangles
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end


  def test_something_scary_middle_rectangles
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_something_scary_accuracy_001_middle_rectangles
    assert_in_delta 442.82,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.01) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.01
  end

  def test_something_scary_accuracy_01_middle_rectangles
    assert_in_delta 442.8,
                    ::Silicium::NumericalIntegration.middle_rectangles(2, 5, 0.1) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.1
  end

  def test_reverse_middle_rectangles
    assert_in_delta (-1 * (Math.sin(3) + Math.sin(4))),
                    ::Silicium::NumericalIntegration.middle_rectangles(4, -3) { |x| Math.cos(x) }, @@delta
  end

  def test_one_point_middle_rectangles
    assert_in_delta 0,
                    ::Silicium::NumericalIntegration.middle_rectangles(42, 42) { |x| Math.sin(x) / x }, @@delta
  end

  def test_polynom_middle_rectangles
    assert_in_delta (-63.984),
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.2, 0.2) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, @@delta
  end

  def test_polynom_accuracy_middle_rectangles
    assert_in_delta (-63.984),
                    ::Silicium::NumericalIntegration.middle_rectangles(-0.2, 0.2, 0.00001) { |x| x ** 5 + 3 * x ** 2 + 18 * x - 160 }, 0.00001
  end
end