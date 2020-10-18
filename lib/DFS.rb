require 'silicium'

def depth_first_search?(graph, start, goal)
  visited = Hash.new(false)
  stack = []
  stack.push(start)
  until stack.empty?
    node = stack.pop
    if graph.vertices[node].nil?
      raise ArgumentError
    end
    return true if node == goal

    next if visited[node]

    visited[node] = true
    graph.vertices[node].each do |child|
      stack.push(child)
    end
  end
  false
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
    dfs_traverse_recursive(graph, child, visited, traversed) unless visited[child]
  end
end
