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
        raise 'wrong argument' if pos.negative? || pos > @m

        row = Array.new(@m, 0)
        @triplets.select { |x| x[0] == pos }.each do |x|
          row[x[1]] = x[2]
        end
        row
      end

      ##
      # @param [Integer] pos - Position of a column to return
      # @raise [ArgumentError] if position was less or bigger than count of rows
      # @return [Array] The array that contains elements of column
      #
      # Returns a column of sparse matrix by its position
      def get_col(pos)
        raise 'wrong argument' if pos.negative? || pos > @m

        row = Array.new(@n, 0)
        @triplets.select { |x| x[1] == pos }.each do |x|
          row[x[0]] = x[2]
        end
        row
      end

      ##
      # @return [Array] The array that contains rows of matrix
      # Returns sparse matrix in its regular view
      def regular_view
        i = 0
        rows = Array.new(@n)
        rows.count.times do
          rows[i] = get_row(i)
          i += 1
        end
        rows
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
        i = 0
        temp = Array.new(@n).map { |x| x = [] }
        while i < @n
          jj = 0
          while jj < matrix.m
            ii = 0
            mul = 0
            col = matrix.get_col(jj)
            while ii < col.count
              unless rows[i][ii].zero? || col[ii].zero?
                mul += rows[i][ii] * col[ii]
              end
              ii += 1
            end
            temp[i].push(mul)
            jj += 1
          end
          i += 1
        end
        temp
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
    end
  end
end
