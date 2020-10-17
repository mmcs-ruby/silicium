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
        if !@vertices.has_key?(from) || ! @vertices[from].include?(to)
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
    # Class represents computational graph
    class ComputationalGraph
      attr_accessor :graph,:size
      def initialize(expr_s)
        expr_proc = Polish_Parser(expr_s,[])
        pre_graph = []
        @graph = []
        @size = 0
        expr_proc.split.each do |elem|
          case elem
          when "+"
            dot = CompGates::Summ_Gate.new(elem)
            dot.connect(pre_graph.pop,pre_graph.pop)
            pre_graph.push(dot)
            @graph.push(dot)
            @size +=1
          when "*"
            dot = CompGates::Mult_Gate.new(elem)
            dot.connect(pre_graph.pop,pre_graph.pop)
            pre_graph.push(dot)
            @graph.push(dot)
            @size +=1
          when "/"
            dot = CompGates::Div_Gate.new(elem)
            scnd = pre_graph.pop
            frst = pre_graph.pop
            dot.connect(frst,scnd)
            pre_graph.push(dot)
            @graph.push(dot)
            @size +=1
          else
            dot = CompGates::Comp_Gate.new(elem)
            pre_graph.push(dot)
            @graph.push(dot)
            @size +=1
          end
        end
      end
      #Compute a value of expression
      def ForwardPass(variables_val)
        @graph.each do |elem|
          if elem.class != CompGates::Comp_Gate
            elem.forward_pass
          else
            elem.frwrd = variables_val[elem.name]
          end
        end
        return graph.last.frwrd
      end
      #Compute a gradient value for inputs
      def BackwardPass(loss_value)
        param_grad = Hash.new()
        @graph.last.bckwrd = loss_value
        @graph.reverse.each do |elem|
          if elem.class != CompGates::Comp_Gate
            elem.backward_pass
          else
            param_grad[elem.name] = elem.bckwrd
          end
        end
        return param_grad
      end
      #String preprocessing algorithm expression for computition
      def self.Polish_Parser(iStr, stack)
        priority = Hash["(" => 0, "+" => 1, "-" => 1, "*" => 2, "/" => 2, "^" => 3]
        case iStr
        when /^\s*([^\+\-\*\/\(\)\^\s]+)\s*(.*)/ then $1 + " " + Polish_Parser($2, stack)
        when /^\s*([\+\-\*\/\^])\s*(.*)/
          if (stack.empty? or priority[stack.last] < priority[$1]) then Polish_Parser($2, stack.push($1))
          else stack.pop + " " + Polish_Parser(iStr, stack) end
        when /^\s*\(\s*(.*)/ then Polish_Parser($1, stack.push("("))
        when /^\s*\)\s*(.*)/
          if stack.empty? then raise "Error: Excess of closing brackets."
          elsif priority[head = stack.pop] > 0 then head + " " + Polish_Parser(iStr, stack)
          else Polish_Parser($1, stack) end
        else if stack.empty? then ""
             elsif priority[stack.last] > 0 then stack.pop + " " + Polish_Parser(iStr, stack)
             else raise "Error: Excess of opening brackets." end
        end
      end
    end
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
    # Implements algorythm of Dijkstra
    def dijkstra_algorythm(graph, starting_vertex)
      #
    end
    module CompGates
      class Comp_Gate
        attr_accessor :frwrd,:bckwrd,:out,:name
        def initialize(name)
          @name = name
          @frwrd = self
        end
      end
      class Summ_Gate < Comp_Gate
        attr_accessor :in_frst,:in_scnd
        def initialize(name)
          super(name)
        end
        def connect(f_n,s_n)
          @in_frst = f_n
          @in_scnd = s_n
          f_n.out = self
          s_n.out = self
        end
        def forward_pass()
          @frwrd = @in_frst.frwrd + @in_scnd.frwrd
        end
        def backward_pass()
          @in_frst.bckwrd = @bckwrd
          @in_scnd.bckwrd = @bckwrd
        end

      end
      class Mult_Gate < Comp_Gate
        attr_accessor :in_frst,:in_scnd
        def initialize(name)
          super(name)
        end
        def connect(f_n,s_n)
          @in_frst = f_n
          @in_scnd = s_n
          f_n.out = self
          s_n.out = self
        end
        def forward_pass()
          @frwrd = @in_frst.frwrd * @in_scnd.frwrd
        end
        def backward_pass()
          @in_frst.bckwrd = @bckwrd * @in_scnd.frwrd
          @in_scnd.bckwrd = @bckwrd * @in_frst.frwrd
        end

      end
      class Div_Gate < Comp_Gate
        attr_accessor :in_frst,:in_scnd
        def initialize(name)
          super(name)
        end
        def connect(f_n,s_n)
          @in_frst = f_n
          @in_scnd = s_n
          f_n.out = self
          s_n.out = self
        end
        def forward_pass()
          @frwrd = @in_frst.frwrd / @in_scnd.frwrd
        end
        def backward_pass()
          @in_frst.bckwrd = @bckwrd * ((-1)/(@in_scnd.frwrd ** 2))
          @in_scnd.bckwrd = @bckwrd * ((-1)/(@in_frst.frwrd ** 2))
        end

      end
    end
  end
end
