module Silicium
  module Sparse
    # here goes tha addition to SparseMatrix class
    class SparseMatrix
      ##
      # @param [Integer] pos - Position of a row to return
      # @raise [ArgumentError] if position was less or bigger than count of cols
      # @return [Array] The array contains elements of row
      #
      # Returns a row of sparse matrix by its position
      def get_row(pos)
        get_dimension({dimension: 0, position: 1}, pos)
      end

      ##
      # @param [Integer] pos - Position of a column to return
      # @raise [ArgumentError] if position was less or bigger than count of rows
      # @return [Array] The array that contains elements of column
      #
      # Returns a column of sparse matrix by its position
      def get_col(pos)
        get_dimension({dimension: 1, position: 0}, pos)
      end

      ##
      # @return [Array] The array that contains rows of matrix
      # Returns sparse matrix in its regular view
      def regular_view
        Array.new(@n) { |i| get_row(i) }
      end

      ##
      # @param [SparseMatrix::Object] matrix - A matrix to multiply to
      # @raise [ArgumentError] if count of columns of right matrix
      # doesn't match count of rows of left matrix
      #
      # Returns a matrix in its regular view but multiplied by other matrix
      def multiply(matrix)
        raise 'wrong argument' if @n != matrix.m

        rows = regular_view
        result = Array.new(@n) { Array.new }
        (0...@n).each { |i|
          (0...matrix.m).each { |j|
            result[i] << matrix
                             .get_col(j)
                             .zip(rows[i])
                             .inject(0) { |acc, current| acc + current[0] * current[1] }
          }
        }
        result
      end

      ##
      # @param [Integer] num - A number to multiply to
      #
      # Multiplies matrix by a number
      def mult_by_num(num)
        return SparseMatrix.new(@n, @m) if num.zero?

        res = copy
        res.triplets.each do |triplet|
          triplet[2] *= num
        end
        res
      end

      private

      def get_dimension(selector, pos)
        raise 'wrong argument' if pos.negative? || pos > @m

        result = Array.new(@m, 0)
        @triplets
            .select { |triplet| triplet[selector[:dimension]] == pos }
            .each { |triplet| result[triplet[selector[:position]]] = triplet[2] }
        result
      end

    end
  end
end
