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


    end

  end
end

