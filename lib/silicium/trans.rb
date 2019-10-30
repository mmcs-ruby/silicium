
module Silicium
  module Sparse
    #addition for SparseMatrix class
    class SparseMatrix

      #returns a transposed copy of matrix
      def transpose
        new = copy
        new.triplets.each do |triplet|
          triplet[0], triplet[1] = triplet[1], triplet[0]
        end
        new
      end

      #transposes matrix
      def transpose!
        self = transpose
      end


    end
  end
end

