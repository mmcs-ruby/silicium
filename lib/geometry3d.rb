# frozen_string_literal: true

require_relative 'geometry/figure'

module Silicium

  module Geometry3d
    ##
    # Represents a point as three coordinates
    # in three-dimensional space
    Point3d = Struct.new(:x, :y, :z)

    ##
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2 + (b.z - a.z)**2)
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
        check_p1 = @x_coefficient * point1.x + @y_coefficient * point1.y + @z_coefficient * point1.z +  @free_coefficient
        check_p2 = @x_coefficient * point2.x + @y_coefficient * point2.y + @z_coefficient * point2.z + @free_coefficient
        check_p3 = @x_coefficient * point3.x + @y_coefficient * point3.y + @z_coefficient * point3.z + @free_coefficient
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
      def help_check(vector2, x, y, z)
        check1 = x * sign(vector2.x) * sign(@x) == y * sign(vector2.y) * sign(@y)
        check2 = x * sign(vector2.x) * sign(@x) == z * sign(vector2.z) * sign(@z)
        check3 = z * sign(vector2.z) * sign(@z) == y * sign(vector2.y) * sign(@y)
        check1 && check2 && check3
      end
      ##
      # helps to divide correctly
      def helper(value1, value2)
        result = 0
        if value1 > value2
          result = value1 / value2
        else
          result = value2 / value1
        end
        result
      end

      #  Check if two vectors are collinear
      def collinear?(vector2)
        x1 = (vector2.x).abs
        y1 = (vector2.y).abs
        z1 = (vector2.z).abs
        x = helper(x1,@x.abs)
        y =  helper(y1,@y.abs)
        z =  helper(z1,@z.abs)
        help_check(vector2, x, y, z)
      end
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

    ##
    # Creates an array of coordinates of the point ([x, y, z] on the line
    # given by the equation in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    # Important: mandatory order of variables: x, y, z
    def height_point_3d(line_equation)
      process_line_by_coordinates(line_equation, :process_free_member)
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
  end
end