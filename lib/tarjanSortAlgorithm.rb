module Silicium
  module Tarjan
#алгоритм Тарьяна. Получаем граф как после топологической сортировки
def TarjanAlg(graph)
  topSort=[]
  states=Array(graph.size())
  for i in 0..graph.size()-1 do
    states[i]=0 #0,1,2 - аналог white, grey, black
  end
  while (true)
    nodeToSearch=nil
    for i in 0..graph.size()-1 do
      if (states[i]==0)
        nodeToSearch=i
      end
      if (nodeToSearch==nil)
        return topSort.reverse()
      end
      if (!TarjanDepth(graph,nodeToSearch, states, topSort))
        return nil
      end
    end
  end
  topSort.reverse()
  return topSort
end

def TarjanDepth(graph,node, states, topSort)
  if (states[node]==1)
    return false
  end
  if (states[node]==2)
    return true
  end
  states[node]=1
  for j in 0..graph[node].size()-1 do
    if (!TarjanDepth(graph,graph[node][j],states,topSort))
      return false
    end
  end
  states[node]=2
  topSort.push(node)
  return true
end
#аналогично - алгоритм Тарьяна, сделанный немного иначе
class SortTarjan
  attr_accessor :topSorts, :states

  def initialize(n)
    @topSorts = []
    @states = Array(n)
    for i in 0..n-1 do
      @states[i]=0
    end
  end

  def TarjianAlg(graph)
    TarjianDepthSearch(0,graph)
    return @topSorts.reverse()
  end

  def TarjianDepthSearch(node, graph)
    if(@states[node]==1)
      return false
    end
    if(@states[node]==2)
      return true
    end
    @states[node]=1
    graph[node].each  do |i|
      if TarjianDepthSearch(i, graph)==false
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