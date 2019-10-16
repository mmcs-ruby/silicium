require "test_helper"

class NumericalIntegrationTest < Minitest::Test
  def test_log_three_eights_integration
    assert_in_delta Math::log(3.5),
                    ::Silicium::NumericalIntegration::three_eights_integration(2, 7) { |x| 1 / x }, 0.0001
  end

  def test_sin_three_eights_integration
    assert_in_delta Math::sin(8) + Math::sin(10),
                    ::Silicium::NumericalIntegration::three_eights_integration(-10, 8) { |x| Math::cos(x) }, 0.0001
  end

  def test_arctan_three_eights_integration
    assert_in_delta Math::atan(Math::PI),
                    ::Silicium::NumericalIntegration::three_eights_integration(0, Math::PI) { |x| 1 / (1 + x ** 2) }, 0.0001
  end

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration::three_eights_integration(-0.5, 0) { |x| 1 / Math::sqrt(1 - x ** 2) }, 0.0001
  end

  def test_arcsin_three_eights_integration
    assert_in_delta Math::PI / 6,
                    ::Silicium::NumericalIntegration::three_eights_integration(-0.5, 0) { |x| 1 / Math::sqrt(1 - x ** 2) }, 0.0001
  end

  def test_something_scary_three_eights_integration
    assert_in_delta 442.818,
                    ::Silicium::NumericalIntegration::three_eights_integration(2, 5) { |x| (x ** 4 + Math::cos(x) + Math::sin(x)) / Math::log(x) }, 0.001
  end

  #TODO: Write tests with non-determined function (such as intagral of 1/x from -1 to 1)

  # Write your tests here
end