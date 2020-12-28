require_relative 'test_helper'
require  'tarjan_sort'

class TarjanTest < Minitest::Test
  include Silicium::Tarjan
def test_tarjan_alg
  n = 5
  g = Array(n)
  g[0] = [2, 1]
  g[1] = [3, 2]
  g[2] = [4, 3]
  g[3] = [4]
  g[4] = []
  f=[0,1,2,3,4]
  assert_equal(f,tarjan_alg(g))
end
def test_SortTarjan
  g=Array(5)
  g[0] = [2, 1]
  g[1] = [3, 2]
  g[2] = [4, 3]
  g[3] = [4]
  g[4] = []
  f=[0,1,2,3,4]
  t=SortTarjan.new(g.size())
  assert_equal(f, t.tarjan_Alg(g))
end
end
