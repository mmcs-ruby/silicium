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

	# Developer: Gayane
	def	self.middle_rectangles(a, b, &block)
		n = 1000
		dx = (b - a) / n
		result = 0
		
		i = 1
		n.times do
			result += block.call(a + dx * i / 2) * dx
			i += 1
		end
		result
	end
  end
end