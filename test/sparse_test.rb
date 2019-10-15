require "test_helper"

class SparseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Silicium::VERSION
  end

  def test_that_add_works
    m = ::Silicium::SparseMatrix.new(3, 3)
    m.add(0, 0, 1)

    assert_equal [[0, 0, 1]], m.triplets
  end
end

