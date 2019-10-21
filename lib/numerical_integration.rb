module Silicium
  class NumericalIntegration
    # Delevoper: Dima
    def three_eights_integration(a, b, block)
      n = 1000
      dx = (b - a) / n
      result = 0

      i = 0
      n.times do

      end
    end


		# Method Middle Rectangles with a segment
		def	self.middle_rectangles_with_a_segment(a, b, n: 10_000, &block)
			dx = (b - a) / n.to_f
			result = 0
			i = 1
			n.times do
				result += block.call(a + dx * i / 2) * dx
				i += 1
			end
			result
		end

		# Method Middle Rectangles with specified accuracy
		def	self.middle_rectangles(a, b, eps: 0.0001, &block)
			n = 1
			loop  do
				result = middle_rectangles_with_a_segment(a, b, n, &block)
				n *= 5
				result1 = middle_rectangles_with_a_segment(a, b, n, &block)
				break if (result - result1).abs < eps
			end
			result1
		end
  end
end