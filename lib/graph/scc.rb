module Silicium

  module Graphs
    class OrientedGraph
      include Graphs

      ##
      # Finds Strongly Connected Components (SCC) in graph. SCC is a subgraph where every vertex is reachable from every other vertex.
      # @return Array of SCC. Each component is represented as Array of vertices in decreasing order of their DFS timestamps.
      # @author vaimon
      def find_strongly_connected_components
        # Vertices we have already visited.
        visited = Hash.new(false)
        # Timestamps got during depth-first search.
        order = []
        # Resulting array of SCC.
        res = []

        # Step 1: Launch DFS to get order marks
        @vertices.keys.each do |key|
          visited, order = scc_dfs_first key, visited, order unless visited[key]
        end
        order.uniq!

        # Step 2: Transpose adjacency list
        transposed = transpose_adjacency_list

        # Step 3: Launch second DFS in reverse order of timestamps from Step 1 to build components.
        # HACK: In original algorithm, we use *visited* again, but here the code is a bit
        # optimized using *order* instead of *visited*
        until order.empty?
          component = []
          order, component = scc_dfs_second order.last, component, order, transposed
          res << component
        end
        res
      end


      protected

      ##
      # Processes the first pass of <b>depth-first search</b> as a step of SCC search algorithm.
      #
      # Parameters:
      #   +v+:          current vertex;
      #   +visited+:    array of booleans representing which vertices have been processed;
      #   +order+:      array of vertex exit timestamps.
      #
      # @return Tuple <code>[visited, order]</code> of params changed during current step of DFS.
      def scc_dfs_first(v, visited, order)
        visited[v] = true
        @vertices[v].each do |adj|
          visited, order = scc_dfs_first adj, visited, order unless visited[adj]
        end
        order << v
        [visited, order]
      end

      ##
      # Transposes adjacency list as a step of SCC search algorithm.
      #
      #   g.vertices                    #=> {1 => [2,3], 2 => [3], 3 => []}
      #   g.transpose_adjacency_list    #=> {2=>[1], 3=>[1, 2]}
      def transpose_adjacency_list
        # HACK
        res = Hash.new { |h, k| h[k] = [] }
        @vertices.each do |vert, adj|
          adj.each { |x| res[x] << vert }
        end
        res
      end

      ##
      # Processes the second pass of <b>depth-first search</b> collecting vertices to a component as a step of SCC search algorithm.
      #
      # Parameters:
      #   +v+:              current vertex;
      #   +component+:      component we are building;
      #   +order+:          order of timestamps got after first DFS;
      #   +transposed+:     transposed adjacency list.
      #
      # @return Tuple <code>[order, component]</code> of params changed during current step of DFS.
      def scc_dfs_second(v, component, order, transposed)
        order.delete v
        component << v
        transposed[v].each do |adj|
          if order.include? adj
            order, component = scc_dfs_second adj, component, order, transposed
          end
        end
        [order, component]
      end
    end
  end

end
