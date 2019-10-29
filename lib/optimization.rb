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
    def integrating_Monte_Carlo_base(a, b, n = 100000, &block)
      res = 0
      range = a..b.to_f
      for i in 1..(n + 1)
         x = rand(range)
         res += (b - a) * 1.0 / n * block.call(x)
      end
      res
    end

    #return true if array is sorted
    def sorted?(a)
      return false if a.nil?
      for i in 0..a.length - 2
        if (a[i + 1] < a[i])
          return false
        end
      end
      true
    end

    #fastest(but it is not exactly) sort, modify sequance
    def bogosort!(a)
      if (a.nil?)
        raise ArgumentError, "Nil array in bogosort"
      end
      while (!sorted?(a))
        a.shuffle!
      end
      a
    end

    #fastest(but it is not exactly) sort
    def bogosort(a)
      if (a.nil?)
        raise ArgumentError, "Nil array in bogosort"
      end
      crutch = a
      while (!sorted?(crutch))
        crutch = a.shuffle
      end
      crutch
    end


  end
end
