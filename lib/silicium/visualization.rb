module Silicium
  module Sparse
    # here goes tha addition to SparseMatrix class
    class SparseMatrix
      ##
      # @param [String,Integer] text - string to be colorized , color_code - color
      # @return [String] Colorized string
      #
      # colorize string
      def colorize(text, color_code)
        "\e[#{color_code}m#{text}\e[0m"
      end

      ##
      # @param [String] text - string to be colorized
      # @return [String] Colorized string
      #
      # colorize string in red
      def red(text); colorize(text, 31); end

      ##
      # @param [String] text - string to be colorized
      # @return [String] Colorized string
      #
      # colorize string in red
      def green(text); colorize(text, 32); end

      ##
      ## @return [String] string containing visualized matrix
      # vizualization of sparse matrix
      def show
        s = ""
        chlength = @triplets.map{ |t| t[2] }.max.to_s.length # length of max elem

        (0..@n-1).each do |i|
          s += 0x2551.chr('UTF-8') + "   "
          (0..@m-1).each do |j|
            elem = get_row(i)[j]
            helpelem = elem
            if elem != 0  #Colorize not null elems
              helpelem = green(elem)
            end
            s += helpelem.to_s + " " * (chlength-elem.to_s.length)
            s += "   "
          end
          s += 0x2551.chr('UTF-8') + "\n"
        end
        c = 3*(@m+1) + chlength*@m
        s = 0x2554.chr('UTF-8') + (0x2550.chr('UTF-8') * c)+ 0x2557.chr('UTF-8') +"\n" + s
        s += 0x255A.chr('UTF-8') + (0x2550.chr('UTF-8') * c) + 0x255D.chr('UTF-8') + "\n"
        s
      end
    end
  end
end
