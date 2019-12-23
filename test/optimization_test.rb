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
    assert_in_delta 19.0 / 3, (integrating_Monte_Carlo_base(1, 2){ |x| x * x + 2 * x + 1 }), 0.3
  end

  def test_integrating_Monte_Carlo_base_exp_integral
    assert_in_delta (-1 + Math.exp(5)), (integrating_Monte_Carlo_base(0, 5){ |x| Math.exp(x) }), 5
  end

  def test_integrating_Monte_Carlo_base_sym_board
    assert_in_delta 0, (integrating_Monte_Carlo_base(-1, 1){ |x| x * x * x }), 0.1
  end

  def test_integrating_Monte_Carlo_base_neg_board
    assert_in_delta Math.cos(3) - Math.cos(2), (integrating_Monte_Carlo_base(-3, 2){ |x| Math.sin(x) }), 0.1
  end

  def test_sorted_sorted_arr
    assert sorted?([1, 2, 3, 4, 5])
  end

  def test_sorted_unsorted_arr
    assert !sorted?([1, 2, 666, 4, 5])
  end

  def test_sorted_empty_arr
    assert sorted?([])
  end

  def test_sorted_nil
    assert !sorted?(nil)
  end

  def test_bogosort_m_sorted_arr
    assert sorted?(bogosort!([1, 2, 3]))
  end

  def test_bogosort_m_unsorted_arr
    assert sorted?(bogosort!([3, 1, 2, 5, 4]))
  end

  def test_bogosort_m_modify_arr
    a = [3, 0, 5]
    bogosort!(a)
    assert sorted?(a)
  end

  def test_bogosort_m_nil_arr
    assert_raises(ArgumentError) do
      bogosort!(nil)
    end
  end

  def test_bogosort_sorted_arr
    assert sorted?(bogosort([1, 2, 3]))
  end

  def test_bogosort_unsorted_arr
    assert sorted?(bogosort([3, 1, 2, 5, 4]))
  end

  def test_bogosort_not_modify_arr
    a = [3, 0, 5]
    bogosort(a)
    assert !sorted?(a)
  end

  def test_bogosort_nil_arr
    assert_raises(ArgumentError) do
      bogosort!(nil)
    end
  end

  def test_hook_jeeves_params_1
    vals = (hook_jeeves([-4], [1], 0.001) {|x| 8 * x[0] * x[0] + 4 * x[0]  + 5})
    assert_in_delta vals[0], -0.25, 0.01
  end

  def test_hook_jeeves_params_1_new_atm
    vals = (hook_jeeves([5], [1], 0.001) {|x| 8 * x[0] * x[0] + 4 * x[0]  + 5})
    assert_in_delta vals[0], -0.25, 0.01
  end

  def test_hook_jeeves_params_1_new_atm2
    vals = (hook_jeeves([5], [-1], 0.001) {|x| 8 * x[0] * x[0] + 4 * x[0]  + 5})
    assert_in_delta vals[0], -0.25, 0.01
  end

  def test_hook_jeeves_params_2
    vals = (hook_jeeves([-6, 0], [-1, 2], 0.001) {|x| x[0] * x[0] + 4 * x[0]  + 5 - x[0] * x[1] + x[1] * x[1]})
    assert_in_delta vals[0], -8.0/3, 0.01
    assert_in_delta vals[1], -4.0/3, 0.01
  end

  def test_hook_jeeves_params_2_new_atm
    vals = (hook_jeeves([12, -5], [5, 3], 0.001) {|x| x[0] * x[0] + 4 * x[0]  + 5 - x[0] * x[1] + x[1] * x[1]})
    assert_in_delta vals[0], -8.0/3, 0.01
    assert_in_delta vals[1], -4.0/3, 0.01
  end

  def test_hook_jeeves_params_2_new_atm_2
    vals = (hook_jeeves([-10, 10], [6, 6], 0.001) {|x| x[0] * x[0] + 4 * x[0]  + 5 - x[0] * x[1] + x[1] * x[1]})
    assert_in_delta vals[0], -8.0/3, 0.01
    assert_in_delta vals[1], -4.0/3, 0.01
  end

  def test_hook_jeeves_params_3
    vals = hook_jeeves([0, 1, 2], [1, 1, 1], 0.001) {|x| x[0] * x[0] + 4 * x[0]  + 5 - x[0] * x[1] + x[1] * x[1] + x[2] * x[2] * x[2] - x[1] * x[2] - 3 * x[2] * x[2]}
    assert_in_delta vals[0], -2, 0.01
    assert_in_delta vals[1], 0, 0.01
    assert_in_delta vals[2], 2, 0.01
  end

  def test_half_division_root_neg
    assert_in_delta (-0.703), (half_division(-2, 2, 0.0001){|x| Math.exp(x) - x * x}), 0.001
  end

  def test_half_division_root_exist_pos
    assert_in_delta 5.556, (half_division(2, 10, 0.0001){|x| 100 * Math.log(x) -  x * x * x}), 0.001
  end

  def test_half_division_root_exist_zero
    assert_in_delta 0, half_division(-0.5, 0.5, 0.0001){|x| x * x + x}, 0.001
  end

  def test_half_division_root_not_exist
    assert_raises(RuntimeError) do
      half_division(-0.5, 0.5, 0.0001){|x| x * x + x + 1}
    end
  end

  def test_middle
    assert_equal 2.0, middle(1, 3)
  end

  def test_half_division_step
    a = 1
    b = 3
    c = 2
    tmp = half_division_step(a, b, c){|x| x}
    a = tmp[0]
    b = tmp[1]
    c = tmp[2]
    assert_equal a, 2
    assert_equal c, 2.5
    assert_equal b, 3
  end

  def test_accuracy
    assert_in_delta 0.3, accuracy([0.2, -0.1, 0.2]), 0.01
  end

  def test_hook_jeeves_step
    assert_raises(ArgumentError) do
      test_hook_jeeves_step(-0.5, 0.5, 0.0001)
    end
  end

  def test_switch_step_true
    assert_equal switch_step(2, 1, [10], 0), 5
  end

  def test_switch_step_false
    assert_equal switch_step(2, 3, [10], 0), 10
  end

  def test_determinant_sarryus
    m = FastMatrix::Matrix.build(3, 3){|i, j| i + j}
    assert_equal determinant_sarryus(m), 0
  end

  def test_determinant_sarryus_zero
    m = FastMatrix::Matrix.build(3, 3){|i, j| i + j}
    assert_equal determinant_sarryus(m), 0
  end

  def test_determinant_sarryus_standard_2
    m = FastMatrix::Matrix.build(4, 4){|i, j| i + j}
    assert_raises(ArgumentError) do
      determinant_sarryus(m)
    end
  end

  def test_accept_annealing_min_found
    assert_in_delta 1.0, accept_annealing(2, 2, 100, 0.001), 0.00001
  end

  def test_accept_annealing_min_not_found
    assert_in_delta Math.exp(-2), accept_annealing(4, 2, 1000, 0.001), 0.0001
  end

  def test_simulated_annealing_sqr_polynom_func
    assert_in_delta 3.0, (simulated_annealing(-5, 5){|x| x * x - 6 * x + 10}), 0.1
  end

  def test_simulated_annealing_sqr_func
    assert_in_delta 0.0, (simulated_annealing(-10, 10){|x| x * x}), 0.1
  end

  def test_simulated_annealing_sin_func
    assert_in_delta 3 * Math::PI / 2, (simulated_annealing(Math::PI, Math::PI * 2){|x| Math.sin x}), 0.1
  end

  def test_annealing_step
    assert_equal 10, annealing_step(100, -10, 10)
  end

  def test_annealing_cond
    assert(annealing_cond(2, 4, 100, 1))
  end

end
