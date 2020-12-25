require "test/unit"
require 'test/unit/assertions'
require 'Math'
require 'test_helper'
class MathTest < Minitest::Test
  include Silicium::BinPow
def testBin_Pow
  a = Bin_Pow(5,3)
  assert_equal(125, a);
  assert_equal(91125, Bin_Pow(45,3));
  assert_equal(36, Bin_Pow(6,2))
end
def test_quick_sort
  g=[3,6,1,4,2,5]
  gt=[1,2,3,4,5,6]
  assert_equal(gt, quick_sort(g,0,5))
end
end
