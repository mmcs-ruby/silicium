module Silicium
  class NumericalIntegration
    # Delevoper: Dima
    def self.three_eights_integration(a, b, eps = 0.0001, &block)
      n = (1 / eps).floor
      dx = 1.0 * (b - a) / n
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

    # Write your methods here
  end
end