require "set"

module Silicium
  module Graphs
    class Graph
      attr_accessor :nodes

      def initialize
        @nodes = []
      end

      def add_edge(from, to)
        from.adjacents << to
      end
    end

    class Node
      attr_accessor :name, :adjacents

      def initialize(name)
        # using Set instead of an Array to avoid duplications
        @adjacents = Set.new
        @name = name
      end

      def to_s
        @name
      end
    end

    class TopologicalSortClass
      attr_accessor :post_order

      def initialize(graph)
        @post_order = []
        @visited = []

        graph.nodes.each { |node| dfs(node) unless @visited.include?(node)}
      end

      private
      def dfs(node)
        @visited << node
        node.adjacents.each { |adj_node| dfs(adj_node) unless @visited.include?(adj_node)}

        @post_order << node
      end
    end
  end
end
