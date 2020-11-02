require 'test_helper'
require 'graph_visualizer'
require 'ruby2d'
require 'ruby2d/color'

class GraphVisualizerTest < Minitest::Test
  include Silicium::GraphVisualizer
  include Silicium::Graphs

  def test_window_size
    change_window_size(500, 300)
    assert_equal(500, (Window.get :width))
    assert_equal(300, (Window.get :height))
  end

  def test_vertices_radius
    change_vertices_radius(35)
    assert_equal(35, @@vert_radius)
  end

  def test_edge_width
    change_edge_width(10)
    assert_equal(10, @@line_width)
  end

  def test_label_size
    change_label_size(10)
    assert_equal(10, @@label_size)
  end

  def test_graph_type_exception
    graph = 123
    assert_raises do
      set_graph(graph)
    end
  end

  def test_show
    change_window_size(1000, 600)
    change_edge_width(5)
    change_vertices_radius(20)
    change_label_size(15)

    graph = OrientedGraph.new([{v: :one, i: [ :one, :two, :four]},
                                      {v: :two, i:[ :one, :two]},
                                      {v: :five, i:[ :one,:three, :four]},
                                      {v: :four, i:[ :one, :four]},
                                      {v: :three, i:[ :one, :two]}])

    graph.label_vertex!(:one,'one')
    graph.label_vertex!(:two,'two')
    graph.label_vertex!(:three,'three')
    graph.label_vertex!(:four,'four')
    graph.label_vertex!(:five,'five')

    graph.label_edge!(:one,:one,'one to one')
    graph.label_edge!(:two,:two,'two to two')
    graph.label_edge!(:five,:four,'five to four')
    graph.label_edge!(:five,:three,'five to three')

    set_graph(graph)
    #uncomment me if you wanna see
    #show_window
  end

  def test_show_unoriented_graph
    change_window_size(1000, 600)
    graph = UnorientedGraph.new([{v: 0, i: [:one]}, {v: :one, i: [0, 'two']},
                              {v: 'two', i: [0, 'two']},{v: 2, i: [:one, 2]},
                              {v: :two, i: [2, 'two']}, {v: 'three', i: [0, 2]}])
    set_graph(graph)
    #uncomment me if you wanna see
    #show_window
    #show_window
  end
end
