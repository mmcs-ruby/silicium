require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "silicium"

require "silicium/sparse"

require "numerical_integration"

require "minitest/autorun"

class Minitest::Test
  def assert_equal_as_sets(expected, actual)
    assert_equal expected.size, actual.size
    expected.each do |elem|
      assert_includes actual, elem
    end
  end

  def assert_equal_arrays(expected, actual)
    expected.zip(actual).each {|x, y| assert_equal x, y  }
  end

  def assert_equal_arrays_in_delta(expected, actual, delta)
    expected.zip(actual).each {|x, y| assert_in_delta x, y, delta}
  end
end