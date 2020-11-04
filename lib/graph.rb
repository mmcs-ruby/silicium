#require 'set'
#require 'silicium'

module Silicium
  module Graphs
    Pair = Struct.new(:first, :second)

    class GraphError < Error

    end

    ##
    # Class represents oriented graph
    class OrientedGraph
      def initialize(initializer = [])
        @vertices = {}
        @edge_labels = {}
        @vertex_labels = {}
        @edge_number = 0
        initializer.each do |v|
          add_vertex!(v[:v])
          v[:i].each do |iv|
            add_vertex!(v[:v])
            add_vertex!(iv)
            add_edge!(v[:v], iv)
          end
        end
      end

      ##
      # Adds vertex to graph
      def add_vertex!(vertex_id)
        if @vertices.has_key?(vertex_id)
          return
        end
        @vertices[vertex_id] = [].to_set
      end

      ##
      # Adds edge to graph
      def add_edge!(from, to)
        protected_add_edge!(from, to)
        @edge_number += 1
      end

      # should only be used in constructor
      def add_edge_force!(from, to)
        add_vertex!(from)
        add_vertex!(to)
        add_edge!(from, to)
      end

      ##
      # Returns array of vertices which adjacted with vertex
      # @raise [GraphError] if graph does not contain vertex
      def adjacted_with(vertex)
        raise GraphError.new("Graph does not contain vertex #{vertex}") unless @vertices.has_key?(vertex)
        @vertices[vertex].clone
      end

      ##
      # Adds label to edge
      # @raise [GraphError] if graph does not contain edge
      def label_edge!(from, to, label)
        unless @vertices.has_key?(from) && @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)] = label
      end

      ##
      # Adds label to vertex
      # @raise [GraphError] if graph does not contain vertex
      def label_vertex!(vertex, label)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex] = label
      end

      ##
      # Returns edge label
      # @raise [GraphError] if graph does not contain edge
      def get_edge_label(from, to)
        if !@vertices.has_key?(from) || !@vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)]
      end

      ##
      # Returns vertex label
      # @raise [GraphError] if graph does not contain vertex
      def get_vertex_label(vertex)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex]
      end

      ##
      # Returns number of vertices
      def vertex_number
        @vertices.count
      end

      ##
      # Returns number of edges
      def edge_number
        @edge_number
      end

      ##
      # Returns number of vertex labels
      def vertex_label_number
        @vertex_labels.count
      end

      ##
      # Returns number of edge labels
      def edge_label_number
        @edge_labels.count
      end

      ##
      # Checks if graph contains vertex
      def has_vertex?(vertex)
        @vertices.has_key?(vertex)
      end

      ##
      # Checks if graph contains edge
      def has_edge?(from, to)
        @vertices.has_key?(from) && @vertices[from].include?(to)
      end

      ##
      # Deletes vertex from graph
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

      ##
      # Deletes edge from graph
      def delete_edge!(from, to)
        protected_delete_edge!(from, to)
        @edge_number -= 1
      end

      ##
      # Reverses graph
      def reverse!
        v = Hash.new()
        l = {}
        @vertices.keys.each do |from|
          v[from] = [].to_set
        end

        @vertices.keys.each do |from|
          @vertices[from].each do |to|
            v[to] << from
            if @edge_labels.include?(Pair.new(from, to))
              l[Pair.new(to, from)] = @edge_labels[Pair.new(from, to)]
            end
          end
        end
        @vertices = v
        @edge_labels = l
      end

      ##
      # Returns array of vertices
      def vertices
        @vertices
      end

      protected

      ##
      # Adds edge to graph
      def protected_add_edge!(from, to)
        if @vertices.has_key?(from) && @vertices.has_key?(to)
          @vertices[from] << to
        end
      end

      ##
      # Deletes edge from graph
      def protected_delete_edge!(from, to)
        if has_edge?(from, to)
          @vertices[from].delete(to)
          @edge_labels.delete(Pair.new(from, to))
        end
      end

    end

    ##
    # Class represents unoriented graph
    class UnorientedGraph < OrientedGraph
      ##
      # Adds edge to graph
      def add_edge!(from, to)
        protected_add_edge!(from, to)
        protected_add_edge!(to, from)
        @edge_number += 1
      end

      ##
      # Adds label to edge
      def label_edge!(from, to, label)
        super(from, to, label)
        super(to, from, label)
      end

      ##
      # Deletes edge from graph
      def delete_edge!(from, to)
        protected_delete_edge!(from, to)
        protected_delete_edge!(to, from)
        @edge_number -= 1
      end

    end

    ##
    # Implements breadth-first search (BFS)
    def breadth_first_search?(graph, start, goal)
      visited = Hash.new(false)
      queue = Queue.new
      queue.push(start)
      visited[start] = true
      until queue.empty? do
        node = queue.pop
        if node == goal
          return true
        end
        add_to_queue(graph, queue, node, visited)
      end
      false
    end

    ##
    # Adds to queue not visited vertices
    def add_to_queue(graph, queue, node, visited)
      graph.vertices[node].each do |child|
        unless visited[child]
          queue.push(child)
          visited[child] = true
        end
      end
    end

    ##
    # Checks if graph is connected
    def connected?(graph)
      start = graph.vertices.keys[0]
      goal = graph.vertices.keys[graph.vertex_number - 1]
      pred = breadth_first_search?(graph, start, goal)
      graph.reverse!
      pred = pred and breadth_first_search?(graph, goal, start)
      graph.reverse!
      pred
    end

    ##
    # Returns number of connected vertices
    def number_of_connected(graph)
      visited = Hash.new(false)
      res = 0
      graph.vertices.keys.each do |v|
        unless visited[v]
          dfu(graph, v, visited)
          res += 1
        end
      end
      res
    end

    ##
    # Passes graph's vertices and marks them visited
    def dfu(graph, vertice, visited)
      visited[vertice] = true
      graph.vertices[vertice].each do |item|
        unless visited[item]
          dfu(graph, item, visited)
        end
      end
    end


    ##
    # Implements algorithm of Dijkstra
    def dijkstra_algorithm(graph, starting_vertex)
      if !graph.has_vertex?(starting_vertex)
        raise GraphError.new("Graph does not contains vertex #{starting_vertex}")
      end
      vertices = graph.vertices.clone
      unvisited_vertices = vertices.clone.to_a
      labels = {}
      paths = {}
      vertices.each_key do |vertex|
        labels[vertex] = -1
        paths[vertex] = [starting_vertex]
      end
      labels[starting_vertex] = 0

      while unvisited_vertices.size > 0
        unvisited_vertices.sort do |a, b|
          -1 if labels[b[0]] == -1
          1 if labels[a[0]] == -1
          labels[a[0]] <=> labels[b[0]]
        end
        vertex = unvisited_vertices.first
        vertex[1].each do |adj|
          new_label = labels[vertex[0]] + graph.get_edge_label(vertex[0], adj)
          if change_label?(labels[adj], new_label)
            labels[adj] = new_label
            paths[adj] = paths[vertex[0]].clone
            paths[adj].push adj
          end
        end
        unvisited_vertices.delete_at(0)
      end
      {"labels" => labels, "paths" => paths}
    end

    private

    def change_label?(label, new_label)
      return true if label == -1
      return false if new_label == -1
      return new_label < label
    end

  end
end

