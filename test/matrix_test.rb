# frozen_string_literal: true
require 'test_helper'
require 'fast_matrix'
require 'matrix'

class SiliciumMatrixTest < Minitest::Test
  def test_init
    m = Silicium::Matrix.new(2, 4)
    assert_equal 2, m.row_size
    assert_equal 4, m.column_size
  end

  def test_init_from_brackets
    m = Silicium::Matrix[[1, 2], [3, 4]]
    assert_equal 1, m[0, 0]
    assert_equal 2, m[0, 1]
    assert_equal 3, m[1, 0]
    assert_equal 4, m[1, 1]
  end

  def test_equal_by_value
    m1 = Silicium::Matrix[[1, 2], [3, 4]]
    m2 = Silicium::Matrix[[1, 2], [3, 4]]
    assert m1 == m2 && m2 == m1, 'Equals fast matrices'
    m3 = ::Matrix[[1, 2], [3, 4]]
    assert m1 == m3 #&& m3 == m1, 'Equals fast matrix and standard matrix'
    m4 = Silicium::Matrix[[3, 4], [1, 2]]
    assert m1 != m4 && m4 != m1, 'Different fast matrices'
  end

  def test_convert
    fast = Silicium::Matrix[[1, 2], [3, 4]]
    standard = ::Matrix[[1, 2], [3, 4]]
    assert_equal standard, fast.convert
    assert_equal fast, Silicium::Matrix.convert(standard)
  end

  def test_init_column_vector
    m = Silicium::Matrix.column_vector([0, 1, 2, 3, 4])
    (0..4).each { |i| assert_equal i, m[i, 0] }
  end

  def test_get
    m = Silicium::Matrix.new(2, 4)
    m[1, 2] = 3.5
    assert_equal 3.5, m[1, 2]
  end

  def test_get_out_of_range
    m = Silicium::Matrix.new(2, 4)
    assert_raises(Silicium::Matrix::IndexError) { m[3, 5] }
  end

  def test_set_out_of_range
    m = Silicium::Matrix.new(2, 4)
    assert_raises(Silicium::Matrix::IndexError) { m[3, 5] = 0 }
  end

  def test_set_nan
    m = Silicium::Matrix.new(2, 4)
    assert_raises(Silicium::Matrix::TypeError) { m[1, 1] = 'not a number' }
  end

end
