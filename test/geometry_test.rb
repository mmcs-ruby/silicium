
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


  def test_directing_vector3d1
    assert_equal([2.0, 1.0, 2.0],directing_vector3d('(x-3)/2=(y-1)/1=(z+1)/2'))
  end

  def test_directing_vector3d
    assert_equal([5.0, 3.0, 2.0],directing_vector3d('(x-5)/5=(y+15)/3=(z-20)/2'))
    assert_equal( [26.0, -15.0, 51.0],directing_vector3d('(x-0)/26=(y+300)/*(-15)=(z-200)/51'))
    assert_equal([0.0, 0.0, 1.0],directing_vector3d('(x-0)/0=(y-0)/0=(z-20)/1'))
    assert_equal([0.0,0.0,1.0],directing_vector3d('(z-20)/1'))
  end

  def test_point_on_the_line3d
    assert_equal([3.0, 1.0, -1.0],point_on_the_line3d('(x-3)/2=(y-1)/1=(z+1)/2'))
    assert_equal([5.0, -15.0, 20.0],point_on_the_line3d('(x-5)/5=(y+15)/3=(z-20)/2'))
    assert_equal( [0.0, -300.0, 200.0],point_on_the_line3d('(x-0)/26=(y+300)/*(-15)=(z-200)/51'))
    assert_equal([0.0, 0.0, 20.0],point_on_the_line3d('(x-0)/0=(y-0)/0=(z-20)/1'))
    assert_equal([0.0,0.0,20.0],point_on_the_line3d('(z-20)/1'))
    assert_equal([0.0, 0.0, 20.0],point_on_the_line3d('x/0=y/0=(z-20)/1'))
  end

  def test_distance_point_to_line3d
    assert_in_delta(5,distance_point_to_line3d(Point3d.new(0,2,3),'(x-3)/2=(y-1)/1=(z+1)/2'),0.00001)
    assert_in_delta(22.2036033,distance_point_to_line3d(Point3d.new(1,-17,-5),'(x-5)/5=(y+15)/3=(z-20)/2'),0.00001)
    assert_in_delta(256.782523588213,distance_point_to_line3d(Point3d.new(-50,20,-50),'(x-0)/26=(y+300)/*(-15)=(z-200)/51'),0.00001)
    assert_in_delta(0,distance_point_to_line3d(Point3d.new(0,0,2),'(x-0)/0=(y-0)/0=(z-20)/1'),0.000001)
    assert_in_delta(0,distance_point_to_line3d(Point3d.new(0,0,2),'(z-20)/1'),0.00001)
    assert_in_delta(0,distance_point_to_line3d(Point3d.new(0,0,2),'y-/0=(z-20)/1'),0.0000001)
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

  def test_init_line2d_with_same_points
    assert_raises ArgumentError  do
      Line2dCanon.new(Point.new(0,0),Point.new(0,0))
    end
  end

  def test_init_line2d_with_same_x_arguments
    assert_raises ArgumentError  do
      Line2dCanon.new(Point.new(0,5),Point.new(0,10))
    end
  end

  def test_init_slope_line2d_with_points_simple
    assert_equal(0,Line2dCanon.new(Point.new(0,0),Point.new(1,0)).slope)
  end

  def test_init_free_term_line2d_with_points_simple
    assert_equal(0,Line2dCanon.new(Point.new(0,0),Point.new(1,0)).free_term)
  end

  def test_init_slope_line2d_with_points_hard
    assert_in_delta(0.333333333,Line2dCanon.new(Point.new(0,3),Point.new(3,4)).slope,0.0001)
  end

  def test_init_free_term_line2d_with_points_hard
    assert_in_delta(1.333333333,Line2dCanon.new(Point.new(2,2),Point.new(5,3)).free_term,0.0001)
  end

  def test_method_pointis_on_line_returns_true_simple
    assert_equal(true, Line2dCanon.new(Point.new(0,0),Point.new(1,0)).point_is_on_line?(Point.new(500,0)))
  end

  def test_method_pointis_on_line_returns_false_simple
    assert_equal(false, Line2dCanon.new(Point.new(0,0),Point.new(1,0)).point_is_on_line?(Point.new(1,1)))
  end

  # Closest pair of points_______________________________

  def test_find_min_dist_simple
    assert_equal(1, find_min_dist([Point.new(1,1), Point.new(2,1), Point.new(3,2)]))
  end

  def test_find_min_dist_simple
    assert_in_delta(241.00095342953614, find_min_dist([Point.new(127, 591), Point.new(-503, -202), Point.new(5, 50)]), 0.0001)
  end
end

