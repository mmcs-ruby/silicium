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
        plot.each { |x, y| result += (theta0 + theta1 * x) - y }

        result
      end

      def self.d_dt_for_theta1(plot, theta0, theta1)
         result = 0 
         plot.each { |x, y| result += ((theta0 + theta1 * x) - y) * x }

         result
      end

    end 
    
    # Finds parameters as array [1..n] for polynom of n-th degree
    # @param plot Actually hash x => y for different points of the plot
    # @param n Degree of expected polynom
    # @param alpha Speed of learning (should be little enough not to diverge)
    # @param epsilon Accuracy
    # @return Array[Numeric] coefficients (little index is lower degree parameter)
    class PolynomialRegressionByGradientDescent
      def self.generate_function(given_plot, n = 5, alpha = 0.001, epsilon = 0.000001)
        scaling = n > 3
        if scaling
            plot, avg_x, div = feature_scaled_plot(given_plot, n)
        else
            (plot = given_plot)
        end
        array = Array.new(n + 1, 1)
        m = plot.length.to_f
        bias = old_bias = 0.5

        array = calculate([bias, epsilon, array, alpha, plot, old_bias, m])

        return array.map! {|x| x * div + avg_x } if scaling
        array
      end

      private

      def self.calculate(params)
        while params[0].abs() > params[1]
          old_array = params[2].dup()
          i = -1
          params[2].map! { |elem|
            i += 1
            elem - params[3] / params[6] * d_dt(params[4], old_array, i)
          }
          params[0] = (params[2].zip(old_array).map {|new, old| (new - old).abs()}).max()
          raise "Divergence" if params[0] > params[5]
          params[5] = params[0]
        end
        params[2]
      end

      def self.d_dt(plot, old_array, i)
        sum = 0.0 
        plot.each { |x, y| sum += (func(old_array, x) - y) * (i + 1) * (x ** i) }

        sum
      end 
      
      def self.func(array, x)
        sum = 0.0 
        i = 0 
        array.each do |elem|
          sum += elem * (x ** i)
          i += 1
        end 
        sum
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