require 'matrix'

module Silicium
  # Matrix with fast implementations of + - * determinate in C
  class Matrix
    #
    # Create fast matrix from standard matrix
    #
    def self.convert(matrix)
      fast_matrix = Matrix.new(matrix.row_size, matrix.column_size)
      (0...matrix.row_size).each do |i|
        (0...matrix.column_size).each do |j|
          fast_matrix[i, j] = matrix[i, j]
        end
      end
      fast_matrix
    end

    def each_with_indexes
      (0...column_size).each do |i|
        (0...row_size).each do |j|
          yield self[i, j], i, j
        end
      end
    end

    def each_with_indexes!
      (0...column_size).each do |i|
        (0...row_size).each do |j|
          self[i, j] = yield self[i, j], i, j
        end
      end
      self
    end

    #
    # Convert to standard ruby matrix.
    #
    def convert
      ::Matrix.build(row_size, column_size) { |i, j| self[i, j] }
    end

    #
    # Creates a matrix where each argument is a row.
    #   Matrix[ [25, 93], [-1, 66] ]
    #      =>  25 93
    #          -1 66
    #
    def self.[](*rows)
      columns_count = rows[0].size
      rows_count = rows.size
      matrix = Matrix.new(rows_count, columns_count)
      matrix.each_with_indexes! { |_, i, j| rows[i][j] }
      matrix
    end

    #
    # Creates a single-column matrix where the values of that column are as given
    # in +column+.
    #   Matrix.column_vector([4,5,6])
    #     => 4
    #        5
    #        6
    #
    def self.column_vector(column)
      matrix = Matrix.new(column.size, 1)
      column.each_with_index { |elem, i| matrix[i, 0] = elem }
      matrix
    end

    #
    # Creates a single-row matrix where the values of that row are as given in
    # +row+.
    #   Matrix.row_vector([4,5,6])
    #     => 4 5 6
    #
    def self.row_vector(row)
      matrix = Matrix.new(1, row.size)
      row.each_with_index { |elem, j| matrix[0, j] = elem }
      matrix
    end

    #
    # Creates a matrix where the diagonal elements are composed of +values+.
    #   Matrix.diagonal(9, 5, -3)
    #     =>  9  0  0
    #         0  5  0
    #         0  0 -3
    #
    def self.diagonal(*values)
      matrix = Matrix.new(values.size, values.size)
      matrix.each_with_indexes! { |_, i, j| i == j ? values[i] : 0 }
      matrix
    end

    #
    # Creates an +n+ by +n+ diagonal matrix where each diagonal element is
    # +value+.
    #   Matrix.scalar(2, 5)
    #     => 5 0
    #        0 5
    #
    def self.scalar(n, value)
      matrix = Matrix.new(n, n)
      matrix.each_with_indexes! { |_, i, j| i == j ? value : 0 }
      matrix
    end

    #
    # Creates an +n+ by +n+ identity matrix.
    #   Matrix.identity(2)
    #     => 1 0
    #        0 1
    #
    def self.identity(n)
      scalar(n, 1)
    end

    #
    # Creates a zero matrix +n+ by +n+.
    #   Matrix.zero(2)
    #     => 0 0
    #        0 0
    #
    def self.zero(n)
      matrix = Matrix.new(n, n)
      matrix.each_with_indexes! { |_, _, _| 0 }
      matrix
    end

    # FIXME for compare with standard matrix
    def ==(other)
      # TODO check class and use fast compare from C if possibly
      return false unless %i[row_size column_size \[\]].all? { |x| other.respond_to? x }
      return false unless self.row_size == other.row_size && self.column_size == other.column_size

      result = true
      each_with_indexes do |elem, i, j|
        result &&= elem == other[i, j].to_f
      end
      result
    end
  end
end
