require 'silicium'
require 'chunky_png'

module Silicium
  ##
  # Plotter module
  # Module contains classes, that are different kinds of plain plotters
  #
  module Plotter
    include Silicium::Geometry
    ##
    # Factory method to return a color value, based on the arguments given.
    #
    # @overload Color(r, g, b, a)
    #   @param (see ChunkyPNG::Color.rgba)
    #   @return [Integer] The rgba color value.
    #
    # @overload Color(r, g, b)
    #   @param (see ChunkyPNG::Color.rgb)
    #   @return [Integer] The rgb color value.
    #
    # @overload Color(hex_value, opacity = nil)
    #   @param (see ChunkyPNG::Color.from_hex)
    #   @return [Integer] The hex color value, with the opacity applied if one
    #     was given.
    #
    # @overload Color(color_name, opacity = nil)
    #   @param (see ChunkyPNG::Color.html_color)
    #   @return [Integer] The hex color value, with the opacity applied if one
    #     was given.
    #
    # @overload Color(color_value, opacity = nil)
    #   @param [Integer, :to_i] The color value.
    #   @return [Integer] The color value, with the opacity applied if one was
    #     given.
    #
    # @return [Integer] The determined color value as RGBA integer.
    # @raise [ArgumentError] if the arguments weren't understood as a color.
    def color(*args)
      case args.length
      when 1 then ChunkyPNG::Color.parse(args.first)
      when 2 then (ChunkyPNG::Color.parse(args.first) & 0xffffff00) | args[1].to_i
      when 3 then ChunkyPNG::Color.rgb(*args)
      when 4 then ChunkyPNG::Color.rgba(*args)
      else raise ArgumentError,
                 "Don't know how to create a color from #{args.inspect}!"
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

      # TODO: Point from Geometry
      def rectangle(left_upper, width, height, color)
        x_end = left_upper.x + width - 1
        y_end = left_upper.y + height - 1
        (left_upper.x..x_end).each do |i|
          (left_upper.y..y_end).each do |j|
            @image[i, j] = color
          end
        end
      end

      ##
      # Draws a bar chart in the plot using provided +bars+,
      # each of them has width of +bar_width+ and colored +bars_color+
      def bar_chart(bars, bar_width,
                    bars_color = ChunkyPNG::Color('red @ 1.0'),
                    axis_color = ChunkyPNG::Color::BLACK)
        if bars.count * bar_width > @image.width
          raise ArgumentError,
                'Not enough big size of image to plot these number of bars'
        end

        padding = 5
        # Values of x and y on borders of plot
        min_x = [bars.collect { |k, _| k }.min, 0].min
        max_x = [bars.collect { |k, _| k }.max, 0].max
        min_y = [bars.collect { |_, v| v }.min, 0].min
        max_y = [bars.collect { |_, v| v }.max, 0].max

        # Dots per unit for X
        dpu_x = Float((@image.width - 2 * padding)) / (max_x - min_x + bar_width)
        # Dots per unit for Y
        dpu_y = Float((@image.height - 2 * padding)) / (max_y - min_y)
        # Axis OX
        rectangle(Point.new(padding,
                            @image.height - padding - (min_y.abs * dpu_y).ceil),
                  @image.width - 2 * padding,
                  1,
                  axis_color)
        # Axis OY
        rectangle(Point.new(padding + (min_x.abs * dpu_x).ceil, padding),
                  1,
                  @image.height - 2 * padding, axis_color)

        bars.each do |x, y| # Cycle drawing bars
          l_up_x = padding + ((x + min_x.abs) * dpu_x).floor
          l_up_y = @image.height - padding - (([y, 0].max + min_y.abs) * dpu_y).ceil + (y.negative? ? 1 : 0)
          rectangle(Point.new(l_up_x, l_up_y),
                    bar_width, (y.abs * dpu_y).ceil,
                    bars_color)
        end
      end

      ##
      # Exports plotted image to file +filename+
      def export(filename)
        @image.save(filename, interlace: true)
      end
    end
  end
end