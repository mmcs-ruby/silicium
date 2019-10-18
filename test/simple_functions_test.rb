require "test_helper"
require "silicium"
class SiliciumTest < Minitest::Test
  def test_reLu
    assert_equal 0, ::Silicium::reLu(-1)
  end
  end
