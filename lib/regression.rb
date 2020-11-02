module Silicium
  module Regression
    class LinearRegressionByGradientDescent
      # Finds parameters theta0, theta1 for equation theta0 + theta1 * x
      # for linear regression of given plot of one variable
      # @param plot Actually hash x => y for different points of the plot
      # @param alpha Speed of learning (should be little enough not to diverge)
      # @param start_theta0 Starting value of theta0
      # @param start_theta1 Starting value of theta1
      # @return [Numeric] theta0, theta1
      def self.generate_function(plot, alpha = 0.01, start_theta0 = 0.0, start_theta1 = 0.0)
        theta0 = start_theta0
        theta1 = start_theta1
        m = plot.length.to_f
        epsilon = 0.000001
        bias_new = 5.0
        while bias_new.abs() > epsilon
          old_theta0, old_theta1 = theta0, theta1
          oth = theta0
          theta0 = theta0 - alpha / m * d_dt_for_theta0(plot, theta0, theta1)
          theta1 = theta1 - alpha / m * d_dt_for_theta1(plot, oth, theta1)
          bias_new = [(theta0 - old_theta0).abs(), (theta1 - old_theta1).abs()].max()
        end
        return theta0, theta1
      end

      private

      def self.d_dt_for_theta0(plot, theta0, theta1)
        result = 0.0 
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

    end 
    
    # Finds parameters as array [1..n] for polynom of n-th degree
    # @param plot Actually hash x => y for different points of the plot
    # @param alpha Speed of learning (should be little enough not to diverge)
    # @param n Degree of expected polynom
    # @return Array[Numeric] parameners (little index is lower degree parameter)

    class PolynomialRegressionByGradientDescent
      def self.generate_function(given_plot, n = 5, alpha = 0.001, epsilon = 0.000001)
        scaling = n > 3
        if scaling
          plot, avg_x, div = feature_scaled_plot(given_plot, n)
        else
          plot = given_plot
        end

        array = Array.new(n + 1, 1)
        m = plot.length.to_f
        bias = 0.5
        old_bias = bias
        while bias.abs() > epsilon
          old_array = array.dup()
          i = -1
          array.map! { |elem|
            i += 1
            elem - alpha / m * d_dt(plot, old_array, i)
          }
          bias = (array.zip(old_array).map {|new, old| (new - old).abs()}).max()
          if bias > old_bias
            raise "Divergence"
          end
          old_bias = bias
        end
        if (scaling)
          return array.map! {|x| x * div + avg_x }
        end
        return array
      end

      private

      def self.d_dt(plot, old_array, i)
        sum = 0.0 
        plot.each do |x, y|  
          sum += (func(old_array, x) - y) * (i + 1) * (x ** i)
        end 
        return sum
      end 
      
      def self.func(array, x)
        sum = 0.0 
        i = 0 
        array.each do |elem|
          sum += elem * (x ** i)
          i += 1
        end 
        return sum
      end 
      
      def self.feature_scaled_plot(given_plot, n)
        max_x = given_plot[0][0]
        min_x = given_plot[0][0]
        sum_x = 0.0
        given_plot.each do |x, _|
          max_x = x if x > max_x
          min_x = x if x < min_x
          sum_x += x
        end
        avg_x = sum_x.to_f / given_plot.length
        range_x = max_x - min_x
        div = range_x ** n
        new_plot = given_plot.map {|x, y| [x, (y.to_f - avg_x) / div]}
        return new_plot, avg_x, div
      end
    end 
  end
end

# -x^2 + 3x + 2
# plot = {0 => 2, -1 => -2, -2 => -8, -3 => -16, 1 => 4, 2 => 4, 3 => 2, 4 => -2, -4 => -26}
# res = Silicium::Regression::PolynomialRegressionByGradientDescent::
#       generate_function(plot, 0.001, 2, true)
# puts res

# -x^3 + x^2 - 3x + 5
plot2 = {-5 => 170, -4 => 97, -3 => 50, -2 => 23, -1 => 10, 0 => 5, 1 => 2, 2 => -5, 3 => -22, 4 => -55, 5 => -110}

 res = Silicium::Regression::PolynomialRegressionByGradientDescent::
        generate_function(plot2, 3, 0.00001, 0.0000001)

 p res