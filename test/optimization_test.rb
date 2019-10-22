require "test_helper"
require 'optimization'


class SiliciumTest < Minitest::Test
  include Silicium::Optimization

  def test_reLu
    assert_equal 0, re_lu(-1)
  end
end
