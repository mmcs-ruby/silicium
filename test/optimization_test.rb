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

    assert_in_delta 19.0 / 3, integrating_Monte_Carlo_base(1, 2){ |x| test_1(x) }, 0.3
  end

  def test_integrating_Monte_Carlo_base_exp_integral
    def test_1(x)
       Math.exp(x)
    end

    assert_in_delta -1 + Math.exp(5), integrating_Monte_Carlo_base(0, 5){ |x| test_1(x) }, 5
  end

  def test_integrating_Monte_Carlo_base_sym_board
    def test_1(x)
       x * x * x
    end

    assert_in_delta 0, integrating_Monte_Carlo_base(-1, 1){ |x| test_1(x) }, 0.1
  end

  def test_integrating_Monte_Carlo_base_neg_board
    def test_1(x)
       Math.sin(x)
    end

    assert_in_delta Math.cos(3) - Math.cos(2), integrating_Monte_Carlo_base(-3, 2){ |x| test_1(x) }, 0.1
  end

end
