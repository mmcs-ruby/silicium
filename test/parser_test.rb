require 'test_helper'
require 'parser'
#require 'test_helper'
#require 'parser'

class ParserTest < Minitest::Test
  include Silicium::Polynom

  def test_that_normal_polynom
    assert(polycop('x^2 + 2 * x + 7'), "Fail")
  end

  def test_that_work_exit
    assert(!polycop('eval(exit)'), "Fail")
  end

  def test_that_work_exit_2
    assert(!polycop('x^2 +2nbbbbb * x + 7'), "Fail")
  end

  def test_that_work_exit_3
    assert(polycop('x*b4 + 1'), "Fail")
  end

  def test_that_work_degrees
    assert(polycop('x**4 + 1'), "Fail")
  end

  def test_that_work_normal_degrees_2
    assert(polycop('(3*x)x***4 + 1'), "Fail")
  end

  def test_that_dont_work_degrees
    assert(polycop('3*x^4 - 2*x^3 + 7y - 1'), "Fail")
  end

  def test_that_work_trigonometry
    assert(polycop('sin(x) + 1'), "Fail")
  end

  def test_differentiate_normal
    assert_equal(differentiate_inner("x**2"), "2*x")
  end

  def test_differentiate_normal_2
    assert_equal(differentiate_inner("x**3+x**2"), "3*x**2+2*x")
  end

  def test_differentiate_normal_3
    assert_equal(differentiate_inner(""), "")
  end

  def test_differentiate_normal_4
    assert_equal(differentiate_inner("x**4-x"), "4*x**3-1")
  end

  def test_differentiate_normal_5
    assert_equal(differentiate_inner("x**5+x**3+x+x**7"), "5*x**4+3*x**2+1+7*x**6")
  end

  def test_differentiate_normal_with_negative
    assert_equal(differentiate_inner("-x**2"), "2*-x")
  end

  def test_differentiate_normal_with_negative_2
    assert_equal(differentiate_inner("-x**4+x**2"), "4*-x**3+2*x")
  end

  def test_differentiate_normal_with_negative_3
    assert_equal(differentiate_inner("-4*x**2+x**2-x"), "-4*2*x+2*x-1")
  end

  def test_differentiate_normal_with_negative_4
    assert_equal(differentiate_inner("x-x"), "1-1")
  end

  def test_differentiate_normal_with_negative_5
    assert_equal(differentiate_inner("-5*x**5"), "-5*5*x**4")
  end

=begin
  def test_exception
    assert_raises(ArgumentError){differentiate_inner()}
  end
=end
end