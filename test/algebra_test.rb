require 'test_helper'
require 'algebra'

class AlgebraTest < Minitest::Test
  include Silicium::Algebra

  def test_that_normal_polynomial
    assert(polycop('x^2 + 2 * x + 7'), 'Fail')
  end

  def test_that_normal_polynomial_2
    assert(polycop('2 * x^5 - x + 2 * x'), 'Fail')
  end

  def test_that_normal_polynomial_3
    assert(polycop(''), 'Fail')
  end

  def test_polynomial_with_ln
    assert(polycop('2 * ln x'), 'Fail')
  end

  def test_polynomial_with_log
    assert(polycop('log x + 2 * 4'), 'Fail')
  end

  def test_polynomial_with_lg
    assert(polycop('4 * x^3 * lg x'), 'Fail')
  end

  def test_polynomial_with_log_ln_lg
    assert(polycop('log x + ln y - lg z'), 'Fail')
  end

  def test_that_work_exit
    assert(!polycop('eval(exit)'), 'Fail')
  end

  def test_that_work_exit_2
    assert(!polycop('x^2 +2nbbbbb * x + 7'), 'Fail')
  end

  def test_that_work_exit_3
    assert(polycop('x*b4 + 1'), 'Fail')
  end

  def test_degrees
    assert(polycop('x**4 + 1'), 'Fail')
  end

  def test_degrees_2
    assert(polycop('(3*x)x***4 + 1'), 'Fail')
  end

  def test_that_work_degrees_2
    assert(!polycop('3*x^4 - 2*x^3 + 7y - 1'), 'Fail')
  end

  def test_that_work_degrees_3
    assert(polycop('x**4 + 1'), 'Fail')
  end

  def test_polycop_exceptions
    assert_raises(NameError){ polycop(4 * x) }
  end
end