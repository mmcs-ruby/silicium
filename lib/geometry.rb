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
    # Class represents a line as equation y = k*x +b
    # k - slope
    # b - free_term
    # in two-dimensional space
    class Line2dCanon
      attr_reader :slope
      attr_reader :free_term
      def initialize(p1, p2)
        if (p1.x == p2.x) && (p1.y == p2.y)
          raise ArgumentError, "You need 2 diffrent points"
        end
        if (p1.x == p2.x)
          raise ArgumentError, "The straight line equation cannot be written in canonical form"
        end
        @slope= (p2.y - p1.y)/(p2.x - p1.x).to_f
        @free_term= (p2.x*p1.y - p2.y*p1.x)/(p2.x - p1.x).to_f
      end
      ##
      # Checks the point lies on the line or not
      def point_is_on_line?(p1)
        p1.y==@slope*p1.x + @free_term
      end
    end


    ##
    # Calculates the distance from given points in two-dimensional space
    def distance_point_to_point2d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2)
    end

    ##
    # Calculates the distance from given points in three-dimensional space
    def distance_point_to_point3d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2+(b.z-a.z)**2)
    end

    def distance_line_to_point2d(p1, p2, a)

      dis = distance_point_to_point2d(p1, p2)
      ((p2.y - p1.y) * a.x - (p2.x - p1.x) * a.y + p2.x * p1.y - p2.y * p1.x).abs / (dis * 1.0)
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

    ##
    # Creates an array- directing vector in three-dimensional space .
    # The equation is specified in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    #Important: mandatory order of variables: x, y, z
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

    ##
    # Creates an array of coordinates of the point ([x, y, z] on the line
    # given by the equation in the canonical form.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    #Important: mandatory order of variables: x, y, z
    def point_on_the_line3d(c)
      c2=c.gsub(' ','').insert(c.length,'=')
      m=Array.new() #line has point

      if c2.include?('x')
        before=c2.index('x')+1
        after=c2.index('/')
        m[0]=c2.slice(before..after).gsub('/','').to_f*(-1)
        c2=c2.slice(c2.index('='),c2.length).sub('=','')
      else m[0]=0.0
      end
      if c2.include?('y')
        before=c2.index('y')+1
        after=c2.index('/')
        m[1]=c2.slice(before..after).gsub('/','').to_f*(-1)
        c2=c2.slice(c2.index('='),c2.length).sub('=','')
      else m[1]=0.0
      end
      if c2.include?('z')
        before=c2.index('z')+1
        after=c2.index('/')
        m[2]=c2.slice(before..after).gsub('/','').to_f*(-1)
        c2=c2.slice(c2.index('='),c2.length).sub('=','')
      else m[2]=0.0
      end
      return m
    end

    ##
    # Calculates the distance from a point given by a Point3d structure
    # to a straight line given by a canonical equation.
    # Example, (x-0) / 26 = (y + 300) / * (- 15) = (z-200) / 51
    #
    #Important: mandatory order of variables: x, y, z
    def distance_point_to_line3d(a,c)
      s=directing_vector3d(c)
      m=point_on_the_line3d(c)
      ma=Point3d.new(m[0]-a.x,m[1]-a.y,m[2]-a.z)

      #Vector product of vectors.
      sm=Array.new()
      for i in 0..2
        sm[i]=ma[(i+1)%3]*s[(i+2)%3]-ma[(i+2)%3]*s[(i+1)%3]
      end
      return (Math.sqrt(sm[0]**2+sm[1]**2+sm[2]**2)/Math.sqrt(s[0]**2+s[1]**2+s[2]**2))
    end

    # Closest pair of points_________________________

    #sort according to x value
    def cmp_x(a,b)
      a.x < b.x
    end

    #sort according to y value
    def cmp_y(a,b)
      a.y < b.y
    end

    # find minimum distance between two points in set
    def find_min_dist(points, n)
      min = 999
      points.each { |i|
        if (distance_point_to_point2d(points[i], points[i + 1])) < min
          min = distance_point_to_point2d(points[i], points[i + 1])
        end
      }
      return min
    end
  end
end
