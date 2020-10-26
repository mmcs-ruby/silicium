require 'test_helper'
require 'graph_visualiser'
require 'chunky_png'
require 'ruby2d'

class GraphVisualiserTest < Minitest::Test
  include Silicium::GraphVisualiser
  include Silicium::Graphs

  def test_window_size
    change_window_size(500, 300)
    assert_equal(500, (Window.get :width))
    assert_equal(300, (Window.get :height))
  end

  def test_show_oriented_graph
    change_window_size(1000, 600)
    #graph = OrientedGraph.new([{v: 0, i: []}, {v: :one, i: []}, {v: 'two', i: [0]}])
    graph = OrientedGraph.new([{v: 0, i: [:one]}, {v: :one, i: [0, 'two']}, {v: 'two', i: [0, 'two']},{v: 2, i: [:one, 2]}, {v: :two, i: [2, 'two']}, {v: 'three', i: [0, 2]}])
    set_graph(graph)
    #uncomment me if you wanna see
    #show_window
  end

  def test_show_unoriented_graph
    change_window_size(1000, 600)
    #graph = OrientedGraph.new([{v: 0, i: []}, {v: :one, i: []}, {v: 'two', i: [0]}])
    graph = UnorientedGraph.new([{v: 0, i: [:one]}, {v: :one, i: [0, 'two']}, {v: 'two', i: [0, 'two']},{v: 2, i: [:one, 2]}, {v: :two, i: [2, 'two']}, {v: 'three', i: [0, 2]}])
    set_graph(graph)
    #uncomment me if you wanna see
    show_window
  end
end
