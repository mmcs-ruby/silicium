require "silicium"

module Silicium
  module Optimization

    # reflector function
    def re_lu(x)
      x.negative? ? 0 : x
    end

    #sigmoid function
    def sigmoid(x)
      1.0 / (1 + Math.exp(-x))
    end

    #integrating using method Monte Carlo (f - function, a, b - integrating limits, n - amount of random numbers)
    def integrating_Monte_Carlo_base(fun, a, b, n = 100000)
      sum = 0
      res = 0
      for i in 0..n
        x = rand(a * 1.0, b * 1.0)
        sum += fun.call(x)
        res += (b - a) * 1.0 / i * s
      end
      res
    end

  end
end
