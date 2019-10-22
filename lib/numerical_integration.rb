module Silicium
  class NumericalIntegration
	

		# Method Middle Rectangles with a segment
		def	self.middle_rectangles_with_a_segment(a, b, n = 10_000, &block)
			dx = (b - a) / n.to_f
			result = 0
			i = 0
			n.times do
				result += block.call(a + dx * (i + 1 / 2)) * dx
				i += 1
			end
			result
		end

		# Method Middle Rectangles with specified accuracy
		def	self.middle_rectangles(a, b, eps = 0.0001, &block)
			n = 1
			begin
				result = middle_rectangles_with_a_segment(a, b, n, &block)
				n *= 5
				result1 = middle_rectangles_with_a_segment(a, b, n, &block)
			end	until (result - result1).abs < eps
			(result + result1) / 2.0
		end
  end
end