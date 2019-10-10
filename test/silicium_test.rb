require "test_helper"

class SiliciumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Silicium::VERSION
  end

  def test_it_will_fall
    assert false
  end
end
