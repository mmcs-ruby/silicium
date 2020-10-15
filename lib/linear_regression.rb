module Silicium
  module LinearRegression
    class LinearRegressionByGradientDescent
      def self.generate_function(plot)
        theta0 = 2.0
        theta1 = 2.0
        alpha = 1.0
        m = plot.length.to_f
        epsilon = 0.00001
        bias_old = 10.0
        bias_new = 0.0
        unless (bias_old - bias_new).abs() < epsilon
          old_theta0, old_theta1 = theta0, theta1
          oth = theta0
          theta0 = theta0 - alpha / m * d_dt_for_theta0(plot, theta0, theta1)
          theta1 = theta1 - alpha / m * d_dt_for_theta1(plot, oth, theta1)
          bias_old, bias_new = bias_new, [(theta0 - old_theta0).abs(), (theta1 - old_theta1).abs()].max()
        end
        return theta0, theta1
      end

      def self.d_dt_for_theta0(plot, theta0, theta1)
        result = 0 
        plot.each do |x, y|
          result += (theta0 + theta1 * x) - y
        end 
        return result
      end

      def self.d_dt_for_theta1(plot, theta0, theta1)
         result = 0 
         plot.each do |x, y|
           result += ((theta0 + theta1 * x) - y) * x
         end
         return result
      end

      def self.cost_function(plot, theta0, theta1)
        result = 0
        m = plot.length
        plot.each do |x, y|
          dif = (theta0 + x * theta1) - y
          result += dif ** 2
        end
        return result / (2 * m)
      end
    end
  end
end

plot = {0=> 0, 1=> 2, 2 => 4, 3 => 6, 4=>8, 5=>10, 6=>12, 7=>14, 8=>16}
theta0, theta1 = Silicium::LinearRegression::LinearRegressionByGradientDescent::generate_function(plot)
puts theta0, theta1