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


      # x : array of data points
      # y : array of f(x)
      # r : the node to interpolate at
      def self.newton_polynomials(x, y, r)
        check_variables(x, y, r)
        a = Array[]
        y.each do |elem|
          a << elem
        end
        for j in 1..x.length - 1
          i = x.length - 1
          while i != j - 1
            a[i] = (a[i] - a[i - 1]) / (x[i] - x[i - j])
            i -= 1
          end
        end

        n = a.length - 1
        res = a[n]
        i = n - 1
        while i != -1
          res = res * (r - x[i]) + a[i]
          i -= 1
        end
        res
      end


      # helper
      def self.check_variables(x, y, z)
        check_types(x, y, z)
        check_arrays(x, y)
      end

      #helper for helper
      def self.check_arrays(x, y)

        if x.size < 2  ||  x.size < 2
          raise ArgumentError, 'Arrays are too small'
        end

      end

      #helper for helper
      def self.check_types(x, y, z)

        if x.class != Array || y.class != Array
          raise ArgumentError, 'Wrong type of variables x or y'
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

