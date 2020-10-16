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

  def test_show
    change_window_size(1000, 600)
    graph = OrientedGraph.new([{v: 0, i: [:one]}, {v: :one, i: [0, 'two']}, {v: 'two', i: [0, 'two']}])
    set_graph(graph)
    show_window
  end

end
