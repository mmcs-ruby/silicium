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
    # Change window and image size
    def change_edge_width(w)
      @@line_width = w
    end

    ##
    # Change window and image size
    def change_vertices_radius(r)
      @@vert_radius = r
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
    ##
    # width of the edges
    @@line_width = 5
    ##
    # color of labels
    @@label_color = Color.new('red')
    ##
    # color of vertices
    @@vertex_color = Color.new('white')

    def set_oriented_graph(graph)
      set_vertices(graph)
      set_oriented_edges(graph)
      set_labels(graph)
    end

    def set_unoriented_graph(graph)
      set_vertices(graph)
      set_edges(graph)
    end

    ##
    # creates labels of edges and vertices
    def set_labels(graph)
      @v_labels = {}
      graph.vertex_labels.keys.each do |v|
        @v_labels[v] = draw_vertex_label(v, graph.vertex_labels[v])
      end

      @e_labels = {}
      graph.edge_labels.keys.each do |pair|
        @e_labels[pair] = draw_edge_label(pair, graph.edge_labels[pair])
      end
    end

    ##
    # draws label on vertex
    def draw_vertex_label(v,label)
      if (label.class != String and label.class != Integer)
        return
      end
      x = @vertices[v].x - Math.sqrt(2)/2*@@vert_radius
      y = @vertices[v].y - Math.sqrt(2)/2*@@vert_radius
      return Text.new(label,x: x, y: y, size: @@vert_radius, color: @@label_color)
    end

    ##
    # draws label on edge
    def draw_edge_label(pair,label)
      if (label.class != String and label.class != Integer)
        return
      end
      x1 = @vertices[pair[:first]].x
      y1 = @vertices[pair[:first]].y
      x2 = @vertices[pair[:second]].x
      y2 = @vertices[pair[:second]].y
      x_len = (x2-x1)/2
      y_len = (y2-y1)/2
      x = x1+x_len
      y = y1+y_len

      return Text.new(label,x: x, y: y, size: @@vert_radius, color: @@label_color)
    end

    ##
    # set all edges of the graph
    def set_oriented_edges(graph)
      @edges = {}
      @vertices.keys.each do |v1|
        graph.vertices[v1].each do |v2|
          col = Color.new('random')
          while (col == @@label_color) or (col == @@vertex_color)
            col = Color.new('random')
          end
          if @edges.has_key?(Pair.new(v2,v1))
            col = @edges[Pair.new(v2,v1)][:line].color
            break
          end
          @edges[Pair.new(v1,v2)] = draw_oriented_edge(v1,v2,col)
        end
      end
    end

    ##
    # draws all vertices of the graph
    def set_vertices(graph)
      @vertices = {}
      w = Window.get :width
      h = Window.get :height
      radius= [w,h].min*1.0 / 2 - @@vert_radius*4
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
    #
    # creates arrow of edge between vertices
    def draw_oriented_edge(v1,v2,col)
      line = draw_edge(v1,v2,col)

      x1 = @vertices[v1].x
      y1 = @vertices[v1].y
      x2 = @vertices[v2].x
      y2 = @vertices[v2].y

      x_len = x2-x1
      y_len = y2-y1
      len = Math.sqrt(x_len*x_len+y_len*y_len)
      sin = y_len/len
      cos = x_len/len
      pos_x1 = x2 - @@vert_radius*cos
      pos_y1 = y2 - @@vert_radius*sin
      height_x= pos_x1 - @@line_width*4*cos
      height_y= pos_y1 - @@line_width*4*sin
      sin, cos = cos, sin
      pos_x2 = height_x + @@line_width*2*cos
      pos_y3 = height_y + @@line_width*2*sin
      pos_x3 = height_x - @@line_width*2*cos
      pos_y2 = height_y - @@line_width*2*sin
      #triangle = Circle.new(x: pos_x2, y: pos_y3,radius: 4, color: col)
      #Circle.new(x: pos_x3, y: pos_y2,radius: 4, color: col)
      triangle = Triangle.new(x1: pos_x1, y1: pos_y1, x2: pos_x2, y2: pos_y2, x3: pos_x3, y3: pos_y3, color: col)

      return {line: line, triangle: triangle}
    end

    ##
    # creates edge between vertices
    def draw_edge(v1,v2,col)
      x1 = @vertices[v1].x
      y1 = @vertices[v1].y
      x2 = @vertices[v2].x
      y2 = @vertices[v2].y
      x_len = x1-x2
      y_len = y1-y2
      len = Math.sqrt(x_len*x_len+y_len*y_len)

      if len == 0
        return draw_loop(v1,col)
      end

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
      return Line.new(x1: pos_x0, y1: pos_y0, x2: pos_x1, y2: pos_y1, width: @@line_width, color: col)
    end

    ##
    # create loop edge
    def draw_loop(v,col)
      x = @vertices[v].x
      y = @vertices[v].y
      center_x = (Window.get :width) / 2
      center_y = (Window.get :height) / 2
      x_len = center_x-x
      y_len = center_y-y
      len = Math.sqrt(x_len*x_len+y_len*y_len)
      sin = y_len/len
      cos = x_len/len
      pos_x1 = x - @@vert_radius*cos*2
      pos_y1 = y - @@vert_radius*sin*2
      circle = Circle.new(x: pos_x1, y: pos_y1, radius: @@vert_radius*2, color: col)
      Circle.new(x: pos_x1, y: pos_y1, radius: @@vert_radius*2-@@line_width, color: Window.get( :background))
      @vertices[v] = Circle.new(x: x, y: y, radius: @@vert_radius+1, color: @vertices[v].color)
      return circle
    end


    def draw_unoriented_edge(x1,y1,x2,y2)
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

      return {line: line}
    end

    ##
    # show graph on the screen
    def show_window
      Window.show
    end
  end
end
