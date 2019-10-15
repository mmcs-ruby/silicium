# frozen_string_literal: true

module Silicium

  class Geometry

    Point = Struct.new(:x, :y)

    def oriented_area(a, b, c)
      a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)
    end

    def clockwise(a, b, c)
      oriented_area(a, b, c).negative?
    end

    def counter_clockwise(a, b, c)
      oriented_area(a, b, c).positive?
    end

    def self.minimal_convex_hull_2d(points)
      return points if points.empty? || points.size == 1

      points.sort_by! { |p| [p.x, p.y] }
      p1 = points[0], p2 = points.last
      up = [p1], down = [p1]

      (1..points.size).each do |i|
        if i == points.size - 1 || clockwise(p1, points[i], p2)
          while up.size >= 2 && !clockwise(up[up.size - 2], up[up.size - 1], points[i])
            up.pop
          end
          up.push(points[i])
        end

        if i == points.size - 1 || counter_clockwise(p1, points[i], p2)
          while down.size >= 2 && !counter_clockwise(down[down.size - 2], down[down.size - 1], points[i])
            down.pop
          end
          down.push(points[i])
        end
      end

      hull = []
      (0..up.size).each do |i|
        hull.push(points[i])
      end
      ((down.size - 2)..0).each do |i|
        hull.push(points[i])
      end

    end
  end
end