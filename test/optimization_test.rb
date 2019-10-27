require "test_helper"
require 'optimization'


class SiliciumTest < Minitest::Test
  include Silicium::Optimization

  def test_reLu_neg
    assert_equal 0, re_lu(-1)
  end

  def test_reLu_pos
    assert_equal 0.5, re_lu(0.5)
  end

  def test_reLu_int
    assert_equal 2, re_lu(2)
  end

  def test_sigmoid
    assert_equal 0.5, sigmoid(0)
  end

  def test_sigmoid_boards
    (0..1).step(0.1) do |n|
      assert (sigmoid(n) < 1 && sigmoid(n) > 0)
    end
  end

  def test_integrating_Monte_Carlo_base_common_integral
    def test_1(x)
       x * x + 2 * x + 1
    end

    assert_in_delta 26.0 / 3, integrating_Monte_Carlo_base(method(:test_1), 0, 2), 0.1
  end

end
