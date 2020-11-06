module Silicium
  module Graphs

    class BST

      class Node
        @parent
        @left
        @right
        @data

        def initialize(pa, l, r, d)
          @left = l
          @right = r
          @parent = pa
          @data = d
        end

        def parent
          @parent
        end

        def parent=(parent)
          @parent = parent
        end

        def left
          @left
        end

        def left=(left)
          @left = left
        end

        def right
          @right
        end

        def right=(right)
          @right = right
        end

        def data
          @data
        end

      end


      @root
      @count

      def initialize
        @root = nil
        @count = 0
      end

      def root
        @root
      end

      def root=(root)
        @root = root
      end

      def add(elem)
        if (@root == nil)
          @root = Node.new(nil, nil, nil, elem)
          @count = @count + 1
          return
        else
          n = @root
          while (true)
            if (n.data > elem)
              if (n.left == nil)
                n.left = Node.new(n, nil, nil, elem)
                @count = @count + 1
                return
              else
                n = n.left
              end
            else
              if (n.right == nil)
                n.right = Node.new(n, nil, nil, elem)
                @count = @count + 1
                return
              else
                n = n.right
              end
            end
          end
        end
      end

      def search(elem)
        n = @root
        while (n != nil)
          if (n.data == elem)
            return n
          end
          if (n.data < elem)
            n = n.right
          else
            n = n.left
          end
        end
        return nil
      end

      def size
        return @count
      end

      def del_elem(elem)
        n = search(elem)
        if (n == nil)
          return
        end
        if(size == 1)
          @root=nil
          @count = 0
          return
        end
        tek = n.left;
        if (tek == nil)
          if (n.parent != nil)
            if (n.parent.right == n)
              n.parent.right = n.right
            end
            if (n.parent.left == n)
              n.parent.left = n.right
            end
          end
          if (n.right != nil)
            n.right.parent = n.parent
            if(n==root)
              @root=n.right
            end
          end
          @count = @count - 1
          return
        end
        if (tek.right == nil)
          if (n.parent != nil)
            if (n.parent.right == n)
              n.parent.right = tek
            end
            if (n.parent.left == n)
              n.parent.left = tek
            end
          end
          tek.parent = n.parent
          tek.right = n.right
          if (n.right != nil)
            n.right.parent = tek
          end
        else
          while (tek.right != nil)
            tek = tek.right
          end
          if (n.parent != nil)
            if (n.parent.right == n)
              n.parent.right = tek
            end
            if (n.parent.left == n)
              n.parent.left = tek
            end
          end
          tek.parent.right = tek.left
          if (tek.left != nil)
            tek.left.parent = tek.parent
          end
          if (n.left != nil)
            n.left.parent = tek
          end
          tek.parent = n.parent
          tek.right = n.right
          tek.left = n.left
          if (n.right != nil)
            n.right.parent = tek
          end
        end
        if (n == @root)
          @root = tek
        end
        @count = @count - 1
      end
    end
  end
end