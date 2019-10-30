module Silicium
  require_relative 'trans'

  # here goes the sparse module
  module Sparse

    # here goes the Sparse class
    class SparseMatrix
      attr_reader :triplets

      # Initialize matrix with count of rows and columns
      def initialize(rows, cols)
        @n = rows
        @m = cols
        @triplets = []
      end

      # Creates a copy of matrix object
      def copy
        new = SparseMatrix.new(@n, @m)
        triplets.each do |triplet|
          new.add(triplet[0], triplet[1], triplet[2])
        end
        new
      end

      # Adds an element to matrix by its position and value
      def add(i, j, x)
        if i > @n || j > @m || i < 0 || j < 0
          raise RuntimeError, "out of range"
        end
        f = false
        @triplets.each do |item|
          if item[0] == i && item[1] == j
            item = [i, j, x]
            f =  true
            break
          end
        end
        @triplets.push([i, j, x]) unless f
      end

      # Gets the element by its position
      def get(i, j)
        triplets.each do |triplet|
          if triplet[0] == i && triplet[1] == j
            return triplet[2]
          end
        end
        0
      end
    end
  end
end