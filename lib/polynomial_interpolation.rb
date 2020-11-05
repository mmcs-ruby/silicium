module Silicium
  module Algebra

    ##
    # A class providing polynomial interpolation methods
    class PolynomialInterpolation

      ##
      # x : array of data points
      # y : array returned by function
      # z : interpolation point
      def self.lagrange_polynomials(x , y , z )
        check_variables(x, y, z)
        result = 0.0
        y.each_index do |j|
          p1 = 1.0
          p2 = 1.0
          x.each_index do |i|
            if i != j
              p1 = p1 * (z - x[i])
              p2 = p2 * (x[j] - x[i])
            end
          end
          result = result + y[j] * p1 / p2
        end
        result
      end

      ##
      # helper for lagrange_polynomials
      def self.check_variables(x, y, z)

        if x.class != Array || y.class != Array
          raise ArgumentError, 'Wrong type of variables x or y'
        end

        if x.empty? ||  y.empty?
          raise ArgumentError, 'Arrays are empty'
        end

        if x.size < 2  ||  x.size < 2
          raise ArgumentError, 'Arrays are too small'
        end

        if z.class.superclass != Numeric
          raise ArgumentError, 'Wrong type of variable z'
        end

        if x[0].class.superclass != Numeric || y[0].class.superclass != Numeric
          raise ArgumentError, 'Wrong type of arrays'
        end

      end

    end

  end
end

