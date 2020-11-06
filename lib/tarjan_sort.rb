module Silicium
  module Tarjan

    def tarjan_alg(graph)
      #алгоритм Тарьяна. Получаем граф как после топологической сортировки
      top_sort = []
      states = Array(graph.size)
      states.each do |item|
        item = 0 #0,1,2 - аналог white, grey, black
      end
      while true
        node_search = nil
        (0..graph.size - 1).each { |i|
          if states[i] == 0
            node_search = i
          end
          if node_search == nil
            return top_sort.reverse
          end
          if (!TarjanDepth(graph, node_search, states, top_sort))
            return nil
          end
        }
      end
      top_sort.reverse
      return top_sort
    end

    def tarjan_depth(graph, node, states, top_sort)
      if states[node] == 1
        return false
      end
      if states[node] == 2
        return true
      end
      states[node] = 1
      (0..graph[node].size - 1).each do |j|
        if (!tarjan_depth(graph, graph[node][j], states, top_sort))
          return false
        end
      end
      states[node] = 2
      top_sort.push(node)
      return true
    end

    # аналогично - алгоритм Тарьяна, сделанный немного иначе
    class SortTarjan
      attr_accessor :topSorts, :states

      def initialize(n)
        @topSorts = []
        @states = Array(n)
        (0..n - 1).each { |i|
          @states[i] = 0
        }
      end

      def tarjan_Alg(graph)
        tarjan_Depth(0, graph)
        return @topSorts.reverse
      end

      def tarjan_Depth(node, graph)
        if @states[node] == 1
          return false
        end
        if @states[node] == 2
          return true
        end
        @states[node] = 1
        graph[node].each do |i|
          if tarjan_Depth(i, graph) == false
            return false
          end
        end
        @states[node] = 2
        @topSorts.push(node)
        return true
      end

    end
  end
end