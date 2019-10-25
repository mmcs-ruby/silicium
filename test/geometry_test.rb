
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

  def test_distance_point_to_point2d
    assert_equal(1,distance_point_to_point2d(Point.new(1,1),Point.new(0,1)))
    assert_in_delta(7.071067811865,distance_point_to_point2d(Point.new(3,1),Point.new(-4,2)),0.000001)
    assert_in_delta(11.045361017187261,distance_point_to_point2d(Point.new(11,32),Point.new(0,33)),0.0001)
  end

  def test_distance_point_to_point3d
    assert_equal(9,distance_point_to_point3d(Point3d.new(1,2,3),Point3d.new(-7,-2,4)))
    assert_in_delta(8.602325267042627,
                    distance_point_to_point3d(Point3d.new(11,13,-4),Point3d.new(8,20,0)),0.000001)
    assert_in_delta(589.7694464788761,
                    distance_point_to_point3d(Point3d.new(-222,-333,-444),Point3d.new(-2,-5,-6)),0.0001)
  end

  def test_distance_line_to_point2d_simple
    assert_equal(0, distance_line_to_point2d(Point.new(0, 0), Point.new(2, 2), Point.new(0, 0)))
  end

  def test_distance_line_to_point2d_normal
    assert_in_delta(1.8343409898251712, distance_line_to_point2d(Point.new(-7, 3), Point.new(6, 11), Point.new(3, 7)), 0.0001)
  end

  def test_distance_line_to_point2d_big
    assert_in_delta(241.00095342953614, distance_line_to_point2d(Point.new(127, 591), Point.new(-503, -202), Point.new(5, 50)), 0.0001)
  end

end

