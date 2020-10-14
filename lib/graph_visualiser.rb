require 'silicium'
require 'chunky_png'
require 'ruby2d'
require 'ruby2d/window'


module Silicium
  #
  #
  #
  module GraphVisualiser
    include Silicium::Graphs
    include Ruby2D

    def change_window_size(w, h)
      (Window.get :window).set width: w, height: h
    end

    def draw_vertex(x, y, sz, vert)
      v = Circle.new(x: x, y: y, radius: sz)
    end

    def show_window
      show
    end
  end
end
