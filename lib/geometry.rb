# frozen_string_literal: true

require_relative 'geometry/figure'

module Silicium

  module Geometry
    ##
    # Represents a point as two coordinates
    # in two-dimensional space
    Point = Struct.new(:x, :y)

    ##
    # Represents a point as three coordinates
    # in three-dimensional space
    Point3d = Struct.new(:x, :y, :z)


    ##
    # Calculates the distance from given points in two-dimensional space
    def distance_point_to_point2d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2)
    end

    ##
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2 + (b.z - a.z)**2)
    end

    ##
    # Class represents a line as equation Ax + By + C = 0
    # in two-dimensional space
    class Line2dCanon
      attr_reader :x_coefficient
      attr_reader :y_coefficient
      attr_reader :free_coefficient

      ##
      # Initializes with two objects of type Point
      def initialize(point1, point2)
        raise ArgumentError, 'You need 2 different points' if point1.x.equal?(point2.x) && point1.y.equal?(point2.y)
        if point1.x.equal?(point2.x)
          @x_coefficient = 1
          @y_coefficient = 0
          @free_coefficient = - point1.x
        else
          slope_point = (point2.y - point1.y) / (point2.x - point1.x)
          @x_coefficient = -slope_point
          @y_coefficient = 1
          @free_coefficient = - point1.y + slope_point * point1.x
        end
      end

      # Initializes with coefficients
      def initialize_with_coefficients(a, b, c)
        raise ArgumentError, 'All coefficients cannot be 0 ' if a.equal?(0) && b.equal?(0) && (c.equal?(0) || !c.equal?(0))

        @x_coefficient = a
        @y_coefficient = b
        @free_coefficient = c
      end

      ##
      # Checks the point lies on the line or not
      def point_is_on_line?(point)
        ((@x_coefficient * point.x + @y_coefficient * point.y + @free_coefficient) - 0.0).abs < 0.0001
      end

      # Checks if two lines are parallel
      def parallel?(other_line)
        @x_coefficient.equal?(other_line.x_coefficient) && @y_coefficient.equal?(other_line.y_coefficient)
      end

      ##
      # Checks if two lines are intersecting
      def intersecting?(other_line)
        @x_coefficient != other_line.x_coefficient || @y_coefficient != other_line.y_coefficient
      end

      ##
      # Checks if two lines are perpendicular
      def perpendicular?(other_line)
        (@x_coefficient * other_line.x_coefficient).equal?(- @y_coefficient * other_line.y_coefficient)
      end

      ##
      # Checking if the point is on a segment
      def check_point_on_segment(point)
        (@x_coefficient * point.x + @y_coefficient * point.y + @free_coefficient) - 0.0 <= 0.0001
      end

      ##
      # Returns a point of intersection of two lines
      # If not intersecting returns nil
      def intersection_point(other_line)
        return nil unless intersecting?(other_line)

        divisor = @x_coefficient * other_line.y_coefficient - other_line.x_coefficient * @y_coefficient
        x = (@y_coefficient * other_line.free_coefficient - other_line.y_coefficient * @free_coefficient) / divisor
        y = (@free_coefficient * other_line.x_coefficient - other_line.free_coefficient * @x_coefficient) / divisor
        Point.new(x, y)
      end

      ##
      # Returns distance between lines
      def distance_to_line(other_line)
        return 0 if intersecting?(other_line)

        (@free_coefficient - other_line.free_coefficient).abs / Math.sqrt(@x_coefficient**2 + @y_coefficient**2)
      end

      ##
      # The distance from a point to a line on a plane
      # return 0 if the equation does not define a line.
      def distance_point_to_line(point)
        return 0 if @x_coefficient.eql?(0) && @y_coefficient.eql?(0)

        res = (@x_coefficient * point.x + @y_coefficient * point.y + @free_coefficient).abs
        res / Math.sqrt(@x_coefficient**2 + @y_coefficient**2).to_f
      end
      ##
      # Check if array of points is on the same line
      def array_of_points_is_on_line(array)
        raise ArgumentError, 'Array is empty!' if array.length == 0
        res = Array.new
        for i in 0..array.size-1 do
          res.push(point_is_on_line?(array[i]))
        end
        res
      end

      ##
      # The distance between parallel lines
      def distance_between_parallel_lines(other_line)
        raise ArgumentError, 'Lines are not parallel' if !parallel?(other_line)

        (other_line.free_coefficient - @free_coefficient).abs / Math.sqrt(@x_coefficient**2 + @y_coefficient**2)
      end
    end
    ##
    # Class represents a plane as equation Ax + By + Cz+D = 0
    # in two-dimensional space
    class Plane3d
      attr_reader :x_coefficient
      attr_reader :y_coefficient
      attr_reader :z_coefficient
      attr_reader :free_coefficient

      # Initializes with three objects of type Point
      def initialize(point1, point2, point3)
        vector1 = Vector3d.new(point1)
        norm = vector1.norm_vector(point2, point3)
        @x_coefficient = norm.x
        @y_coefficient = norm.y
        @z_coefficient = norm.z
        @free_coefficient = -point1.x * norm.x + (-point1.y * norm.y) + (-point1.z * norm.z)
      end

      ##
      # Initializes with coefficients
      def initialize_with_coefficients(a, b, c, d)
        raise ArgumentError, 'All coefficients cannot be 0 ' if a.equal?(0) && b.equal?(0) && c.equal?(0) && (d.equal?(0) || !d.equal?(0))

        @x_coefficient = a
        @y_coefficient = b
        @z_coefficient = c
        @free_coefficient = d
      end

      ##
      # check if the points isn't on the same line
      def point_is_on_line?(point1, point2, point3)
        p = @free_coefficient
        check_p1 = @x_coefficient * point1.x + @y_coefficient * point1.y + @z_coefficient * point1.z +  @free_coefficient
        check_p2 = @x_coefficient * point2.x + @y_coefficient * point2.y + @z_coefficient * point2.z + @free_coefficient
        check_p3 = @x_coefficient * point3.x + @y_coefficient * point3.y + @z_coefficient * point3.z + @free_coefficient
        p = @free_coefficient
        check_p1.equal?(0) && check_p2.equal?(0) && check_p3.equal?(0)
      end

      # check if the point isn't on the plane
      def point_is_on_plane?(point)
        (@x_coefficient * point.x + @y_coefficient * point.y + @z_coefficient * point.z + @free_coefficient).equal?(0)
      end

      # Checks if two planes are parallel in 3-dimensional space
      def parallel?(other_plane)
        v1 = Vector3d.new(Point3d.new(@x_coefficient, @y_coefficient, @z_coefficient))
        v2 = Vector3d.new(Point3d.new(other_plane.x_coefficient, other_plane.y_coefficient, other_plane.z_coefficient))
        v1.collinear?(v2)
      end

      ##
      # Checks if two planes are intersecting in 3-dimensional space
      def intersecting?(other_plane)
        check_x = @x_coefficient != other_plane.x_coefficient
        check_y = @y_coefficient != other_plane.y_coefficient
        check_z = @z_coefficient != other_plane.z_coefficient
        check_x || check_y || check_z
      end

      ##
      # Checks if two planes are perpendicular
      def perpendicular?(other_plane)
        check_x = @x_coefficient * other_plane.x_coefficient
        check_y = @y_coefficient * other_plane.y_coefficient
        check_z = @z_coefficient * other_plane.z_coefficient
        (check_x + check_y + check_z).equal?(0)
      end

      ##
      # The distance between parallel planes
      def distance_between_parallel_planes(other_plane)
        raise 'Planes are not parallel' if !parallel?(other_plane)

        free = (other_plane.free_coefficient - @free_coefficient).abs
        free / sqrt(@x_coefficient**2 + @y_coefficient**2 + @z_coefficient**2)
      end

      ##
      # The distance from a point to a plane
      #
      def distance_point_to_plane(point)
        norm = 1 / Math.sqrt(@x_coefficient**2 + @y_coefficient**2 + @z_coefficient**2)
        (@x_coefficient * norm * point.x + @y_coefficient * norm * point.y +
            @z_coefficient * norm * point.z + @free_coefficient * norm).abs
      end
    end
    ##
    # Class represents vector
    # in three-dimensional space
    class Vector3d
      attr_reader :x
      attr_reader :y
      attr_reader :z

      ##
      # Initializes with one objects of type Point3d
      # 2nd point is (0,0,0)
      def initialize(point)
        @x = point.x
        @y = point.y
        @z = point.z
      end

      ##
      # Checks if vector is zero vector
      def zero_vector?
        (@x.eql?(0) && @y.eql?(0) && @z.eql?(0)).eql?(true) ? true : false
      end

      ##
      # Returns length of the vector
      def length
        Math.sqrt(@x**2 + @y**2 + @z**2)
      end

      ##
      # Add one vector to another
      def addition!(other_vector)
        @x += other_vector.x
        @y += other_vector.y
        @z += other_vector.z
      end

      ##
      # Sub one vector from another
      def subtraction!(other_vector)
        @x -= other_vector.x
        @y -= other_vector.y
        @z -= other_vector.z
      end

      ##
      # Mult vector by number
      def multiplication_by_number!(r)
        @x *= r
        @y *= r
        @z *= r
      end

      ##
      # Returns scalar multiplication of 2 vectors
      def scalar_multiplication(other_vector)
        x * other_vector.x + y * other_vector.y + z * other_vector.z
      end

      ##
      # Returns cos between two vectors
      def cos_between_vectors(other_vector)
        scalar_multiplication(other_vector) / (length * other_vector.length).to_f
      end

      ##
      # Returns vector multiplication of 2 vectors
      def vector_multiplication(other_vector)
        x = @y * other_vector.z - @z * other_vector.y
        y = @z * other_vector.x - @x * other_vector.z
        z = @x * other_vector.y - @y * other_vector.x
        Vector3d.new(Point3d.new(x, y, z))
      end

      ##
      # Find normal vector
      ##
      # vector mult
      def norm_vector(point2, point3)
        point1 = Point3d.new(@x, @y, @z)
        # checking if the points isn't on the same line
        # finding vector between points 1 and 2 ;1 and 3
        vector12 = Vector3d.new(Point3d.new(point2.x - point1.x, point2.y - point1.y, point2.z - point1.z))
        vector13 = Vector3d.new(Point3d.new(point3.x - point1.x, point3.y - point1.y, point3.z - point1.z))
        # vector13=vector1.scalar_multiplication(vector3)
        x = vector12.y * vector13.z - vector12.z * vector13.y
        y = -(vector12.x * vector13.z - vector12.z * vector13.x)
        z = vector12.x * vector13.y - vector12.y * vector13.x
        Vector3d.new(Point3d.new(x, y, z))
      end

      ##
      # Function for checking sign of number
      def sign(integer)
        integer >= 0 ? 1 : -1
      end

      ##
      # help function for collinear function
      def help_collinear(vector2)
        x1 = vector2.x.abs
        y1 = vector2.y.abs
        z1 = vector2.z.abs
        d1 = x1 / @x.abs
        d2 = y1 / @y.abs
        d3 = z1 / @z.abs

        x = x1 > @x.abs ? d1 : (1.0 / d1)
        y =  y1 > @y.abs ? d2 : (1.0 / d2)
        z =  z1 > @z.abs ? d3 : (1.0 / d3)
        arr = [x,y,z]
      end

      ##
      #  Check if two vectors are collinear
      def collinear?(vector2)
        arr = help_collinear(vector2)
        x = arr[0]
        y = arr[1]
        z = arr[2]
        check_x = x * sign(vector2.x) * sign(@x)
        check_y = y * sign(vector2.y) * sign(@y)
        check_z = z * sign(vector2.z) * sign(@z)
        check1 = check_x == check_y
        check2 = check_x == check_z
        check_3 = check_y == check_z
        check1 && check2 && check_3
      end
    end
     ##
    # Function for checking sign of number
    def sign(integer)
      integer >= 0 ? 1 : -1
    end
    # The distance from a point to a line on a plane
    # The line is defined by two points
    # https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
    def distance_point_line2d(p1, p2, a)
      line_segment_length = distance_point_to_point2d(p1, p2)
      ((p2.y - p1.y) * a.x - (p2.x - p1.x) * a.y + p2.x * p1.y - p2.y * p1.x).abs / (line_segment_length * 1.0)
    end

    ##
    # The distance from a point to a line on a plane
    # Normalized equation of the line
    def distance_point_line_normalized2d(a, b, c, p)
      (p.x * a + p.y * b - c).abs
    end

    def oriented_area(a, b, c)
      a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)
    end

    ##
    # Determines if a clockwise crawl is performed
    # for defined order of points
    def clockwise(a, b, c)
      oriented_area(a, b, c).negative?
    end

    ##
    # Determines if a counter-clockwise crawl is
    # performed for defined order of points
    def counter_clockwise(a, b, c)
      oriented_area(a, b, c).positive?
    end

    def not_polygon?(points)
      points.empty? || points.size == 1 || points.size == 2
    end

    def put_point_in_part(part, point, direction)
      direction = method(direction)
      part.pop while part.size >= 2 && !direction.call(part[part.size - 2], part[part.size - 1], point)
      part.push(point)
    end

    ##
    # Returns an array containing points that are included
    # in the minimal convex hull for a given array of points
    # https://e-maxx.ru/algo/convex_hull_graham
    def minimal_convex_hull_2d(points)
      return points if not_polygon?(points)

      points.sort_by! { |p| [p.x, p.y] }
      first = points[0]
      last = points.last
      up = [first]
      down = [first]

      (1...points.size).each do |i|
        point = points[i]
        is_last = i == points.size - 1
        put_point_in_part(up, point, :clockwise) if is_last || clockwise(first, point, last)
        put_point_in_part(down, point, :counter_clockwise) if is_last || counter_clockwise(first, point, last)
      end
      up + down[1...-1]
    end

    def process_cf(line_equation, variable)
      if line_equation.include?(variable)
        before = line_equation.index('/') + 1
        after = line_equation.index('=')
        line_equation.slice(before..after).gsub('=', '').sub('*', '').gsub('(', '').gsub(')', '').to_f
      else
        0.0
      end
    end

    def cut_by_eq(line_equation)
      line_equation.slice(line_equation.index('='), line_equation.length).sub('=', '')
    end

    def process_line_by_coordinates(line_equation, func)
      copy_line = insert_eq(line_equation)
      func = method(func)
      res = []
      res[0] = func.call(copy_line, 'x')
      copy_line = cut_by_eq(copy_line)
      res[1] = func.call(copy_line, 'y')
      copy_line = cut_by_eq(copy_line)
      res[2] = func.call(copy_line, 'z')
      res
    end

    ##
    # Creates an array- directing vector in three-dimensional space .
    # The equation is specified in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    # Important: mandatory order of variables: x, y, z
    def directing_vector3d(line_equation)
      process_line_by_coordinates(line_equation, :process_cf)
    end

    class VariablesOrderException < RuntimeError
    end

    def needed_variables_order?(before, after)
      before < after
    end

    def process_free_member(line_equation, variable)
      if line_equation.include?(variable)
        before = line_equation.index(variable) + 1
        after = line_equation.index('/')

        throw VariablesOrderException unless needed_variables_order?(before, after)

        line_equation.slice(before..after).gsub('/', '').to_f * -1
      else
        0.0
      end
    end

    ##
    # Creates an array of coordinates of the point ([x, y, z] on the line
    # given by the equation in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    # Important: mandatory order of variables: x, y, z
    def height_point_3d(line_equation)
      process_line_by_coordinates(line_equation, :process_free_member)
    end

    def vectors_product(v1, v2)
      res = Array.new(3)
      (0..2).each do |i|
        res[i] = v1[(i + 1) % 3] * v2[(i + 2) % 3] - v1[(i + 2) % 3] * v2[(i + 1) % 3]
      end
      res
    end

    def vector_length(vector)
      Math.sqrt(vector[0]**2 + vector[1]**2 + vector[2]**2)
    end

      ##
      # Calculates the distance from a point given by a Point3d structure
      # to a straight line given by a canonical equation.
      # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
      #
      # Important: mandatory order of variables: x, y, z
      def point_to_line_distance_3d(point, line_eq)
        dir_vector = directing_vector3d(line_eq)
        line_point = height_point_3d(line_eq)
        height_vector = [line_point[0] - point.x, line_point[1] - point.y, line_point[2] - point.z]

        height_on_dir = vectors_product(height_vector, dir_vector)
        vector_length(height_on_dir) / vector_length(dir_vector)
      end

      # Closest pair of points_________________________
      # find minimum distance between two points in set
      def brute_min(points, current = Float::INFINITY)
        return current  if points.length < 2

        head = points[0]
        points.delete_at(0)
        new_min = points.map { |x| distance_point_to_point2d(head, x)}.min
        new_сurrent = [new_min, current].min
        brute_min(points, new_сurrent)
      end

      def divide_min(points)
        half = points.length / 2
        points.sort_by! { |p| [p.x, p.y] }
        minimum = [brute_min(points[0..half]), brute_min(points[half..points.length])].min
        near_line = points.select { |x| x > half - minimum and x < half + minimum}
        min([brute_min(near_line), minimum])
      end

      def insert_eq(line_equation)
        line_equation.gsub(' ', '').insert(line_equation.length, '=')
      end
  end
end


