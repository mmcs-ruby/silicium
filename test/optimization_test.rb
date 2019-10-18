require "test_helper"
require 'optimization'


class SiliciumTest < Minitest::Test
  include Silicium::Optimization

  def test_reLu
    assert_equal 0, re_lu(-1)
    assert_equal 0.5, re_lu(0.5)
    assert_equal 2, re_lu(2)
  end

  def test_sigmoid
    assert_equal 0.5, sigmoid(0)
    (0..1).step(0.1) do |n|
      assert (sigmoid(n) < 1)
    end
  end

  def test_integrating_Monte_Carlo_base
    def test_1(x)
      x * x + 2 * x + 1
    end
    assert_in_delta 26.0 / 3, integrating_Monte_Carlo_base(test_1, 0, 2), 0.1
  end

end
