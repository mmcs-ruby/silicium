require "test/unit"
require 'test/unit/assertions'
require 'tarjanSortAlgorithm'
class TestSequence < Test::Unit::TestCase
def testTarjanAlg
  n = 5
  g = Array(n)
  g[0] = [2, 1]
  g[1] = [3, 2]
  g[2] = [4, 3]
  g[3] = [4]
  g[4] = []
  f=[0,1,2,3,4]
  assert_equal(f,TarjanAlg(g))
end
def testSortTarjan
  g=Array(5)
  g[0] = [2, 1]
  g[1] = [3, 2]
  g[2] = [4, 3]
  g[3] = [4]
  g[4] = []
  f=[0,1,2,3,4]
  t=SortTarjan.new(g.size())
  assert_equal(f, t.TarjianAlg(g))
end
end
