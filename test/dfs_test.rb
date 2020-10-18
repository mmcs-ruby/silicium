require 'test_helper'
require 'silicium_test'
require 'graph'
require 'DFS'

class DFSTest <  SiliciumTest
  include Silicium::Graphs
  # graph to check implementation
  #        1
  #  /     |      \
  # 2      5       9
  # |    /   \     |
  # 3   6     8    10
  # |   |
  # 4   7
  @@graph = OrientedGraph.new([{v: 1, i: [2, 5, 9] },
                               { v: 2, i: [3] },
                               { v: 3, i: [4] },
                               { v: 5, i: [6, 8] },
                               { v: 6, i: [7] },
                               { v: 9, i: [10] }])
  def test_dfs_traverse_full
    assert_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], dfs_traverse(@@graph, 1))
  end

  def test_dfs_traverse_branch
    assert_equal([5, 6, 7, 8], dfs_traverse(@@graph, 5))
    assert_equal([9, 10], dfs_traverse(@@graph, 9))
    assert_equal([2, 3, 4], dfs_traverse(@@graph, 2))
  end

  def test_dfs_traverse_leaves
    assert_equal([4], dfs_traverse(@@graph, 4))
    assert_equal([7], dfs_traverse(@@graph, 7))
  end
  
  def test_dfs_traverse_loop
    looped_graph = OrientedGraph.new([{v: :A, i: [:B, :C, :E] },
                                      { v: :B, i: [:D, :F] },
                                      { v: :F, i: [:E] },
                                      { v: :C, i: [:G] }])
    assert_equal([:A, :B, :D, :F, :E, :C, :G], dfs_traverse(looped_graph, :A))
  end

  def test_dfs_root_leaf
    assert(depth_first_search?(@@graph, 1, 7))
  end

  def test_dfs_start_not_existed
    assert_raises ArgumentError do
      depth_first_search?(@@graph, 'third', 9)
    end
  end

  def test_dfs_goal_not_existed
    assert(!depth_first_search?(@@graph, 1, 'one'))
  end

  def test_dfs_inner_vertices
    assert(depth_first_search?(@@graph, 5,6))
  end

  def test_dfs_two_leaves
    assert(!depth_first_search?(@@graph, 7, 10))
  end



end
