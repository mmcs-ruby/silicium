require "test_helper"

class SparseTest < Minitest::Test
  include Silicium::Sparse
  def test_that_it_has_a_version_number
    refute_nil ::Silicium::VERSION
  end

  def test_that_get_works
    m = SparseMatrix.new(3, 3)
    m.add(0, 1, 2)
    m.add(1, 0, 1)
    m.add(2, 1, 3)

    assert_equal 3, m.get(2, 1)
  end

  def test_that_add_works
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)

    assert_equal [[0, 0, 1]], m.triplets

  end

  def test_matrices_are_cloning
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)

    m1 = m.copy
    m1.add(2, 2, 1)

    assert_equal [[0, 0, 1]], m.triplets

  end

  def test_transpose_copy
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)
    m.add(1, 2, 2)
    m.add(2, 0, 4)
    m1 = m.transpose

    assert_equal [[0, 0, 1], [1, 2, 2], [2, 0, 4]], m.triplets
    assert_equal [[0, 0, 1], [2, 1, 2], [0, 2, 4]], m1.triplets

  end

  def test_transpose_original
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)
    m.add(1, 2, 2)
    m.add(2, 0, 4)
    m.transpose!

    assert_equal [[0, 0, 1], [2, 1, 2], [0, 2, 4]], m.triplets

  end

  def test_conversion_full_to_sparse
    mat = [[1, 0, 0],
           [2, 0, 0],
           [0, 0, 3]]
    m = SparseMatrix.sparse(mat)

    assert_equal [[0, 0, 1], [1, 0, 2], [2, 2, 3]], m.triplets

    mat = [[1, 0, 0],
           [0, 1, 1]]
    m = SparseMatrix.sparse(mat)

    assert_equal [[0, 0, 1], [1, 1, 1], [1, 2, 1]], m.triplets
  end

  def test_adding_matrix1
    m = SparseMatrix.new(3, 3)
    m.add(0, 2, 1)
    m.add(1, 0, 1)
    m.add(1, 1, 1)
    m.add(2, 0, 1)

    m1 = SparseMatrix.new(3,3)
    m1.add(0, 1, 1)
    m1.add(1, 0, 1)
    m1.add(2, 0, 1)
    m1.add(2, 2, 1)

    assert_equal [[0,1,1],[0,2,1],[1,0,2],[1,1,1],[2,0,2],[2,2,1]],m.adding(m1).triplets
  end

  def test_adding_matrix2
    m = SparseMatrix.new(2, 2)
    m.add(0, 0, -1)
    m.add(0, 1, 3)
    m.add(1, 0, -2)
    m.add(1, 1, 1)

    m1 = SparseMatrix.new(2,2)
    m1.add(0, 0, 1)
    m1.add(0, 1, 4)
    m1.add(1, 0, 2)
    m1.add(1, 1, 9)

    assert_equal [[0,1,7],[1,1,10]],m.adding(m1).triplets
  end

  def test_adding_matrix3
    m = SparseMatrix.new(2, 2)
    m.add(0, 0, -1)
    m.add(0, 1, 4)
    m.add(1, 0, -2)
    m.add(1, 1, 11)

    m1 = SparseMatrix.new(2,2)
    m1.add(0, 0, 1)
    m1.add(0, 1, -4)
    m1.add(1, 0, 2)
    m1.add(1, 1, -11)

    assert_equal [],m.adding(m1).triplets
  end

  def test_that_multiply_works_on_square_matrices
    m1 = SparseMatrix.new(2, 2)
    m1.add(0, 1, 1)
    m1.add(1, 0, 1)

    m2 = SparseMatrix.new(2, 2)
    m2.add(0, 0, 1)
    m2.add(1, 1, 1)

    arr = m1.multiply(m2)
    assert_equal [[0, 1], [1, 0]], arr
  end

  def test_that_multiply_works_on_non_square_matrices
    m1 = SparseMatrix.new(2, 3)
    m1.add(0, 0, 1)
    m1.add(1, 2, 2)

    m2 = SparseMatrix.new(3, 2)
    m2.add(0, 0, 2)
    m2.add(1, 1, 1)
    m2.add(2, 1, 1)

    arr = m1.multiply(m2)
    assert_equal [[2, 0], [0, 2]], arr
  end

  def test_sugar_adding
    m = SparseMatrix.new(2, 2)
    m.add(0, 0, -1)
    m.add(0, 1, 3)
    m.add(1, 0, -2)
    m.add(1, 1, 1)

    m1 = SparseMatrix.new(2, 2)
    m1.add(0, 0, 1)
    m1.add(0, 1, 4)
    m1.add(1, 0, 2)
    m1.add(1, 1, 9)

    assert_equal [[0, 1, 7], [1, 1, 10]], (m + m1).triplets
  end

  def test_mult_by_num
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)
    m.add(1, 2, 2)
    m.add(2, 0, 4)
    m1 = m.mult_by_num(-2)

    assert_equal [[0, 0, -2], [1, 2, -4], [2, 0, -8]], m1.triplets

  end

  def test_mult_by_num_zero
    m = SparseMatrix.new(3, 3)
    m.add(0, 0, 1)
    m.add(1, 2, 2)
    m.add(2, 0, 4)
    m1 = m.mult_by_num(0)

    assert_equal [], m1.triplets

  end

  def test_sugar_multiply
    m1 = SparseMatrix.new(2, 2)
    m1.add(0, 1, 1)
    m1.add(1, 0, 1)

    m2 = SparseMatrix.new(2, 2)
    m2.add(0, 0, 1)
    m2.add(1, 1, 1)

    arr = m1 * m2
    assert_equal [[0, 1], [1, 0]], arr
  end

  def test_sugar_subtraction
    m = SparseMatrix.new(2, 2)
    m.add(0, 0, -1)
    m.add(0, 1, 3)
    m.add(1, 0, 2)
    m.add(1, 1, 1)

    m1 = SparseMatrix.new(2, 2)
    m1.add(0, 0, 4)
    m1.add(0, 1, 4)
    m1.add(1, 0, 2)
    m1.add(1, 1, 9)

    assert_equal [[0, 0, -5], [0, 1, -1], [1, 1, -8]], (m - m1).triplets
  end

end





