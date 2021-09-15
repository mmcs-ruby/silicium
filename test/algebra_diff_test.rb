require 'test_helper'

class AlgebraDiffTest < Minitest::Test
  include Silicium::Algebra
  def setup
    @diff = Differentiation.new
  end

  def test_differentiate_normal
    assert_equal(@diff.differentiate('x**2'), '2*x')
  end

  def test_differentiate_normal_2
    assert_equal(@diff.differentiate('x**3+x**2'), '3*x**2+2*x')
  end

  def test_differentiate_normal_3
    assert_equal(@diff.differentiate(''), '0')
  end

  def test_differentiate_normal_4
    assert_equal(@diff.differentiate('x**4-x'), '4*x**3-1')
  end

  def test_differentiate_normal_5
    assert_equal(@diff.differentiate('x**5+x**3+x+x**7'),
                 '5*x**4+3*x**2+1+7*x**6')
  end

  def test_differentiate_normal_6
    assert_equal(@diff.differentiate('-x+x-x'), '-1+1-1')
  end

  def test_differentiate_normal_7
    assert_equal(@diff.differentiate('x+x+x'), '1+1+1')
  end

  def test_differentiate_normal_8
    assert_equal(@diff.differentiate('2*5*6*x**7'), '420*x**6')
  end

  def test_diff_with_negative
    assert_equal(@diff.differentiate('-x**2'), '-2*x')
  end

  def test_diff_with_negative_2
    assert_equal(@diff.differentiate('-x**4+x**2'), '-4*x**3+2*x')
  end

  def test_diff_with_negative_3
    assert_equal(@diff.differentiate('-4*x**2+x**2-x'), '-8*x+2*x-1')
  end

  def test_diff_with_negative_4
    assert_equal(@diff.differentiate('x-x'), '1-1')
  end

  def test_diff_with_negative_5
    assert_equal(@diff.differentiate('-5*x**5'), '-25*x**4')
  end

  def test_diff_with_negative_6
    assert_equal(@diff.differentiate('3*x**2-7*x'), '6*x-7')
  end

  def test_diff_with_negative_7
    assert_equal(@diff.differentiate('-4*x**2+x**2-x'), '-8*x+2*x-1')
  end

  def test_diff_with_negative_8
    assert_equal(@diff.differentiate('x**5-x**3-x**2'), '5*x**4-3*x**2-2*x')
  end

  def test_diff_with_two_variables
    assert_equal(@diff.differentiate('x+y'), '1')
  end

  def test_diff_with_two_variables_2
    assert_equal(@diff.differentiate('3*x**2-y'), '6*x')
  end

  def test_diff_with_two_variables_3
    assert_equal(@diff.differentiate('y-x**2'), '-2*x')
  end

  def test_diff_exceptions
    assert_raises(NameError) { @diff.differentiate(4 * x) }
  end
end
