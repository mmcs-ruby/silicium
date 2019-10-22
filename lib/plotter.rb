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

      def export(filename)
        @image.save(filename, :interlace => true)
      end
    end

  end

end