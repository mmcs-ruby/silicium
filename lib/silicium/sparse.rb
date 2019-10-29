# here goes the Sparse class
module Silicium
  module Sparse
    class SparseMatrix
      attr_reader :triplets

      def initialize(rows, cols)
        @n = rows
        @m = cols
        @triplets = []
      end

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

      def get(i, j)
        triplets.each do |triplet|
          if triplet[0] == i && triplet[1] == j
            return triplet[2]
          end
        end
        return 0
      end
    end
  end
end