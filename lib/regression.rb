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
      def generate_function(given_plot, alpha, n = 5, scaling = false)
        plot = feature_scaled_plot(given_plot) if scaling else given_plot
        array = Array.new(n + 1, 1)
        m = plot.length.to_f 
        epsilon = 0.000001 
        bias = 0.5 
        while bias.abs() > epsilon 
          old_array = array 
          i = 0
          array.each do |elem|
            elem = elem - alpha / m * d_dt(plot, old_array, i)
            i += 1
          end
          bias = (array.zip(old_array).map {|new, old| (new - old).abs()}).max()
        end 
        return array
      end 
      
      def d_dt(plot, old_array, i)
        sum = 0.0 
        plot.each do |x, y|  
          sum += (func(array, x) - y) * (i + 1) * (x ** i)
        end 
        return sum
      end 
      
      def func(array, x)
        sum = 0.0 
        i = 0 
        array.each do |elem|
          sum += elem * (x ** i)
          i += 1
        end 
        return sum
      end 
      
      def feature_scaled_plot(given_plot, n)
        max = given_plot[0]
        min = given_plot[0]
        sum = 0.0 
        given_plot.each do |x, _|
          max = x if x > max  
          min = x if x < min 
          sum += x
        end 
        avg = sum.to_f / given_plot.length 
        given_plot.map! {|x, y| (x.to_f - avg) / (max - min)**n}
        return given_plot
      end
    end 
  end
end
