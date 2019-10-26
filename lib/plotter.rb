require "silicium"
require 'chunky_png'

module Silicium
  module Plotter

    class Image
      def initialize(width, height)
        @image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      end

      def rectangle(x, y, width, height, color)
        x_end = x + width
        y_end = y + height
        (x..x_end).each do |i|
          (y..y_end).each do |j|
            @image[i, j] = color
          end
        end
      end

      def bar_chart(bars, bar_width, color)
        padding = 5
        minx = bars.collect { |k, _| k }.min
        maxx = bars.collect { |k, _| k }.max
        miny = bars.collect { |_, v| v }.min
        maxy = bars.collect { |_, v| v }.max
        rectangle(padding, @image.height - padding, @image.width - 2 * padding, 0, color)
        dpux = Float((@image.width - 2 * padding)) / (maxx - minx + bar_width)
        dpuy = Float((@image.height - 2 * padding)) / maxy
        bars.each do |x,y|
          rectangle(padding + ((x - minx) * dpux).ceil, @image.height - padding - (y * dpuy).ceil, bar_width, y * dpuy, color)
        end
      end

      def export(filename)
        @image.save(filename, :interlace => true)
      end
    end

  end

end