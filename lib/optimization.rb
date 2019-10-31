require "silicium"
require 'fast_matrix'

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

    # integrating using method Monte Carlo (f - function, a, b - integrating limits, n - amount of random numbers)
    def integrating_Monte_Carlo_base(a, b, n = 100000, &block)
      res = 0
      range = a..b.to_f
      (1..(n + 1)).each do
         x = rand(range)
         res += (b - a) * 1.0 / n * block.call(x)
      end
      res
    end

    # return true if array is sorted
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
      raise ArgumentError, "Nil array in bogosort"  if a.nil?
      a.shuffle! until sorted?(a)
      a
    end

    #fastest(but it is not exactly) sort
    def bogosort(a)
      raise ArgumentError, "Nil array in bogosort"  if a.nil?
      crutch = a
      (crutch = a.shuffle) until sorted?(crutch)
      crutch
    end

    #calculate current accuracy in Hook - Jeeves method
    def accuracy(step)
      acc = 0
      step.each { |a| acc += a * a }
      Math.sqrt(acc)
    end

    #do one Hook - Jeeves step
    def hook_jeeves_step(x, i, step, &block)
      x[i] += step[i]
      tmp1 = block.call(x)
      x[i] = x[i] - 2 * step[i]
      tmp2 = block.call(x)
      if (tmp1 > tmp2)
        cur_f = tmp2
      else
        x[i] = x[i] + step[i] * 2
        cur_f = tmp1
      end
      [cur_f, x[i]]
    end

    # switch step if current func value > previous func value
    def switch_step(cur_f, prev_f, step, i)
      return step[i] / 2.0 if cur_f >= prev_f #you can switch 2.0 on something else
      step[i]
    end
    # Hook - Jeeves method for find minimum point (x - array of start variables, step - step of one iteration, eps - allowable error, alfa - slowdown of step,
    # block - function which takes array x, WAENING function doesn't control  correctness of input
    def hook_jeeves(x, step, eps = 0.1, &block)
      prev_f = block.call(x)
      acc = accuracy(step)
      while (acc > eps)
        for i in 0..x.length - 1
          tmp = hook_jeeves_step(x, i, step, &block)
          cur_f = tmp[0]
          x[i] = tmp[1]
          step[i] = switch_step(cur_f, prev_f, step, i)
          prev_f = cur_f
        end
        acc = accuracy(step)
      end
      x
    end

    # find centr of interval
    def middle(a, b)
      (a + b) / 2.0
    end

    #do one half division step
    def half_division_step(a, b, c, &block)
      if (block.call(a) * block.call(c)).negative?
        b = c
        c = middle(a, c)
      else
        a = c
        c = middle(b, c)
      end
      [a, b, c]
    end

    # find root in [a, b], if he exist, if number of iterations > iters -> error
    def half_division(a, b, eps = 0.001, &block)
      iters = 1000000
      c = middle(a, b)
      while (block.call(c).abs) > eps
        tmp = half_division_step(a, b, c, &block)
        a = tmp[0]
        b = tmp[1]
        c = tmp[2]
        iters -= 1
        raise RuntimeError, 'Root not found! Check does he exist, or change eps or iters' if iters == 0
      end
      c
    end


  end
end
