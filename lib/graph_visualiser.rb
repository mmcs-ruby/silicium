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

    ##
    # radius of vertices circles
    @@vert_radius = 15

    def set_oriented_graph(graph)
      set_vertices(graph)
      set_edges(graph)
    end

    def set_unoriented_graph(graph)
      set_vertices(graph)
    end

    ##
    # set all edges of the graph
    def set_edges(graph)
      @edges = {}
      #
      #temp_coordinates = Hash.new
      #@vertices.each do |vert|
      #  temp_coordinates[vert[:v]] = vert
      #end

      @vertices.keys.each do |v1|
        graph.vertices[v1].each do |v2|
          c1 = @vertices[v1]
          c2 = @vertices[v2]
          arrow = draw_oriented_edge(c1.x,c1.y,c2.x,c2.y)
          @edges[v1] = {vert1: v1, vert2: v2, arrow: arrow}
        end
      end
    end

    ##
    # draws all vertices of the graph
    def set_vertices(graph)
      @vertices = {}
      w = Window.get :width
      h = Window.get :height
      radius= [w,h].min*1.0 / 2 - 50
      vert_step = (360.0  / graph.vertex_number)*(Math::PI/180)
      position = 0
      graph.vertices.keys.each do |vert|
        x = w/2 + Math.cos(position)*radius
        y = h/2 + Math.sin(position)*radius
        @vertices[vert] = draw_vertex(x,y)
        position += vert_step
      end
    end

    ##
    # creates circle for vertex
    def draw_vertex(x, y)
      circle = Circle.new(x: x, y: y, radius: @@vert_radius, sectors: 128)
      return circle
    end

    ##
    # creates arrow of edge between vertices
    def draw_oriented_edge(x1,y1,x2,y2)
      col = Color.new('random')
      x_len = x1-x2
      y_len = y1-y2
      len = Math.sqrt(x_len*x_len+y_len*y_len)
      sin = y_len/len
      cos = x_len/len
      pos_x0 = x1 - @@vert_radius*cos
      pos_y0 = y1 - @@vert_radius*sin

      x_len = x2-x1
      y_len = y2-y1
      sin = y_len/len
      cos = x_len/len
      pos_x1 = x2 - @@vert_radius*cos
      pos_y1 = y2 - @@vert_radius*sin

      line = Line.new(x1: pos_x0, y1: pos_y0, x2: pos_x1, y2: pos_y1, width: 5, color: col)
      height_x= pos_x1 - 20*cos
      height_y= pos_y1 - 20*sin
      sin, cos = cos, sin
      pos_x2 = height_x + 20*cos
      pos_y3 = height_y + 20*sin
      pos_x3 = height_x - 20*cos
      pos_y2 = height_y - 20*sin
      #triangle = Circle.new(x: pos_x2, y: pos_y3,radius: 4, color: col)
      #Circle.new(x: pos_x3, y: pos_y2,radius: 4, color: col)
      triangle = Triangle.new(x1: pos_x1, y1: pos_y1, x2: pos_x2, y2: pos_y2, x3: pos_x3, y3: pos_y3, color: col)

      return {line: line, triangle: triangle}
    end
    ##
    # show graph on the screen
    def show_window
      Window.show
    end
  end
end
