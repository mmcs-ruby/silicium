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
end



