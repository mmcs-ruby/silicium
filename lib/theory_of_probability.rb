module Combinatorics
  def factorial(a)
    res = 1
    if a > 0
      for i in 2..a
        res *= i
      end
    end
    res
  end

  def Combination(n, k)
    if n < k or k <= 0
      -1
    else
      factorial(n) / (factorial(k) * factorial(n - k))
    end
  end

  def Arrangement(n, k)
    if n < k or k <= 0
      -1
    else
      factorial(n) / factorial(n - k)
    end
  end

  def Permutation(n, k)
    if n < k or k <= 0
      -1
    else
      factorial(n) / factorial(k)
    end
  end
end