# frozen_string_literal: true

require_relative 'geometry/figure'

module Silicium

  module Geometry
    ##
    # Represents a point as two coordinates
    # in two-dimensional space
    Point = Struct.new(:x, :y)

    ##
    # Calculates the distance from given points in two-dimensional space
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


