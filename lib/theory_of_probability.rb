require 'plotter'
require 'chunky_png'

include Silicium::Plotter

module Combinatorics

  def factorial(n)
    (1..n).inject(:*) || 1
  end

  ##
  #Function C(n,k)
  def combination(n, k)
    f = fact(n, k)
    if n < k or k <= 0
      -1
    else
      f[0] / (f[2] * f[1])
    end
  end

  ##
  #Function A(n,k)
  def arrangement(n, k)
    f = fact(n, k)
    if n < k or k <= 0
      -1
    else
      f[0] / f[1]
    end
  end

  private

  def fact(n, k)
    res = [1,1,1]
    fact_n_greater_1(n, k, res) if n > 1
    res
  end

  def fact_n_greater_1(n,k, res)
    c = 1
    for i in 2..n
      c *= i
      determining_i([i, n, k, c], res)
    end
    res[0] = c
  end

  def determining_i(arr, res)
    res[1] = arr[3] if arr[0] == arr[1] - arr[2]
    res[2] = arr[3] if arr[0] == arr[2]
  end

end

module Dice

  ##
  # Class represents a polyhedron
  # csides - number or sides
  # sides - array of sides(unusual for custom polyhedrons)
  class Polyhedron

    def csides
      @csides
    end

    def sides
      @sides
    end

    def to_s
      sides
    end

    ##
    # initializing polyhedron's variables
    # there are two ways how to create it
    # 1: by number (6) - creates polyhedron with 6 sides [1,2,3,4,5,6]
    # 2: by array ([1,3,5]) - creates polyhedron with 3 sides [1,3,5]
    def initialize(sides)
      @csides = 1
      @sides = [1]
      if sides.class == Integer and sides > 1
        @csides = sides
        (2..sides).each {|i| @sides << i}
      elsif sides.class == Array and sides.size > 0
        @csides = sides.size
        @sides = sides.sort
      end
    end

    ##
    # ability to throw a polyhedron
    def throw
      @sides[rand(0..@csides-1)]
    end
  end

  ##
  # Class represents a PolyhedronsSet
  class PolyhedronSet

    def initialize(arr)
      @pons = parse_pons(arr).sort_by{|item| -item.csides}
      @percentage = count_chance_sum
    end

    # hash with chances of getting definite score
    def percentage
      @percentage
    end

    ##
    # returns array of polyhedrons
    def to_s
      @pons.map {|item| item.to_s}
    end

    ##
    # ability to throw a polyhedron set using hash of chances
    def throw
      sum = 0
      r = rand
      @percentage.each do |item|
        sum += item[1]
        if sum >= r
          item[0]
          break
        end
      end
    end

    ##
    # creating a graph representing chances of getting points
    def make_graph_by_plotter(x = percentage.size * 10, y = percentage.size * 10)
      filename = 'tmp/percentage.png'
      File.delete(filename) if File.exist?(filename)
      plotter = Image.new(x, y)
      plotter.bar_chart(percentage, 1, color('red @ 1.0'))
      plotter.export(filename)
    end

    private

    def parse_pons(arr)
      res = []
      arr.each do |item|
        if item.is_a?(Integer) or item.is_a?(Array)
          res << Polyhedron.new(item)
        elsif item.is_a?(Polyhedron)
          res << item
        end
      end
      res
    end

    def count_chance_sum_chances_step(arr1, arr2, arr3, h)
      n = 0
      m = 0
      sum = 0
      q = Queue.new
      h1 = {}
      while m < arr2.size
        sum = m_0([sum, n, m], q, h, arr1)
        sum -= q.pop if q.size > arr2.size || m > 0
        h1[arr1[n] + arr2[m]] = sum
        arr3 << (arr1[n] + arr2[m])
        nmarr = n_less_arr1_size(n, arr1, m)
        n, m = nmarr[0], nmarr[1]
      end
      h1
    end

    def m_0(arr, q, h, arr1)
      if arr[2] == 0
        a = h[arr1[arr[1]]]
        q << a
        arr[0] += a
      end
      arr[0]
    end

    def n_less_arr1_size(n, arr1, m)
      if n < arr1.size - 1
        n += 1
      else
        m += 1
      end
      [n,m]
    end

    def count_chance_sum
      h = {}
      @pons[0].sides.each { |item| h[item] = 1 }
      arr3 = @pons[0].sides
      for i in 1..@pons.size - 1
        arr1 = arr3
        arr3 = []
        arr2 = @pons[i].sides
        h1 = count_chance_sum_chances_step(arr1, arr2, arr3, h)
        h = h1
      end
      res = {}
      fchance = @pons.inject(1) { |mult, item| mult * item.csides }
      arr3.each {|item| res[item] = Float(h[item]) / fchance}
      res
    end

  end
end

module BernoulliTrials

  include Combinatorics
  include Math

  def bernoulli_formula_and_laplace_theorem(n, k, all, suc = -1)
    if suc != -1
      p = suc.fdiv all
    else
      p = all
    end
    q = 1 - p
    if n * p * q < 9         # Laplace theorem give satisfactory approximation for n*p*q > 9, else Bernoulli formula
      combination(n, k) * (p ** k) * (q ** (n - k))          # Bernoulli formula C(n,k) * (p ^ k) * (q ^ (n-k))
    else
      gaussian_function((k - n * p).fdiv sqrt(n * p * q)).fdiv(sqrt(n * p * q))        # Laplace theorem φ((k - n*p)/sqrt(n*p*q)) / sqrt(n*p*q)
    end
  end

  def gaussian_function(x)
    if x < 0           # φ(-x) = φ(x)
      x * -1
    end
    exp(-(x ** 2) / 2).fdiv sqrt(2 * PI)      # φ(x) = exp(-(x^2/2)) / sqrt(2*π)
  end
end