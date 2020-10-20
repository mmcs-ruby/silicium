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

        # Step 2: Transpose adjacency list
        transposed = transpose_adjacency_list

        # Step 3: Launch second DFS in reverse order of timestamps from Step 1 to build components.
        visited = Hash.new(false)
        order.reverse.each do |v|
          unless visited[v]
            component = []
            visited, component = scc_dfs_second v, component, visited, transposed
            res << component
          end
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
        order << v unless order.include? v
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
      #   +visited+:        array of booleans representing which vertices have been processed;
      #   +transposed+:     transposed adjacency list.
      #
      # @return Tuple <code>[visited, component]</code> of params changed during current step of DFS.
      def scc_dfs_second(v, component, visited, transposed)
        visited[v] = true
        component << v
        transposed[v].each do |adj|
          unless visited[adj]
            visited, component = scc_dfs_second adj, component, visited, transposed
          end
        end
        [visited, component]
      end
    end
  end

end
