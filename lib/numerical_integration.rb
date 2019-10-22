module Silicium
  class MySpecialError < RuntimeError

  end
  class NumericalIntegration

    def self.three_eights_integration(a, b, eps = 0.0001, &block)
      n = 1
      begin
        begin
          integral0 = three_eights_integration_n(a, b, n, &block)
          n *= 5
          integral1 = three_eights_integration_n(a, b, n, &block)
        end until (integral0 - integral1).abs < eps
      rescue ZeroDivisionError
        raise ::Silicium::MySpecialError, "Divide by zero"
      end
      (integral0 + integral1) / 2.0
    end

    def self.three_eights_integration_n(a, b, n, &block)
      dx = (b - a) / n.to_f
      result = 0
      x = a
      n.times do
        result +=
            (block.call(x) + 3 * block.call((2 * x + x + dx) / 3.0) +
                3 * block.call((x + 2 * (x + dx)) / 3.0) + block.call(x + dx)) / 8.0 * dx
        x += dx
      end
      result
    end


    # Simpson integration with a segment
    def self.simpson_integration_with_a_segment(a, b, n = 10_000, &block)
      dx = (b - a) / n.to_f
      result = 0
      i = 0
      while i < n
        result += (block.call(a + i * dx) + 4 * block.call(((a + i * dx) +
            (a + (i + 1) * dx)) / 2.0) + block.call(a + (i + 1) * dx)) / 6.0 * dx
        i += 1
      end
      result
    end

    # Simpson integration with specified accuracy
    def self.simpson_integration(a, b, eps = 0.0001, &block)
      n = 1
      res1 = simpson_integration_with_a_segment(a, b, 1, &block)
      res2 = simpson_integration_with_a_segment(a, b, 2, &block)
      while (res1 - res2).abs > eps
        n *= 5
        res1 = res2
        res2 = simpson_integration_with_a_segment(a, b, n, &block)
      end
      res2
    end

    # Left Rectangle Method and Right Rectangle Method
    def self.left_rect_integration(left_p, right_p, eps = 0.0001, &block)
      splits = 1
      res1 = left_rect_integration_n(left_p, right_p, 1, &block)
      res2 = left_rect_integration_n(left_p, right_p, 5, &block)
      while (res1 - res2).abs > eps
        res1 = left_rect_integration_n(left_p, right_p, splits, &block)
        splits *= 5
        res2 = left_rect_integration_n(left_p, right_p, splits, &block)
      end
      (res1 + res2) / 2.0
    end

    # Left Rectangle Auxiliary Method and Right Rectangle Auxiliary Method
    def self.left_rect_integration_n(left_p, right_p, splits, &block)
      dx = (right_p - left_p) / splits.to_f
      result = 0
      i = 0
      while i < splits
        result += block.call(left_p + i * dx)
        i += 1
      end
      result * dx
    end

  end
end


