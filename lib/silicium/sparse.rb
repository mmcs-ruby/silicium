module Silicium
  require_relative 'sugar'
  require_relative 'conversions'
  require_relative 'trans'
  require_relative 'adding'
  require_relative 'multi'
  require_relative 'visualization'

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

        if elem == 0
          set_to_zero(i_pos, j_pos)
          return []
        end

        new_triplet = [i_pos, j_pos, elem]
        triplet_ind = 0

        @triplets.each do |triplet|
          if i_pos < triplet[0]
            @triplets.insert(triplet_ind, new_triplet)
            return
          elsif i_pos == triplet[0]
            if j_pos == triplet[1]
              triplet = new_triplet
              return new_triplet
            elsif j_pos < triplet[1]
              @triplets.insert(triplet_ind, new_triplet)
              return new_triplet
            end
          end
          triplet_ind += 1
        end
        @triplets.push([i_pos, j_pos, elem])
      end

      ##
      # @param [Integer] i_pos - The i position of an element
      # @param [Integer] j_pos - The j position of an element
      # @return [Boolean] true - triplet was found and deleted, false - otherwise
      #
      # Sets an element to zero by its position (removes triplet)
      def set_to_zero(i_pos, j_pos)
        if i_pos > @n || j_pos > @m || i_pos.negative? || j_pos.negative?
          raise 'out of range'
        end

        triplet_ind = 0
        @triplets.each do |triplet|
          return false if triplet[0] > i_pos

          if triplet[0] == i_pos
            if triplet[1] == j_pos
              @triplets.delete_at(triplet_ind)
              return true
            elsif triplet[1] > j_pos
              return false
            end
          end
          triplet_ind += 1
        end
        return false
      end

      ##
      # @param [Integer] i_pos - The i position of an element
      # @param [Integer] j_pos - The j position of an element
      # @return [Integer] The element on i,j position
      #
      # Returns an element by its position
      def get(i_pos, j_pos)
        triplets.each do |triplet|
          next if i_pos > triplet[0]
          if i_pos == triplet[0]
            if j_pos == triplet[1]
              return triplet[2]
            elsif j_pos < triplet[1]
              return 0
            end
          else
            return 0
          end
        end
        return 0
      end
    end
  end
end
