module Silicium
  module Sparse
    # addition for SparseMatrix class
    class SparseMatrix

      def help_func(array_dest, array_src, start)
        (start..array_src.length - 1).each do |i|
          array_dest.push(array_src[i])
        end
      end

      ##
      # @param [SparseMatrix] matrix - second matrix for adding
      # @raise [ArgumentError] If the size of the first matrix doesn't
      # match the size of the second matrix
      # @return [SparseMatrix] Matrix as the sum of the other two matrices
      #
      # Makes the sum of two matrix
      def +(other)
        raise 'wrong argument' if @n != other.m

        res = SparseMatrix.new(@n, @m)
        triplets_1 = self.triplets
        triplets_2 = other.triplets

        tr_ind_1 = 0 # triplet index for first matrix (self)
        tr_ind_2 = 0 # triplet index for second matrix (matrix)

        while true
          if    tr_ind_1 == triplets_1.length
            help_func(res.triplets, triplets_2, tr_ind_2)
            return res
          elsif tr_ind_2 == triplets_2.length
            help_func(res.triplets, triplets_1, tr_ind_1)
            return res
          end

          r_1 = triplets_1[tr_ind_1][0]
          r_2 = triplets_2[tr_ind_2][0]

          c_1 = triplets_1[tr_ind_1][1]
          c_2 = triplets_2[tr_ind_2][1]

          v_1 = triplets_1[tr_ind_1][2]
          v_2 = triplets_2[tr_ind_2][2]

          if    r_1 < r_2
            res.triplets.push(triplets_1[tr_ind_1])
            tr_ind_1 += 1
          elsif r_1 == r_2
            if    c_1 < c_2
              res.triplets.push(triplets_1[tr_ind_1])
              tr_ind_1 += 1
            elsif c_1 > c_2
              res.triplets.push(triplets_2[tr_ind_2])
              tr_ind_2 += 1
            else
              res.triplets.push([r_1, c_1, v_1 + v_2]) unless v_1 + v_2 == 0
              tr_ind_1 += 1
              tr_ind_2 += 1
            end
          else
            res.triplets.push(triplets_2[tr_ind_2])
            tr_ind_2 += 1
          end
        end
      end

    end
  end
end
