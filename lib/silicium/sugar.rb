module Silicium
  module Sparse
    # addition for SparseMatrix class
    class SparseMatrix
      ##
      # @param [SparseMatrix] other - second matrix for adding
      # @raise [ArgumentError] If the size of the first matrix doesn't match the size of the second matrix
      # @return [SparseMatrix] Matrix as the sum of the other two matrices
      #
      # Makes the sum of two matrix
      def -(other)
        self + (other.mult_by_num(-1))
      end

      ##
      # @param [SparseMatrix::Object] other - A matrix to multiply to
      # @raise [ArgumentError] if count of columns of right matrix
      # doesn't match count of rows of left matrix
      #
      # Returns a matrix in its regular view but multiplied by other matrix
      def *(other)
        multiply(other)
      end

    end
  end
end
