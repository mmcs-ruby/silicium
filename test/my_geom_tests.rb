require 'test_helper'
require 'my_geom'

class GeometryTest < Minitest::Test
  include Silicium::Geometry

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

  def test_compare_X

  end

  def test_compare_Y

  end




end