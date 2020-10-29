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


  def test_vertices_radius
    change_vertices_radius(35)
    assert_equal(35, @@vert_radius)
  end

  def test_edge_width
    change_edge_width(10)
    assert_equal(10, @@line_width)
  end

  def test_show
    change_window_size(1000, 600)
    change_edge_width(5)
    change_vertices_radius(20)
    #graph = OrientedGraph.new([{v: 0, i: []}, {v: :one, i: []}, {v: 'two', i: [0]}])
    graph = OrientedGraph.new([{v: 0, i: [:one]},
                               {v: :one, i: [0, 'two']},
                               {v: 'two', i: [0, 'two']},
                               {v: 2, i: [:one, 2]},
                               {v: :two, i: [2, 'two']},
                               {v: 'three', i: [0, 2]}])
    graph.label_vertex!(:one,'one')
    graph.label_vertex!(0,'null')
    graph.label_vertex!('two','two')
    graph.label_vertex!(2,'2')
    graph.label_vertex!(:two,':two')
    graph.label_vertex!('three',3)

    graph.label_edge!(0,:one,'0 to one')
    #graph.label_edge!(:one,0,'one to 0')
    graph.label_edge!(:one,'two','one to two')
    graph.label_edge!(2,:one,'2 to one')
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
