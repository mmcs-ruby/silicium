require 'silicium'
require 'ruby2d'


module Silicium
  #
  #
  #
  module GraphVisualiser

    def change_window_size(w, h)
      set width:w, height:h
    end

    def draw_vertex(x, y, sz, vert)
      v = Circle.new(x,y,sz)
    end


  end
end
