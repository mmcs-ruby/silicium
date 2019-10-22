require "test_helper"

class NumericalIntegrationTest < Minitest::Test
  @@delta = 0.0001

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
    assert_in_delta  ( -1 * (Math.sin(3) + Math.sin(4))),
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