module Silicium
  module LinearRegression
    class LinearRegressionByGradientDescent
      def generate_function(plot)
        theta0 = 0
        theta1 = 0
        alpha = 1
        m = plot.lenght
        epsilon = 0.0001
        bias_old = 10 
        bias_new = 0
        unless (bias_old - bias_new) < epsilon
          (old_theta0, old_theta1) = (theta0, theta1)
          theta0 = alpha / m * d_dt_for_theta0(plot, theta0, theta1)
          theta1 = alpha / m * d_dt_for_dheta1(plot, theta0, theta1)
          (bias_old, bias_new) = (bias_new, max(abs(theta0 - old_theta0), abs(theta1 - old_theta1)))
        end
        return (theta0, theta1)
      end

      def d_dt_for_theta0(plot, theta0, theta1)
        result = 0 
        plot.each do |x, y|
          result += (theta0 + theta1 * x) - y
        end 
        return result
      end

      def d_dt_for_theta1(plot, theta0, theta1)
         result = 0 
         plot.each do |x, y|
           result += ((theta0 + theta1 * x) - y) * x
         end
         return result
      end

      def cost_function(plot, theta0, theta1)
        result = 0
        m = plot.lenght
        plot.each do |x, y|
          dif = (theta0 + x * theta1) - y
          result += dif ** 2
        end
        return result / (2 * m)
      end
    end
  end
end
