module Silicium
  module Sparse
    #addition for SparseMatrix class
    class SparseMatrix

      ##
      # @param [Integer] num - number of the returned line
      # @raise [ArgumentError] If number of row was less or bigger than count of cols
      # @return [Array] The array of elements of a row
      #
      # Returns a raw of sparse matrix elements
      def get_row(num)
        row = Array.new(@m, 0)
        @triplets.select {|x| x[0] == num }.each do |x|
          row[x[1]] = x[2]
        end
        row
      end

      ##
      # @param [SparseMatrix] matrix - second matrix for adding
      # @raise [ArgumentError] If the size of the first matrix doesn't match the size of the second matrix
      # @return [SparseMatrix] Matrix as the sum of the other two matrices
      #
      # Makes the sum of two matrix
      def adding(matrix)
        res = SparseMatrix.new(@n,@m)
        (0..@n).each { |i|
          help_row1 = get_row(i)
          help_row2 = matrix.get_row(i)
          res_row = Array.new(@m, 0)
          j = 0
          help_row1.each do |elem|
            res_row[j] = elem + help_row2[j]
            j = j + 1
          end
          k = 0
          res_row.each do |elem|
            if (elem != 0)
              res.add(i, k, elem)
            end
            k = k+1
          end
        }
        res
      end
    end
  end
end
