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
    Point3d = Struct.new(:x,:y,:z)

    ##
    #Calculates the distance from given points in two-dimensional space
    def distance_point_to_point2d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2)
    end

    ##
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2+(b.z-a.z)**2)
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
        puts j
        hull.push(down[j])
      end
      hull
    end

    ##
    # Creates an array- directing vector in three-dimensional space .
    # The equation is specified in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    def directing_vector3d(c)
      c=c.gsub(' ','')
      c1=c.insert(c.length,'=')
      res=Array.new()
      if c1.include?('x')
        before=c1.index('/')+1
        after=c1.index('=')
        res[0]=c1.slice(before..after).gsub('=','').sub('*','').gsub('(','').gsub(')','').to_f
        c1=c1.slice(after,c1.length).sub('=','')
      else res[0]=0.0 end
      if c1.include?('y')
        before=c1.index('/')+1
        after=c1.index('=')
        res[1]=c1.slice(before..after).gsub('=','').sub('*','').gsub('(','').gsub(')','').to_f
        c1=c1.slice(after,c1.length).sub('=','')
      else res[1]=0.0 end
      if c1.include?('z')
        before=c1.index('/')+1
        after=c1.index('=')
        res[2]=c1.slice(before..after).gsub('=','').sub('*','').gsub('(','').gsub(')','').to_f
        c1=c1.slice(after,c1.length).sub('=','')
      else res[1]=0.0 end
      return res
    end


  end
end
