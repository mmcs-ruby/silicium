require "test_helper"

class SiliciumMatrixTest < Minitest::Test
  include Silicium

  def test_init
    m = Matrix.new(2, 4)
    assert_equal 4, m.column_size
    assert_equal 2, m.row_size
  end

  def test_get
    m = Matrix.new(2, 4)
    m[1, 2] = 3.5
    assert_equal 3.5, m[1, 2]
  end

  def test_get_out_of_range
    m = Matrix.new(2, 4)
    assert_raises(Matrix::IndexError) { m[3, 5] }
  end

  def test_set_out_of_range
    m = Matrix.new(2, 4)
    assert_raises(Matrix::IndexError) { m[3, 5] = 0 }
  end

  def test_set_nan
    m = Matrix.new(2, 4)
    assert_raises(Matrix::TypeError) { m[1, 1] = 'not a number' }
  end

end
