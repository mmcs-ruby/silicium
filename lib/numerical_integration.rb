module Silicium
  class NumericalIntegration
    # Delevoper: Dima
    def self.three_eights_integration(a, b, eps = 0.0001, &block)
      n = (1 / eps).floor
      dx = (b - a) * eps
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


    # Simpson Integration
    def self.simpson_integration(a, b, n = 10_000, &block)
      a, b = b, a if a > b
      dx = (b - a) / n
      result = 0
      i = 0
      while i < n
        result += (block.call(a + i * dx) + 4 * block.call(((a + i * dx) +
            (a + (i + 1) * dx)) / 2.0) + block.call(a + (i + 1) * dx)) / 6.0 * dx
        i += 1
      end
      result
    end

    def self.simpson_integration_with_eps(a, b, eps = 0.0001, &block)
      a, b = b, a if a > b
      dx = (b - a)
      res1 = (block.call(a) + 4 * block.call((a + b) / 2.0) + block.call(b)) / 6.0 * dx
      n = 2
      dx = (b - a) / n
      res2 = ((block.call(a) + 4 * block.call((a + (a + dx)) / 2.0) + block.call(a + dx)) +
             (block.call(a + dx) + 4 * block.call(((a + dx) + (a + 2 * dx)) / 2.0) + block.call(a + 2 * dx))) / 6.0 * dx
      while (res1 - res2).abs > eps
        res1 = res2
        res2 = 0
        n *= 5
        dx = (b - a) / n
        i = 0
        while i < n
          res2 += (block.call(a + i * dx) + 4 * block.call(((a + i * dx) +
              (a + (i + 1) * dx)) / 2.0) + block.call(a + (i + 1) * dx)) / 6.0 * dx
          i += 1
        end
      end
    end
  end
end
