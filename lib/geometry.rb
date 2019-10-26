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
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a, b)
      Math.sqrt((b.x - a.x)**2 + (b.y - a.y)**2 + (b.z - a.z)**2)
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

    ##
    # Returns an array containing points that are included
    # in the minimal convex hull for a given array of points
    # https://e-maxx.ru/algo/convex_hull_graham
    def minimal_convex_hull_2d(points)
      return points if points.empty? || points.size == 1 || points.size == 2

      points.sort_by! { |p| [p.x, p.y] }
      p1 = points[0]
      p2 = points.last
      up = [p1]
      down = [p1]

      (1...points.size).each do |i|
        point = points[i]
        if i == points.size - 1 || clockwise(p1, point, p2)
          while up.size >= 2 && !clockwise(up[up.size - 2], up[up.size - 1], point)
            up.pop
          end
          up.push(point)
        end

        if i == points.size - 1 || counter_clockwise(p1, point, p2)
          while down.size >= 2 && !counter_clockwise(down[down.size - 2], down[down.size - 1], point)
            down.pop
          end
          down.push(point)
        end
      end
      hull = []
      (0...up.size).each do |j|
        hull.push(up[j])
      end
      (1..(down.size - 2)).reverse_each do |j|
        hull.push(down[j])
      end
      hull
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

    ##
    # Creates an array- directing vector in three-dimensional space .
    # The equation is specified in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    # Important: mandatory order of variables: x, y, z
    def directing_vector3d(line_equation)
      copy_line = line_equation.gsub(' ', '').insert(line_equation.length, '=')
      res = []
      res[0] = process_cf(copy_line, 'x')
      copy_line = cut_by_eq(copy_line)
      res[1] = process_cf(copy_line, 'y')
      copy_line = cut_by_eq(copy_line)
      res[2] = process_cf(copy_line, 'z')
      res
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
      copy_line = line_equation.gsub(' ', '').insert(line_equation.length, '=')
      res = []

      res[0] = process_free_member(copy_line, 'x')
      copy_line = cut_by_eq(copy_line)
      res[1] = process_free_member(copy_line, 'y')
      copy_line = cut_by_eq(copy_line)
      res[2] = process_free_member(copy_line, 'z')
      res
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
      vector_length(height_on_dir) /
          vector_length(dir_vector)
    end
  end
end
