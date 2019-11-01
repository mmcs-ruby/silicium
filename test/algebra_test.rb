require 'test_helper'
require 'algebra'
require 'algebra_diff'
require 'polynomial_division'

class AlgebraTest < Minitest::Test
  include Silicium::Algebra

  #New class objects
  @@polynom = Polynom.new
  @@diff = Differentiation.new
  @@polynom_div = Polynom_division.new

  def test_that_normal_polynom
    assert(@@polynom.polycop('x^2 + 2 * x + 7'), "Fail")
  end

  def test_that_normal_polynom_2
    assert(@@polynom.polycop('2 * x^5 - x + 2 * x'), "Fail")
  end

  def test_that_normal_polynom_3
    assert(@@polynom.polycop(''), "Fail")
  end

  def test_that_normal_polynom_with_ln
    assert(@@polynom.polycop('2 * ln x'), "Fail")
  end

  def test_that_normal_polynom_with_log
    assert(@@polynom.polycop('log x + 2 * 4'), "Fail")
  end

  def test_that_normal_polynom_with_lg
    assert(@@polynom.polycop('4 * x^3 * lg x'), "Fail")
  end

  def test_that_normal_polynom_with_log_ln_lg
    assert(@@polynom.polycop('log x + ln y - lg z'), "Fail")
  end

  def test_that_work_exit
    assert(!@@polynom.polycop('eval(exit)'), "Fail")
  end

  def test_that_work_exit_2
    assert(!@@polynom.polycop('x^2 +2nbbbbb * x + 7'), "Fail")
  end

  def test_that_work_exit_3
    assert(@@polynom.polycop('x*b4 + 1'), "Fail")
  end

  def test_that_work_degrees
    assert(@@polynom.polycop('x**4 + 1'), "Fail")
  end

  def test_that_work_normal_degrees_2
    assert(@@polynom.polycop('(3*x)x***4 + 1'), "Fail")
  end

  def test_that_work_degrees_2
    assert(!@@polynom.polycop('3*x^4 - 2*x^3 + 7y - 1'), "Fail")
  end

  def test_that_work_degrees_3
    assert(@@polynom.polycop('x**4 + 1'), "Fail")
  end

  def test_differentiate_normal
    assert_equal(@@diff.differentiate("x**2"), "2*x")
  end

  def test_differentiate_normal_2
    assert_equal(@@diff.differentiate("x**3+x**2"), "3*x**2+2*x")
  end

  def test_differentiate_normal_3
    assert_equal(@@diff.differentiate(""), "0")
  end

  def test_differentiate_normal_4
    assert_equal(@@diff.differentiate("x**4-x"), "4*x**3-1")
  end

  def test_differentiate_normal_5
    assert_equal(@@diff.differentiate("x**5+x**3+x+x**7"), "5*x**4+3*x**2+1+7*x**6")
  end

  def test_differentiate_normal_6
    assert_equal(@@diff.differentiate("-x+x-x"), "-1+1-1")
  end

  def test_differentiate_normal_7
    assert_equal(@@diff.differentiate("x+x+x"), "1+1+1")
  end

  def test_differentiate_normal_8
    assert_equal(@@diff.differentiate("2*5*6*x**7"), "420*x**6")
  end

  def test_differentiate_normal_with_negative
    assert_equal(@@diff.differentiate("-x**2"), "-2*x")
  end

  def test_differentiate_normal_with_negative_2
    assert_equal(@@diff.differentiate("-x**4+x**2"), "-4*x**3+2*x")
  end

  def test_differentiate_normal_with_negative_3
    assert_equal(@@diff.differentiate("-4*x**2+x**2-x"), "-8*x+2*x-1")
  end

  def test_differentiate_normal_with_negative_4
    assert_equal(@@diff.differentiate("x-x"), "1-1")
  end

  def test_differentiate_normal_with_negative_5
    assert_equal(@@diff.differentiate("-5*x**5"), "-25*x**4")
  end

  def test_differentiate_normal_with_negative_6
    assert_equal(@@diff.differentiate("3*x**2-7*x"), "6*x-7")
  end

  def test_differentiate_normal_with_negative_7
    assert_equal(@@diff.differentiate("-4*x**2+x**2-x"), "-8*x+2*x-1")
  end

  def test_differentiate_normal_with_negative_8
    assert_equal(@@diff.differentiate("x**5-x**3-x**2"), "5*x**4-3*x**2-2*x")
  end

  def test_differentiate_normal_with_two_variables
    assert_equal(@@diff.differentiate("x+y"), "1")
  end

  def test_differentiate_normal_with_two_variables_2
    assert_equal(@@diff.differentiate("3*x**2-y"), "6*x")
  end

  def test_differentiate_normal_with_two_variables_3
    assert_equal(@@diff.differentiate("y-x**2"), "-2*x")
  end

  def test_that_work_polycop_exceptions
    assert_raises(NameError){@@polynom.polycop(4 * x)}
  end

  def test_that_work_differentiate_exceptions
    assert_raises(NameError){@@diff.differentiate(4 * x)}
  end

  def test_that_work_polynom_division
    rez_division = @@polynom_div.polynom_division("3*x**3+0*x**2+2*x**1+6*x**0",'2*x**1-5*x**0')
    assert_equal_as_sets(['1.5*x**2+3.75*x**1+10.375*x**0', ''], rez_division)
  end


end