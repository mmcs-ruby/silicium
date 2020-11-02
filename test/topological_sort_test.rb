require "test_helper"
require 'topological_sort'

class TopologicalSortTest < Minitest::Test
  include Silicium::Graphs

  def test_it_DOES_something_useful
    assert true
  end

  def test_topological_sort_empty
    assert TopologicalSortClass.new(Graph.new).post_order == []
  end

  def test_topological_sort_single
    graph = Graph.new
    graph.nodes << (Node.new(1))
    assert TopologicalSortClass.new(graph).post_order.map(&:to_s) == [Node.new(1)].map(&:to_s)
  end

  def test_topological_sort_two_nodes
    graph = Graph.new
    graph.nodes << (node1 = Node.new(1))
    graph.nodes << (node2 = Node.new(2))
    graph.add_edge(node1, node2)
    res = [Node.new(2), Node.new(1)]
    assert TopologicalSortClass.new(graph).post_order.map(&:to_s) == res.map(&:to_s)
  end

  def test_topological_sort_1
    graph = Graph.new
    graph.nodes << (node1 = Node.new(1))
    graph.nodes << (node2 = Node.new(2))
    graph.nodes << (node3 = Node.new(3))
    graph.nodes << (node4 = Node.new(4))
    graph.nodes << (node5 = Node.new(5))
    graph.add_edge(node1, node2)
    graph.add_edge(node1, node5)
    graph.add_edge(node2, node3)
    graph.add_edge(node2, node4)
    res = [Node.new(3), Node.new(4), Node.new(2), Node.new(5), Node.new(1)]
    assert TopologicalSortClass.new(graph).post_order.map(&:to_s) == res.map(&:to_s)
  end

  def test_topological_sort_2
    graph = Graph.new
    graph.nodes << (node1 = Node.new(1))
    graph.nodes << (node2 = Node.new(2))
    graph.nodes << (node3 = Node.new(3))
    graph.nodes << (node4 = Node.new(4))
    graph.nodes << (node5 = Node.new(5))
    graph.nodes << (node6 = Node.new(6))
    graph.nodes << (node7 = Node.new(7))
    graph.add_edge(node1, node2)
    graph.add_edge(node3, node5)
    graph.add_edge(node2, node3)
    graph.add_edge(node2, node4)
    graph.add_edge(node4, node1)
    graph.add_edge(node5, node7)
    graph.add_edge(node7, node3)
    graph.add_edge(node3, node6)
    graph.add_edge(node7, node1)
    graph.add_edge(node6, node4)
    graph.add_edge(node6, node2)
    res = [Node.new(7), Node.new(5), Node.new(4), Node.new(6), Node.new(3), Node.new(2), Node.new(1)]
    assert TopologicalSortClass.new(graph).post_order.map(&:to_s) == res.map(&:to_s)
  end
end