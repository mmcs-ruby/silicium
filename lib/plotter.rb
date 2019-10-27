require 'silicium'
require 'chunky_png'

module Silicium
  module Plotter
    def Color(*args)
      case args.length
      when 1; ChunkyPNG::Color.parse(args.first)
      when 2; (ChunkyPNG::Color.parse(args.first) & 0xffffff00) | args[1].to_i
      when 3; ChunkyPNG::Color.rgb(*args)
      when 4; ChunkyPNG::Color.rgba(*args)
      else raise ArgumentError, "Don't know how to create a color from #{args.inspect}!"
      end
    end
    ##
    # A class representing canvas for plotting bar charts and function graphs
    class Image
      ##
      # Creates a new plot with chosen +width+ and +height+ parameters
      # with background colored +bg_color+
      def initialize(width, height, bg_color = ChunkyPNG::Color::TRANSPARENT)
        @image = ChunkyPNG::Image.new(width, height, bg_color)
      end

      def rectangle(x, y, width, height, color)
        x_end = x + width - 1
        y_end = y + height - 1
        (x..x_end).each do |i|
          (y..y_end).each do |j|
            @image[i, j] = color
          end
        end
      end

      ##
      # Draws a bar chart in the plot using provided +bars+,
      # each of them has width of +bar_width+ and colored +bars_color+
      def bar_chart(bars, bar_width, bars_color = ChunkyPNG::Color('red @ 1.0'), axis_color = ChunkyPNG::Color::BLACK)
        if bars.count * bar_width > @image.width
          raise ArgumentError, 'Not enough big size of image to plot these number of bars'
        end

        padding = 5
        # Values of x and y on borders of plot
        minx = [bars.collect { |k, _| k }.min, 0].min
        maxx = [bars.collect { |k, _| k }.max, 0].max
        miny = [bars.collect { |_, v| v }.min, 0].min
        maxy = [bars.collect { |_, v| v }.max, 0].max
        dpux = Float((@image.width - 2 * padding)) / (maxx - minx + bar_width) # Dots per unit for X
        dpuy = Float((@image.height - 2 * padding)) / (maxy - miny) # Dots per unit for Y
        rectangle(padding, @image.height - padding - (miny.abs * dpuy).ceil, @image.width - 2 * padding, 1, axis_color) # Axis OX
        rectangle(padding + (minx.abs * dpux).ceil, padding, 1, @image.height - 2 * padding, axis_color) # Axis OY

        bars.each do |x, y| # Cycle drawing bars
          rectangle(padding + ((x + minx.abs) * dpux).floor,
                    @image.height - padding - (([y, 0].max + miny.abs) * dpuy).ceil + (y.negative? ? 1 : 0),
                    bar_width, (y.abs * dpuy).ceil, bars_color)
        end
      end

      ##
      # Exports plotted image to file +filename+
      def export(filename)
        @image.save(filename, :interlace => true)
      end
    end
  end
end