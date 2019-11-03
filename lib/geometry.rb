# frozen_string_literal: true

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
    #Calculates the distance from given points in two-dimensional space
    def distance_point_to_point2d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2)
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
        if point1.x.equal?(point2.x) && point1.y.equal?(point2.y)
          raise ArgumentError, "You need 2 different points"
        end

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

      ##
      # Checks the point lies on the line or not
      def point_is_on_line?(point)
        (@x_coefficient * point.x + @y_coefficient * point.y + @free_coefficient).equal?(0)
      end

      ##
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
        (@free_coefficient - other_line.free_coefficient).abs / Math.sqrt(@x_coefficient ** 2 + @y_coefficient ** 2)
      end
    end


    ##
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2 + (b.z - a.z)**2)
    end

    ##
    # The distance from a point to a line on a plane
    # The line is defined by two points
    # https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
    def distance_point_line2d(p1, p2, a)
      line_segment_length = distance_point_to_point2d(p1, p2)
      ((p2.y - p1.y) * a.x - (p2.x - p1.x) * a.y + p2.x * p1.y - p2.y * p1.x).abs / (line_segment_length * 1.0)
    end
    
    ##
    # The distance from a point to a line on a plane
    # Line defined by an equation
    # return 0 if the equation does not define a line.
    def distance_point_line_equation2d(a, b, c, p)
      if a == 0 and b == 0
        return 0
      end
      (a * p.x + b * p.y + c).abs / Math.sqrt(a**2 + b**2)
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
      while part.size >= 2 && !direction.call(part[part.size - 2], part[part.size - 1], point)
        part.pop
      end
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
        if is_last || clockwise(first, point, last)
          put_point_in_part(up, point, :clockwise)
        end
        if is_last || counter_clockwise(first, point, last)
          put_point_in_part(down, point, :counter_clockwise)
        end
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

    class VariablesOrderException < Exception
    end

    def needed_variables_order?(before, after)
      before < after
    end

    def process_free_member(line_equation, variable)
      if line_equation.include?(variable)
        before = line_equation.index(variable) + 1
        after = line_equation.index('/')

        unless needed_variables_order?(before, after)
          throw VariablesOrderException
        end

        line_equation.slice(before..after).gsub('/', '').to_f * (-1)
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

    def insert_eq(line_equation)
      line_equation.gsub(' ', '').insert(line_equation.length, '=')
    end
  end
end
