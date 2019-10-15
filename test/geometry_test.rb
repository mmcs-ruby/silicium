require "test_helper"
require "geometry"

class GeometryTest < Minitest::Test
  include Silicium

  def test_that_it_has_a_version_number
    refute_nil ::Silicium::VERSION
  end

  def test_one_point_hull
    assert_equal([Geometry::Point.new(1, 1)],
                 Geometry.minimal_convex_hull_2d([Geometry::Point.new(1, 1)]))
  end

  def test_two_points_hull
    assert_equal([Geometry::Point.new(1, 1), Geometry::Point.new(6, 2)],
                 Geometry.minimal_convex_hull_2d([Geometry::Point.new(1, 1), Geometry::Point.new(6, 2)]))
  end
end

