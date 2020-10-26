require 'test_helper'
require 'AVLTree'

class AVLTest < Minitest::Test

  def setup
    @my_tree = AvlTree.new([2, 3])
  end

  def test_init
    assert_equal(@my_tree.tree_size,2)
    node3 = @my_tree.find(3)
    assert_equal(node3.data,3)
    assert_nil(@my_tree.find(6))
  end

  def test_insert_value
    (-5..2).each { |i|
      @my_tree.insert_value(i)
    }
    assert_equal(@my_tree.dummy.left, @my_tree.find(-5))
    assert_equal(@my_tree.insert_value(-3).data, -3)
  end

  def test_delete
    @my_tree.delete(3)
    assert_equal(@my_tree.tree_size, 1)
    assert_nil(@my_tree.find(3))
    @my_tree.insert_value(5)
    @my_tree.insert_value(-2)
    @my_tree.insert_value(3)
    @my_tree.delete(5)
    assert_equal(@my_tree.tree_size,3)
  end

  def test_delete2
    @my_tree.insert_value(5)
    @my_tree.insert_value(6)
    @my_tree.delete(5)
    assert_equal(@my_tree.tree_size,3)
    @my_tree.delete(3)
    assert_equal(@my_tree.tree_size,2)
  end

  def test_find
    (-5..10).each { |i|
      @my_tree.insert_value(i)
    }
    node10 = @my_tree.find(10)
    assert_equal(node10.data, 10)
  end
end

