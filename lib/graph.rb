#require 'set'
#require 'silicium'

module Silicium
  module Graphs
    Pair = Struct.new(:first, :second)

    class GraphError < Error

    end

    class OrientedGraph
      @vertices
      @edge_labels

      def initialize(initializer = [])
        @vertices = {}
        @edge_labels = {}
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

      def add_edge_force!(from, to)
        add_vertex!(from)
        add_vertex!(to)
        @vertices[from] << to
      end

      def adjacted_with(vertex)
        if !@vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #vertex")
        end

        @vertices[vertex].clone
      end

      def label_edge!(from, to, label)
        if !@vertices.has_key?(from) || ! @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#from, #to)")
        end

        @edge_labels[Pair.new(from, to)] = label
      end

      def get_label(from ,to)
        if !@vertices.has_key?(from) || ! @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#from, #to)")
        end

        @edge_labels[Pair.new(from, to)]
      end

      def vertex_number
        @vertices.count
      end

      def has_vertex?(vertex)
        @vertices.has_key?(vertex)
      end

      def has_edge?(from, to)
        @vertices.has_key?(from) && @vertices[from].include?(to)
      end
    end
  end
end