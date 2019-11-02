module Silicium
  module Sparse
    # here goes tha addition to SparseMatrix class
    class SparseMatrix
      ##
      # Returns a transposed copy of matrix
      def transpose
        new = copy
        new.triplets.each do |triplet|
          triplet[0], triplet[1] = triplet[1], triplet[0]
        end
        new
      end

      ##
      # Transposes matrix
      def transpose!
        triplets.each do |triplet|
          triplet[0], triplet[1] = triplet[1], triplet[0]
        end
      end
    end
  end
end


