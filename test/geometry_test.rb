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
    assert_equal(1, distance_point_to_point2d(Point.new(1, 1), Point.new(0, 1)))
    assert_in_delta(7.071067811865, distance_point_to_point2d(Point.new(3, 1), Point.new(-4, 2)), 0.000001)
    assert_in_delta(11.045361017187261, distance_point_to_point2d(Point.new(11, 32), Point.new(0, 33)), 0.0001)
  end

  def test_distance_point_to_point3d
    assert_equal(9, distance_point_to_point3d(Point3d.new(1, 2, 3), Point3d.new(-7, -2, 4)))
    assert_in_delta(8.602325267042627,
                    distance_point_to_point3d(Point3d.new(11, 13, -4), Point3d.new(8, 20, 0)), 0.000001)
    assert_in_delta(589.7694464788761,
                    distance_point_to_point3d(Point3d.new(-222, -333, -444), Point3d.new(-2, -5, -6)), 0.0001)
  end


  def test_directing_vector3d1
    assert_equal([2.0, 1.0, 2.0], directing_vector3d('(x-3)/2=(y-1)/1=(z+1)/2'))
  end

  def test_directing_vector3d
    assert_equal([5.0, 3.0, 2.0], directing_vector3d('(x-5)/5=(y+15)/3=(z-20)/2'))
    assert_equal([26.0, -15.0, 51.0], directing_vector3d('(x-0)/26=(y+300)/*(-15)=(z-200)/51'))
    assert_equal([234.0, 4.0, 0.0], directing_vector3d('(x-30)/234=(y-56)/4'))
  end

  def test_point_on_the_line3d
    assert_equal([3.0, 1.0, -1.0], height_point_3d('(x-3)/2=(y-1)/1=(z+1)/2'))
    assert_equal([5.0, -15.0, 20.0], height_point_3d('(x-5)/5=(y+15)/3=(z-20)/2'))
    assert_equal([0.0, -300.0, 200.0], height_point_3d('(x-0)/26=(y+300)/*(-15)=(z-200)/51'))
  end

  def test_distance_point_to_line3d
    assert_in_delta(5, point_to_line_distance_3d(Point3d.new(0, 2, 3), '(x-3)/2=(y-1)/1=(z+1)/2'), 0.00001)
    assert_in_delta(22.2036033, point_to_line_distance_3d(Point3d.new(1, -17, -5), '(x-5)/5=(y+15)/3=(z-20)/2'), 0.00001)
    assert_in_delta(256.782523588213, point_to_line_distance_3d(Point3d.new(-50, 20, -50), '(x-0)/26=(y+300)/*(-15)=(z-200)/51'), 0.00001)
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

  def test_process_cf
    assert_equal(3, process_cf('x/3', 'x'))
    assert_equal(3, process_cf('y-3/3', 'y'))
    assert_equal(3, process_cf('(z-500)/3', 'z'))
  end

  def test_process_cf_zero
    assert_equal(0, process_cf('y/3', 'x'))
  end

  def test_cut_by_eq
    assert_equal('123hello', cut_by_eq('qqqqq=123hello'))
  end


  def test_directing_vector3d_exception
    directing_vector3d('z/34=(y-5)/2')
  rescue Exception => ex
    assert_equal(VariablesOrderException, ex.class)
  end


  def test_needed_variables_order?
    assert_equal(true, needed_variables_order?(3, 6))
    assert_equal(false, needed_variables_order?(6, 6))
    assert_equal(false, needed_variables_order?(10, 6))
  end

  def test_process_free_member
    assert_equal(3, process_free_member('(x-3)/32', 'x'))
    assert_equal(4, process_free_member('(y-4)/12', 'y'))
    assert_equal(-4, process_free_member('(z+4)/3', 'z'))
    assert_equal(0.0, process_free_member('y/3', 'z'))
  end


  def test_height_point_3d
    assert_equal([3, 1, -1], height_point_3d('(x-3)/2=(y-1)/1=(z+1)/2'))
    assert_equal([3, 1, 0], height_point_3d('(x-3)/2=(y-1)/1'))
  end


  def test_height_point_3d_exception
    height_point_3d('z/34=(y-5)/2')
  rescue Exception => ex
    assert_equal(VariablesOrderException, ex.class)
  end


  def test_vectors_product
    assert_equal([2, -14, 5], vectors_product([3, -1, -4], [2, 1, 2]))
  end

  def test_vector_length
    assert_in_delta(5.385164807, vector_length([2, 3, -4]), 0.00001)
  end


  def test_distance_point_to_line3d_exception
    point_to_line_distance_3d(Point3d.new(0, 2, 3), 'z/34=(y-5)/2')
  rescue Exception => ex
    assert_equal(VariablesOrderException, ex.class)
  end

end

