require 'test_helper'
require 'algebra'

class AlgebraTest < Minitest::Test
  include Silicium::Algebra

  def setup
    @polynom_div = PolynomialDivision.new
  end
  def compare_double(val1,val2,eps = 0.001)
    abs(val1 - val2) <= eps
  end

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
  def test_polynom_real_roots_first_deg
    res = polinom_real_roots_by_str(1,'x - 1')
    assert(compare_double(res.first,1))
  end
  def test_polynom_real_roots_no_roots
    assert_equal([],polynom_real_roots_by_str(2,'x^2 + 1'))
  end
  def test_polynom_real_roots_sec_deg_power_first
    res = polinom_real_roots_by_str(2,'x^2 - 2 * x + 1')
    assert(compare_double(res.first,1))
  end
  def test_polynom_real_roots_arbitrary_sec_deg
    res = polinom_real_roots_by_str(2,'x^2 - 4 * x + 3')
    assert(res.all? { |root| compare_double(root,1) ||
                              compare_double(root,3)})
  end
  def test_polynom_real_roots_third_deg
    res = polinom_real_roots_by_str(2,'x^3 - 3*x^2 - x + 3')
    assert(res.all? { |root| compare_double(root,-1) ||
                              compare_double(root,3) ||
                              compare_double(root,1)})
  end
  def test_that_work_polynom_division
    rez_division = @polynom_div.polynom_division("3*x**3+0*x**2+2*x**1+6*x**0",'2*x**1-5*x**0')
    assert_equal_as_sets(['1.5*x**2+3.75*x**1+10.375*x**0', '57.875*x**0'], rez_division)
  end

  def test_that_work_polynom_dividion_2
    rez_division = @polynom_div.polynom_division("-5*x**4+0*x**3-2*x**2+0*x**1+4*x**0",'2*x**2+0*x**1-1')
    assert_equal_as_sets(['-2.5*x**2+0.0*x**1-2.25*x**0', '0.0*x**1+1.75*x**0'], rez_division)
  end

  def test_that_work_polynom_dividion_3
    rez_division = @polynom_div.polynom_division("1",'1')
    assert_equal_as_sets(['1.0*x**0', ''], rez_division)
  end

  def test_that_work_polynom_dividion_4
    rez_division = @polynom_div.polynom_division("x**5+0*x**4-6*x**3+0*x**2+0*x**1+21*x**0",'-1*x**2+0*x**1+1*x**0')
    assert_equal_as_sets(['-1.0*x**3+-0.0*x**2+5.0*x**1+-0.0*x**0', '-5.0*x**1+21.0*x**0'], rez_division)
  end

  def test_that_work_polynom_dividion_5
    rez_division = @polynom_div.polynom_division("2*x**6+4*x**5+0*x**4+0*x**3-1*x**2+0*x**1+1*x**0",'1*x**3-1**x**2+0*x**1+0*x**0')
    assert_equal_as_sets(['2.0*x**3+6.0*x**2+6.0*x**1+6.0*x**0', '5.0*x**2+0.0*x**1+1.0*x**0'], rez_division)
  end

  def test_that_work_polynom_dividion_6
    rez_division = @polynom_div.polynom_division("-3*x**3-2*x**2-x**1-1",'1*x**2+0*x**1-1')
    assert_equal_as_sets(['-3.0*x**1-2.0*x**0', '-4.0*x**1-3.0*x**0'], rez_division)
  end

  def test_that_work_polynom_dividion_7
    rez_division = @polynom_div.polynom_division("2*x**7+4*x**6+0*x**5+0*x**4+0*x**3-1*x**2+0*x**1+1*x**0",'1*x**7+0*x**6+0*x**5+0*x**4-1*x**3+0*x**2+0*x**1+0*x**0')
    assert_equal_as_sets(['2.0*x**0', '4.0*x**6+0.0*x**5+0.0*x**4+2.0*x**3-1.0*x**2+0.0*x**1+1.0*x**0'], rez_division)
  end
end