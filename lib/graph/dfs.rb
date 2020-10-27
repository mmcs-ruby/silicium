require 'silicium'
module Silicium
  module Graphs

    def depth_first_search?(graph, start, goal)
      visited = Hash.new(false)
      stack = [start]
      until stack.empty?
        node = stack.pop
        return true if goal_node?(graph, node, goal)
        add_to_stack(graph, node, stack, visited)
      end
      false
    end

    def goal_node?(graph, node, goal)
      raise ArgumentError if graph.vertices[node].nil?

      node == goal
    end

    def add_to_stack(graph, node, stack, visited)
      return if visited[node]

      visited[node] = true
      graph.vertices[node].each do |child|
        stack.push(child)
      end
    end

    def dfs_traverse(graph, start)
      visited = Hash.new(false)
      traversed = []
      dfs_traverse_recursive(graph, start, visited, traversed)
      traversed
    end

    def dfs_traverse_recursive(graph, node, visited, traversed)
      visited[node] = true
      traversed.push(node)
      graph.vertices[node].each do |child|
        unless visited[child]
          dfs_traverse_recursive(graph, child, visited, traversed)
        end
      end
    end
  end
end