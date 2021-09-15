require 'fast_matrix'

module Silicium
  module Optimization
    # reflector function
    def re_lu(x)
      x.negative? ? 0 : x
    end

    # sigmoid function
    def sigmoid(x)
      1.0 / (1 + Math.exp(-x))
    end

    # integrating using method Monte Carlo (f - function, a, b - integrating limits, n - amount of random numbers)
    def integrating_Monte_Carlo_base(a, b, n = 100000, &block)
      res = 0
      range = a..b.to_f
      (0..n).each do
        x = rand(range)
        res += (b - a) * 1.0 / n * block.call(x)
      end
      res
    end

    # return true if array is sorted
    def sorted?(a)
      return false if a.nil?

      for i in 0..a.length - 2
        return false if (a[i + 1] < a[i])
      end
      true
    end

    # fastest(but it is not exactly) sort, modify sequance
    def bogosort!(a)
      raise ArgumentError, "Nil array in bogosort" if a.nil?

      a.shuffle! until sorted?(a)
      a
    end

    # fastest(but it is not exactly) sort
    def bogosort(a)
      raise ArgumentError, "Nil array in bogosort" if a.nil?

      crutch = a
      (crutch = a.shuffle) until sorted?(crutch)
      crutch
    end

    # calculate current accuracy in Hook - Jeeves method
    def accuracy(step)
      acc = 0
      step.each { |a| acc += a * a }
      Math.sqrt(acc)
    end

    # do one Hook - Jeeves step
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
      return step[i] / 2.0 if cur_f >= prev_f # you can switch 2.0 on something else

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

    # do one half division step
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

    # Find determinant 3x3 matrix
    def determinant_sarryus(matrix)
      raise ArgumentError, "Matrix size must be 3x3" if (matrix.row_count != 3 || matrix.column_count != 3)

      matrix[0, 0] * matrix[1, 1] * matrix[2, 2] + matrix[0, 1] * matrix[1, 2] * matrix[2, 0] + matrix[0, 2] * matrix[1, 0] * matrix[2, 1] -
        matrix[0, 2] * matrix[1, 1] * matrix[2, 0] - matrix[0, 0] * matrix[1, 2] * matrix[2, 1] - matrix[0, 1] * matrix[1, 0] * matrix[2, 2]
    end

    # return probability to accept
    def accept_annealing(z, min, t, d)
      p = (min - z) / (d * t * 1.0)
      Math.exp(p)
    end

    # do one annealing step
    def annealing_step(x, min_board, max_board)
      x += rand(-0.5..0.5)
      x = max_board if (x > max_board)
      x = min_board if (x < min_board)
      x
    end

    # update current min and xm if cond
    def annealing_cond(z, min, t, d)
      (z < min || accept_annealing(z, min, t, d) > rand(0.0..1.0))
    end

    # Annealing method to find min of function with one argument, between min_board max_board,
    def simulated_annealing(min_board, max_board, t = 10000, &block)
      d = Math.exp(-5) # Constant of annealing
      x = rand(min_board * 1.0..max_board * 1.0)
      xm = x
      min = block.call(x)
      while (t > 0.00001)
        x = xm
        x = annealing_step(x, min_board, max_board)
        z = block.call(x)
        if (annealing_cond(z, min, t, d))
          min = z
          xm = x
        end
        t *= 0.9999 # tempreture drops
      end
      xm
    end

    # Fast multiplication of num1 and num2.
    def karatsuba(num1, num2)
      return num1 * num2 if num1 < 10 || num2 < 10

      max_size = [num1.to_s.length, num2.to_s.length].max

      first_half1, last_half1 = make_equal(num1, max_size)
      first_half2, last_half2 = make_equal(num2, max_size)

      t0 = karatsuba(last_half1, last_half2)
      t1 = karatsuba((first_half1 + last_half1), (first_half2 + last_half2))
      t2 = karatsuba(first_half1, first_half2)

      compute_karatsuba(t0, t1, t2, max_size / 2)
    end

    private

    # Helper for karatsuba method. Divides num into two halves.
    def make_equal(num, size)
      mid = (size + 1) / 2
      string = num.to_s.rjust(size, '0')
      [string.slice(0...mid).to_i, string.slice(mid..-1).to_i]
    end

    # Helper for karatsuba method. Computes the result of karatsuba's multiplication.
    def compute_karatsuba(tp0, tp1, tp2, num)
      tp2 * 10**(2 * num) + ((tp1 - tp0 - tp2) * 10**num) + tp0
    end
  end
end
