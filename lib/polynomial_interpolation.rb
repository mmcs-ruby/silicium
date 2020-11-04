module Silicium
  module Algebra

    ##
    # A class providing polynomial interpolation methods
    class PolynomialInterpolation

      ##
      # x : array of data points
      # y : array returned by function
      # z : interpolation point
      def lagrange_polynomials(x, y, z)
        result = 0.0
        (0..range(length(y))-1).each do |i|
          p = 1.0
          (0..range(length(x))-1).each do |j|
            if i != j
              p *= (z - x[j]) / (x[i] - x[j])
            end
          end
          result = result + y[i] * p
        end
        result
      end


      
    end
  end
end

