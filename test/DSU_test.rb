require_relative 'test_helper'
require 'DSU'

class DSUTest < Minitest::Test
  include Silicium::Dsu
def test_DSUU
  dd=DSUU.new(6)
  dd.make_set(1)
  dd.make_set(2)
  dd.make_set(3)
  dd.make_set(4)
  dd.make_set(5)
  dd.make_set(6)
  assert_equal(1,dd.find_set(1))
  assert_equal(2,dd.find_set(2))
  assert_equal(3,dd.find_set(3))
  assert_equal(4,dd.find_set(4))
  dd.union_sets(1,2)
  dd.union_sets(5,6)
  dd.union_sets(5,4)
  dd.union_sets(1,5)
  assert_equal(1,dd.find_set(1))
  assert_equal(1,dd.find_set(2))
  assert_equal(3,dd.find_set(3))
  assert_equal(1,dd.find_set(4))
  assert_equal(1,dd.find_set(5))
end
end
