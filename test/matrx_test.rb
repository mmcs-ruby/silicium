require "test_helper"

include Silicium
class SiliciumMatrixTest < Minitest::Test

  def test_init
    
    m = Matrix.new(2, 4)
    m.set(1, 1, 5.5)

    assert_equal 5.5, m.get(1, 1) 

  end
    
end