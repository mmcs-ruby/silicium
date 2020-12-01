require 'test_helper'
require 'method_gauss_and_kramer'

class TestKramer < Minitest::Test

  include Silicium
  def test_two
    assert_equal([5,2],Matrix[[1,-2], [3,-4]].kramer([1,7]))
  end

  def test_three
    assert_equal([3,1,2],Matrix[[2, -5, 3], [4, 1, 4], [1, 2, -8]].kramer([7,21,-11]))
  end

  def test_four
    assert_equal([5,3,1,4],Matrix[[4, 11, 0, 1], [1, 3, 3, 5], [3, 5, 5, 2], [2, -4, 8, 4]].kramer([57,37,43,22]))
  end

  def test_float
    assert_equal([3.4, 0.8],Matrix[[1,-3], [3,-4]].kramer([1,7]))
  end

  def test_zero
    assert_equal("Система не имеет ни одного решения или имеет нескончаемое количество решений",Matrix[[0,0], [0,0]].kramer([1,7]))
  end
end


class TestGauss < Minitest::Test
  def test_null
    assert_equal([nil],gauss_method_sol(Matrix[[]].row_vectors))
  end

  def test_one
    assert_equal([1],gauss_method_sol(Matrix[[1]].row_vectors))
  end

  def test_zero
    assert_equal([-1,3,0,0],gauss_method_sol(Matrix[[1,2,3,4,5],[0,1,-1,2,3],[0,1,-1,2,3],[0,2,-2,4,6]].row_vectors))
  end

  def test_4
    assert_equal([19,-13,8],gauss_method_sol(Matrix[[1,2,1,1], [1,5,6,2],[1,5,7,10]].row_vectors))
  end

  def test_44
    assert_equal([-2,3,-4],gauss_method_sol(Matrix[[2,10,-3,38], [-3,-24,5,-86],[1,3,-5,27]].row_vectors))
  end

end