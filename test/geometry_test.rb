require 'test_helper'
require 'geometry'

class GeometryTest < Minitest::Test
  include Silicium::Geometry

  def test_oriented_area
    assert_equal(-12, oriented_area(Point.new(-2, -1), Point.new(1, 2), Point.new(2, -1)))
  end

  def test_one_point_hull
    assert_equal([Point.new(1, 1)],
                 minimal_convex_hull_2d([Point.new(1, 1)]))
  end

  def test_four_points_hull
    assert_equal_as_sets([Point.new(-2, -1), Point.new(1, 2), Point.new(2, -1)],
                         minimal_convex_hull_2d([Point.new(0, 0), Point.new(-2, -1),
                                                 Point.new(1, 2), Point.new(2, -1)]))
  end

  def test_general
    assert_equal_as_sets([Point.new(-2, -1), Point.new(-1, 1),
                          Point.new(1, -2), Point.new(2, 0), Point.new(2, 2)],
                         minimal_convex_hull_2d([Point.new(-2, -1),
                                                 Point.new(0, -1), Point.new(-1, 0),
                                                 Point.new(-1, 1), Point.new(2, 2),
                                                 Point.new(1, -2), Point.new(2, 0),
                                                 Point.new(1, 1)]))
  end
end

