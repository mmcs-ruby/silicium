require 'matrix'
module Silicium
  module MethodGaussAndKramer
    class Matrix
      def []=(i, j, value)
        @rows[i][j] = value
      end


      def norm_rows(new_rows, b)
        (0..@column_count - 1).each { |j|
          new_rows.rows[j][i] = b[j]
        }
        new_rows
      end

      def kramer(b)
        dt = det
        raise RuntimeError.new('Det is zero') if det == 0
        result = Array.new(@column_count)
        (0..@column_count - 1).each { |i|
          new_rows = itself.clone
          norm_rows(new_rows, b)
          result[i] = new_rows.det / dt.to_f
        }
        result
      end
    end


    def gauss_method_sol(eq)
      (0...eq.size).each { |i|
        if eq[i][i] != 0
          eq[i] /= eq[i][i].to_f
        end
        (i + 1...eq.size).each { |j| eq[j] -= eq[i] * eq[j][i] }
      }
      (1...eq.size).to_a.reverse.each { |i|
        (0...i).each { |j| eq[j] -= eq[i] * eq[j][i] }
      }
      eq.map { |vector| vector[-1] }
    end

  end
end
