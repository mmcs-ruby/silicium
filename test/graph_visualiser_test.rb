require 'test_helper'
require 'graph_visualiser'
require 'chunky_png'
require 'ruby2d'

class GraphVisualiserTest < Minitest::Test
  include Silicium::GraphVisualiser

  def test_window_size
    change_window_size(500, 300)
    assert_equal(500, (Window.get :width))
    assert_equal(300, (Window.get :height))
  end

end
