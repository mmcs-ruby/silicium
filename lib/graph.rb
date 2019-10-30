#require 'set'
#require 'silicium'

module Silicium
  module Graphs
    Pair = Struct.new(:first, :second)

    class GraphError < Error

    end

    class OrientedGraph
      def initialize(initializer = [])
        @vertices = {}
        @edge_labels = {}
        @vertex_labels = {}
        initializer.each do |v|
          add_vertex!(v[:v])
          v[:i].each { |iv| add_edge_force!(v[:v], iv)}
        end
      end

      def add_vertex!(vertex_id)
        if @vertices.has_key?(vertex_id)
          return
        end
        @vertices[vertex_id] = [].to_set
      end

      def add_edge!(from, to)
        if @vertices.has_key?(from) && @vertices.has_key?(to)
          @vertices[from] << to
        end
      end

      # should only be used in constructor
      def add_edge_force!(from, to)
        add_vertex!(from)
        add_vertex!(to)
        add_edge!(from, to)
      end

      def adjacted_with(vertex)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertices[vertex].clone
      end

      def label_edge!(from, to, label)
        unless @vertices.has_key?(from) && @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)] = label
      end

      def label_vertex!(vertex, label)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex] = label
      end

      def get_edge_label(from, to)
        if !@vertices.has_key?(from) || ! @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)]
      end

      def get_vertex_label(vertex)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex]
      end

      def vertex_number
        @vertices.count
      end

      def edge_number
        res = 0
        @vertices.values.each do |item|
          res += item.count
        end
        res
      end

      def vertex_label_number
        @vertex_labels.count
      end

      def edge_label_number
        @edge_labels.count
      end

      def has_vertex?(vertex)
        @vertices.has_key?(vertex)
      end

      def has_edge?(from, to)
        @vertices.has_key?(from) && @vertices[from].include?(to)
      end

      def delete_vertex!(vertex)
        if has_vertex?(vertex)
          @vertices.keys.each do |key|
            delete_edge!(key, vertex)
          end
          @vertices.delete(vertex)
          @vertex_labels.delete(vertex)

          @vertices.keys.each do |key|
            @edge_labels.delete(Pair.new(vertex, key))
          end
        end
      end

      def delete_edge!(from, to)
        if has_edge?(from, to)
          @vertices[from].delete(to)
          @edge_labels.delete(Pair.new(from, to))
        end
      end

    end

    class UnorientedGraph < OrientedGraph
      def add_edge!(from, to)
        super(from, to)
        super(to, from)
      end

      def label_edge!(from, to, label)
        super(from, to, label)
        super(to, from, label)
      end

      def delete_edge!(from, to)
        super(from, to)
        super(to, from)
      end

      def edge_number
        res = 0
        @vertices.each do |from, tos|
          tos.each {|to| res += (to == from ? 2 : 1)}
        end
        res / 2
      end
    end

    def dijkstra_algorythm(graph, starting_vertex)
      #
      root = starting_vertex
      @vertices.each{|k, v| @vertex_labels[k] = 2147483647}
      checked = 0
      @vertex_labels[root] = 0
      path = 0
      path_verts = []
      path_verts << root
      path_edges #??

      #
      until checked == @vertices.size
        nxt = @vertices[root]#reacheble verts
        nxt.map!{|x| @vertex_labels[x] = @edge_labels[(root, x)] }

        #next vert with min path
        min = nxt[0]
        nxt.each do |x|
          if ((path + @edge_labels[(root, x)]) =< @vertex_labels[min])#@vertex_labels[x] < @vertex_labels[min]
            min = x
          end

        end
        #
        checked +=1
        path_verts << root

        path +=  @edge_labels[(root, min)]

        #to the next vert
        root = min
      end
  end
  end
end