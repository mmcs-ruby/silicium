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

    public

    ##
    # Change window and image size
    def change_window_size(w, h)
      (Window.get :window).set width: w, height: h
    end

    ##
    # Set graph for visualization
    def set_graph(graph)
      if graph.class == OrientedGraph
        set_oriented_graph(graph)
      elsif graph.class == UnorientedGraph
        set_unoriented_graph(graph)
      elsif
        raise 'Wrong type of graph!'
      end
    end

    private

    def set_oriented_graph(graph)
      @vertices = []
      w = Window.get :width
      h = Window.get :height
      radius= [w,h].max*1.0 / 2 - 50;
      vert_step = 360.0  / graph.vertex_number
      position = 0
      graph.vertices.each do |vert|
        x = w/2 + Math.cos(position)*radius
        y = h/2 + Math.sin(position)*radius
        @vertices << {v: vert ,circ: draw_vertex(x,y,10)}
        position += vert_step
      end

    end

    def set_unoriented_graph(graph)

    end

    ##
    # creates circle for vertex
    def draw_vertex(x, y, sz)
      circle = Circle.new(x: x, y: y, radius: sz)
      return circle
    end

    ##
    # show graph on the screen
    def show_window
      Window.show
    end
  end
end
