require 'matrix'
module Silicium
  module MethodGaussAndKramer
    class Matrix
  def []=(i, j, value)
    @rows[i][j] = value
  end

  def kramer(b)
    dt = det
    if dt == 0
      "Система не имеет ни одного решения или имеет нескончаемое количество решений"
    else
      result = Array.new(@column_count)
      for i in 0..@column_count - 1
        new_rows = itself.clone
        for j in 0..@column_count - 1
          new_rows.rows[j][i] = b[j]
        end
        result[i]=new_rows.det/dt.to_f
      end
      result
    end
  end

end

    def gauss_method_sol(eq)
    (0...eq.size).each{ |i|
    if eq[i][i] !=0
      eq[i] /= eq[i][i].to_f
    end
      (i+1...eq.size).each{ |j| eq[j] -= eq[i] * eq[j][i] }
    }
    (1...eq.size).to_a.reverse.each{ |i|
      (0...i).each{ |j| eq[j] -= eq[i] * eq[j][i] }
    }
    res = eq.map{ |vector| vector[-1] }
    res
    end
  end
end
