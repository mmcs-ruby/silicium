module Silicium

  module Geometry
    class Figure
      include Geometry
    end

    class Triangle < Figure

      def initialize(p1, p2, p3)
        s_p1p2 = distance_point_to_point2d(p1, p2)
        s_p1p3 = distance_point_to_point2d(p1, p3)
        s_p2p3 = distance_point_to_point2d(p2, p3)
        if s_p1p2 + s_p2p3 <= s_p1p3 || s_p1p2 + s_p1p3 <= s_p2p3 || s_p2p3 + s_p1p3 <= s_p1p2
          raise ArgumentError, 'Triangle does not exist'
        else
          @side_p1p2 = s_p1p2
          @side_p1p3 = s_p1p3
          @side_p2p3 = s_p2p3
        end
      end

      def perimeter
        @side_p1p2 + @side_p1p3 + @side_p2p3
      end

      def area
        half_perimeter = perimeter / 2.0
        Math.sqrt(half_perimeter * (half_perimeter - @side_p1p2) * (half_perimeter - @side_p2p3) * (half_perimeter - @side_p1p3))
      end
    end


##
# TODO: Add a description
    class Rectangle < Figure

      def initialize(p1, p2, p3, p4)
        unless valid?(p1, p2, p3, p4)
          raise ArgumentError, 'This is not a rectangle.'
        end
        @side1 = distance_point_to_point2d(p1, p2)
        @side2 = distance_point_to_point2d(p2, p3)
        @side3 = distance_point_to_point2d(p3, p4)
        @side4 = distance_point_to_point2d(p4, p1)
      end

      ##
      # Checks if input points form rectangle
      def valid?(p1, p2, p3, p4)
        distance_point_to_point2d(p1, p3) == distance_point_to_point2d(p2, p4)
      end

      def perimeter
        @side1 + @side2 + @side3 + @side4
      end

      def area
        @side1 * @side2
      end
    end
  end
end