require "test_helper"
require "geometry"

class GeometryTest < Minitest::Test
  include Silicium

  def test_that_it_has_a_version_number
    refute_nil ::Silicium::VERSION
  end

  def test_distance_point_to_point3d
    assert_equal(9,Geometry.distance_point_to_point3d(Geometry::Point3d.new(1,2,3),Geometry::Point3d.new(-7,-2,4)))
    assert_in_delta(8.602325267042627,
                    Geometry.distance_point_to_point3d(Geometry::Point3d.new(11,13,-4),Geometry::Point3d.new(8,20,0)),0.000001)
    assert_in_delta(589.7694464788761,
                    Geometry.distance_point_to_point3d(Geometry::Point3d.new(-222,-333,-444),Geometry::Point3d.new(-2,-5,-6)),0.0001)
  end

  def test_distance_point_to_point2d
    assert_equal(1,Geometry.distance_point_to_point2d(Geometry::Point.new(1,1),Geometry::Point.new(0,1)))
    assert_in_delta(7.071067811865,Geometry.distance_point_to_point2d(Geometry::Point.new(3,1),Geometry::Point.new(-4,2)),0.000001)
    assert_in_delta(11.045361017187261,Geometry.distance_point_to_point2d(Geometry::Point.new(11,32),Geometry::Point.new(0,33)),0.0001)
  end

  def test_distance_point_to_line2d

  end
end

