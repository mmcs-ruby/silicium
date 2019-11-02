module Silicium
  require_relative 'trans'
  require_relative 'multi'
  # here goes the sparse module
  module Sparse
    # here goes the Sparse class
    class SparseMatrix
      attr_reader :triplets
      attr_reader :n
      attr_reader :m
      ##
      # @param [Integer] rows - Count of rows
      # @param [Integer] cols - Count of columns
      #
      # Initialize matrix with count of rows and columns
      def initialize(rows, cols)
        @n = rows
        @m = cols
        @triplets = []
      end

      ##
      # @return [SparseMatrix::Object] - Returns a copy of a SparseMatrix object
      #
      # Creates a copy of matrix object
      def copy
        new = SparseMatrix.new(@n, @m)
        triplets.each do |triplet|
          new.add(triplet[0], triplet[1], triplet[2])
        end
        new
      end

      ##
      # @param [Integer] i_pos - The i position of an element
      # @param [Integer] j_pos - The j position of an element
      # @param [Integer] elem - The value of an element to be added
      #
      # Adds an element to matrix by its position and value
      def add(i_pos, j_pos, elem)
        if i_pos > @n || j_pos > @m || i_pos.negative? || j_pos.negative?
          raise 'out of range'
        end

        f = false
        @triplets.each do |item|
          if item[0] == i_pos && item[1] == j_pos
            item = [i_pos, j_pos, elem]
            f =  true
            break
          end
        end
        @triplets.push([i_pos, j_pos, elem]) unless f
      end

      ##
      # @param [Integer] i_pos - The i position of an element
      # @param [Integer] j_pos - The j position of an element
      # @return [Integer] The element on i,j position
      #
      # Returns an element by its position
      def get(i_pos, j_pos)
        triplets.each do |triplet|
          if triplet[0] == i_pos && triplet[1] == j_pos
            return triplet[2]
          end
        end
        0
      end
    end
  end
end
