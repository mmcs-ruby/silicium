module Combinatorics
  def factorial(n)
    res = (1..n).inject(:*) || 1
    res
  end
  
  def fact(n, k)
    res = [1,1,1]
    c = 1
    if n > 1
      for i in 2..n
        c *= i
        if i == n-k
          res[1] = c
        elsif i == k
          res[2] = c
        end
      end
    end
    res[0] = c
    res
  end

  def combination(n, k)
    f = fact(n, k)
    if n < k or k <= 0
      -1
    else
      f[0] / (f[2] * f[1])
    end
  end

  def arrangement(n, k)
    f = fact(n, k)
    if n < k or k <= 0
      -1
    else
      f[0] / f[1]
    end
  end

  def permutation(n, k)
    f = fact(n, k)
    if n < k or k <= 0
      -1
    else
      f[0] / f[2]
    end
  end
  
  
end

module Cubes

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

    def initialize(sides)
      @csides = 1
      @sides = [1]
      if sides.class == Integer
        if sides > 1
          @csides = sides
          for i in 2..sides
            @sides << i
          end
        end
      elsif sides.class == Array and sides.size > 0
        @csides = sides.size
        @sides = sides.sort
      end
    end

    def throw
      sides[rand(0..@csides-1)]
    end
  end

  class Set_Of_Polyhedrons

    def initialize(arr)
      @pons = parse_pons(arr).sort_by{|item| -item.csides}
      @percentage = count_chance_sum
    end

    def percentage
      @percentage
    end

    def to_s
      res = @pons.map {|item| item.to_s}
	  res
    end

    def throw
      sum = 0
      r = rand
      @percentage.each do |item|
        sum += item[1]
        if sum > r
          item[0]
          break
        end
      end
    end

    private

    def parse_pons(arr)
      res = []
      arr.each do |item|
        res << Polyhedron.new(item)
      end
      return res
    end
	
	def count_chance_sum_chances_step(arr1, arr2, arr3, h)
	  n = 0
      m = 0
      sum = 0
      q = Queue.new
      h1 = Hash.new
      while m < arr2.size
        if m == 0
          q << h[(arr1[n]).to_s]
          sum += h[(arr1[n]).to_s]
        end
        if q.size > arr2.size or m > 0
          sum -= q.pop
        end
        h1[(arr1[n] + arr2[m]).to_s] = sum
        arr3 << (arr1[n] + arr2[m])
        if n < arr1.size - 1
          n += 1
        else
          m += 1
        end
      end
      h1
	end

    def count_chance_sum
      h = Hash.new
      @pons[0].sides.each do |item|
        h[item.to_s] = 1
      end
      arr3 = @pons[0].sides
      for i in 1..@pons.size - 1
        arr1 = arr3
        arr3 = Array.new
        arr2 = @pons[i].sides
        h1 = count_chance_sum_chances_step(arr1, arr2, arr3, h)
        h = h1
        h1 = Hash.new
      end
      res = Hash.new
      fchance = @pons.inject(1) { |mult, item| mult * item.csides }
      arr3.each {|item| res[item.to_s] = Float(h[item.to_s]) / fchance}
      res
    end
  end

end