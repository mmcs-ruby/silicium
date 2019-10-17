# frozen_string_literal: true

module Silicium

  class Geometry

    Point = Struct.new(:x, :y)
    Point3d = Struct.new(:x,:y,:z)

    def self.distance_point_to_point2d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2)
    end

    def self.distance_point_to_point3d(a,b)
      Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2+(b.z-a.z)**2)
    end

  end
end
