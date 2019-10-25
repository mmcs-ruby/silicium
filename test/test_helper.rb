require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "silicium"
require "numerical_integration"

require "minitest/autorun"

class Minitest::Test
  def assert_equal_as_sets(expected, actual)
    assert_equal expected.size, actual.size
    expected.each do |elem|
      assert_includes actual, elem
    end
  end
end