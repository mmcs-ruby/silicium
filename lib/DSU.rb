module Silicium
  module Dsu

#реализация системы непересекающихся множеств
class DSUU
  attr_accessor :parent, :rank
  def initialize(n)
    @parent=Array(n)
    @rank=Array(n)
  end
  def make_set(v)
    @parent[v] = v
    @rank[v] = 0
  end

  def find_set(v)
    if (v == @parent[v])
      return v
    end
    return @parent[v]=find_set(@parent[v])

  end

  def union_sets(a, b)
    a = find_set(a)
    b = find_set(b)
    if (a != b)
      if (@rank[a] < @rank[b])
        swap(a, b)
      end
      @parent[b] = a
      if (@rank[a] == @rank[b])
        @rank[a]+=1
      end

    end
  end
end
  end
  end
