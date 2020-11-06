require_relative 'test_helper'
require 'algebra'

class AlgebraTest < Minitest::Test
  include Silicium::Algebra
  include Silicium::Algebra::PolynomRootsReal

  def setup
    @polynom_div = PolynomialDivision.new
  end

  def compare_double(val1,val2,eps = 0.001)
    (val1 - val2).abs <= eps
  end

  def test_eratosthen_primes_exceptions
    assert_raises(ArgumentError){ eratosthen_primes_to(-15) }
    assert_raises(ArgumentError){ eratosthen_primes_to(0) }
    assert_raises(ArgumentError){ eratosthen_primes_to('13') }
    assert_raises(ArgumentError){ eratosthen_primes_to(53.6) }
  end

  def test_eratosthen_primes_to_low_n
    assert_equal([2, 3, 5, 7, 11, 13], eratosthen_primes_to(15))
  end

  def test_eratosthen_primes_to_high_n
    assert_equal(99991, eratosthen_primes_to(100000).last)
  end

  def test_eratosthen_primes_to_normal_n
    assert_equal([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47], eratosthen_primes_to(50))
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
    res = polynom_real_roots_by_str(1,'x - 1')
    assert(compare_double(res.first,1))
  end

  def test_polynom_real_roots_no_roots
    assert_equal([],polynom_real_roots_by_str(2,'x^2 + 1'))
  end

  def test_polynom_real_roots_sec_deg_power_first
    res = polynom_real_roots_by_str(2,'x^2 - 2 * x + 1')
    assert(compare_double(res.first,1))
  end

  def test_polynom_real_roots_arbitrary_sec_deg
    res = polynom_real_roots_by_str(2,'x^2 - 4 * x + 3')
    assert(res.all? { |root| compare_double(root,1) ||
        compare_double(root,3)})
  end

  def test_polynom_real_roots_third_deg
    res = polynom_real_roots_by_str(2,'x^3 - 3*x^2 - x + 3')
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

  def test_mine
    div = @polynom_div.polynom_division("1*x**3-1*x**2-11*x**1-4*x**0","1*x**2+3*x**1+1*x**0")[0]
    assert_equal("1.0*x**1-4.0*x**0", div)
  end


  def test_gcd_1
    gcd = @polynom_div.polynom_gcd("1.0*x**4+0.0*x**3+0.0*x**2+0.0*x**1-1*x**0", "1.0*x**2+0.0*x**1-1*x**0")
    assert_equal("1.0*x**2+0.0*x**1-1.0*x**0", gcd)
  end

  def test_gcd_2
    gcd = @polynom_div.polynom_gcd("1*x**4+1*x**3-3*x**2-4*x**1-1*x**0","1*x**3+1*x**2-1*x**1-1*x**0")
    assert_equal("1.0*x**1+1.0*x**0",gcd)
  end

  def test_gcd_3
    gcd = @polynom_div.polynom_gcd("1*x**3+1*x**2-1*x**1-1*x**0","1*x**4+1*x**3-3*x**2-4*x**1-1*x**0")
    assert_equal("1.0*x**1+1.0*x**0",gcd)
  end

  def test_gcd_4
    gcd = @polynom_div.polynom_gcd("1*x**2+0*x**2-1*x**0","1*x**1+1*x**0")
    assert_equal("1.0*x**1+1.0*x**0", gcd)
  end

  def test_gcd_5
    gcd = @polynom_div.polynom_gcd("1*x**1+1*x**0","1*x**2+0*x**2-1*x**0")
    assert_equal("1.0*x**1+1.0*x**0", gcd)
  end

  def test_gcd_6
    gcd = @polynom_div.polynom_gcd("2*x**5-3*x**4+0*x**3+0*x**2-5*x**1-6*x**0","2*x**5-3*x**4+0*x**3+0*x**2-5*x**1-6*x**0")
    assert_equal("1.0*x**5-1.5*x**4+0.0*x**3+0.0*x**2-2.5*x**1-3.0*x**0", gcd)
  end

  def test_gcd_7
    gcd = @polynom_div.polynom_gcd("2*x**6+4*x**5+0*x**4+0*x**3-1*x**2+0*x**1+1*x**0",'1*x**3-1**x**2+0*x**1+0*x**0')
    assert_equal("1.0*x**0",gcd)
  end

  def test_gcd_8
    gcd = @polynom_div.polynom_gcd("-3*x**3-2*x**2-1*x**1-1*x**0",'1*x**2+0*x**1-1*x**0')
    assert_equal("1.0*x**0",gcd)
  end

  def test_gcd_9
    gcd = @polynom_div.polynom_gcd("1*x**4+3*x**3-1*x**2-4*x**1-3*x**0",'3*x**3+10*x**2+2*x**1-3*x**0')
    assert_equal("1.0*x**1+3.0*x**0",gcd)
  end

  def test_gcd_10
    gcd = @polynom_div.polynom_gcd("4*x**5-23*x**4+47*x**3-1*x**2-48*x**1-36*x**0",'4*x**3-15*x**2+5*x**1+18*x**0')
    assert_equal("1.0*x**1-2.0*x**0",gcd)
  end

  def test_gcd_11
    gcd = @polynom_div.polynom_gcd('4*x**3-15*x**2+5*x**1+18*x**0',"4*x**5-23*x**4+47*x**3-1*x**2-48*x**1-36*x**0")
    assert_equal("1.0*x**1-2.0*x**0",gcd)
  end

  def test_gcd_if_this_works_then_its_amazing
    gcd = @polynom_div.polynom_gcd("2*x**6+1*x**5-4*x**4+15*x**3+5*x**2-2*x**1-1*x**0",'2*x**4+5*x**3+0*x**2-1*x**1+0*x**0')
    assert_equal("1.0*x**2+2.0*x**1-1.0*x**0",gcd)
  end

  def test_how_work_polynom_parser_1
    rez_parsing = @polynom_div.polynom_parser('2*x**6+4*x**5+0*x**4+0*x**3-1*x**2+0*x**1+1*x**0')
    assert_equal_as_sets([2.0, 4.0, 0.0, 0.0, -1.0, 0.0, 1.0], rez_parsing)
  end


  def test_how_work_polynom_parser_2
    rez_parsing = @polynom_div.polynom_parser('1')
    assert_equal_as_sets([1.0], rez_parsing)
  end

  def test_how_work_polynom_parser_wth_neg_1
    rez_parsing = @polynom_div.polynom_parser('-3*x**3-2*x**2-x**1-1')
    assert_equal_as_sets([-3.0, -2.0, -1.0, -1.0], rez_parsing)
  end

  def test_how_work_polynom_parser_wth_neg_2
    rez_parsing = @polynom_div.polynom_parser('-5*x**2-2*x**2')
    assert_equal_as_sets([-5.0, -2.0], rez_parsing)
  end

  def test_polynom_parser_exception
    assert_raises(NameError){ polynom_parser(-3*x**3-2*x**2-x**1-1) }
  end

  ##
  #Euler function tests
  def test_euler_small
    assert_equal(eul_f(502),250,"Euler function failure on small num")
  end

  def test_euler_large
    assert_equal(eul_f(424242),108864,"Euler function failure on large num")
  end

  def test_euler_prime
    assert_equal(eul_f(613),612,"Euler function failure on prime num")
  end

  def test_euler_bydef
    assert_equal(eul_f(1),1,"Euler function failure by definition")
  end

  def test_euler_neg
    assert_raises(RuntimeError){puts eul_f(-1)}
  end

  ##
  # Dixon's algorithm tests
  def test_dixon_large
    assert(dix_factor(89755).all?{|num| 89755%num == 0},"Dixons fact failure on large number")
  end

  def test_dixon_small
    assert(dix_factor(23449).all?{|num| 23449%num == 0},"Dixons fact failure on small number")
  end

  def test_dixon_prime
    assert(dix_factor(113).first==113,"Dixon's fact failure on prime number")
  end


end