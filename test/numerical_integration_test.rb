require 'test_helper'

class NumericalIntegrationTest < Minitest::Test
  @@delta = 0.0001

  def test_log_three_eights_integration
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 7) { |x| 1 / x }, @@delta
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

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration.three_eights_integration(-0.5, 0) { |x| 1 / Math.sqrt(1 - x ** 2) }, @@delta
  end

  def test_something_scary_three_eights_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration.three_eights_integration(2, 5, 0.001) { |x| (x ** 4 + Math.cos(x) + Math.sin(x)) / Math.log(x) }, 0.001
  end

  def test_reverse_three_eights_integration
    assert_in_delta -(Math.sin(3) + Math.sin(4)),
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

# TODO: Write tests with non-determined function (such as integral of 1/x from -1 to 1)

  def test_log_simpson_integration_with_eps
    assert_in_delta Math.log(3.5),
                    ::Silicium::NumericalIntegration.simpson_integration_with_eps(2, 7) { |x| 1 / x }, @@delta
  end
end