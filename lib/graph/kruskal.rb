module Silicium
  module Graphs

    class UnionFind
      def initialize(graph)
        @parents = []
        graph.vertices.keys.each do |vertex|
          @parents[vertex] = vertex
        end
      end

      def connected?(vertex1, vertex2)
        @parents[vertex1] == @parents[vertex2]
      end

      def union(vertex1, vertex2)
        parent1, parent2 = @parents[vertex1], @parents[vertex2]
        @parents.map! { |i| i == parent1 ? parent2 : i }
      end
    end

    # Implements algorithm of Kruskal
    def kruskal_mst(graph)
      mst = UnorientedGraph.new
      uf = UnionFind.new(graph)
      graph_to_sets(graph).each do |edge, label|
        unless uf.connected?(edge[0], edge[1])
          add_edge!(mst, edge, label)
          uf.union(edge[0], edge[1])
        end
      end
      mst
    end

  end
end