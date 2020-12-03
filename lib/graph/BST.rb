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
      #--------------------------------------Add----------------------------
      private def support_Left_Add(n,elem)
        create_Left_Node(n,elem)
        false
      end

      private def support_Right_Add(n,elem)
        create_Right_Node(n,elem)
        false
      end

      private def create_Root_Node(elem)
        @root = Node.new(nil, nil, nil, elem)
        @count = @count + 1
      end

      private def create_Left_Node(n,elem)
        n.left = Node.new(n, nil, nil, elem)
        @count = @count + 1
      end

      private def create_Right_Node(n,elem)
        n.right = Node.new(n, nil, nil, elem)
        @count = @count + 1
      end

      def help_Add(elem)
        n = @root
        flag = true
        while (flag)
          n.data > elem ? flag = n.left == nil ? support_Left_Add(n,elem) : n = n.left : flag = n.right == nil ? support_Right_Add(n,elem) : n = n.right
        end
      end

      def add(elem)
        @root == nil ? create_Root_Node(elem) : help_Add(elem)
      end

      #-------------------------------------------------------------------------

      def search(elem)
        n = @root
        while (n != nil)
          if (n.data == elem)
            return n
          end
          n.data < elem ? n = n.right : n = n.left
        end
        return nil
      end

      def size
        return @count
      end

      #-----------------del_elem-----------------------------------------------

      private def help_Parent_Right(n,tek)
        if (n.parent.right == n)
          n.parent.right = tek
        end
      end

      private def help_Parent_Left(n,tek)
        if (n.parent.left == n)
          n.parent.left = tek
        end
      end

      private def help_Parent_Left_For_Right_Node(n)
        if (n.parent.left == n)
          n.parent.left = n.right
        end
      end

      private def help_Parent_Right_For_Right_Node(n)
        if (n.parent.right == n)
          n.parent.right = n.right
        end
      end

      private def not_Nil_Right_Node(n,tek)
        if (n.right != nil)
          n.right.parent = tek
        end
      end

      private def work_With_Parent_Right_Left_Node(n)
        if (n.parent != nil)
          help_Parent_Right_For_Right_Node(n)
          help_Parent_Left_For_Right_Node(n)
        end
      end

      private def not_Parent_Nil(n,tek)
        if (n.parent != nil)
          help_Parent_Right(n,tek)
          help_Parent_Left(n,tek)
        end
      end

      private def help_work_if_tek_is_nil(n)
        n.right.parent = n.parent
        if(n==root)
          @root=n.right
        end
      end

      private def work_if_tek_is_nil(n)
        work_With_Parent_Right_Left_Node(n)
        if (n.right != nil)
          help_work_if_tek_is_nil(n)
        end
        @count = @count - 1
      end

      private def set_Root_Default
        @root=nil
        @count = 0
      end

      private def work_if_tek_right_is_nil(n,tek)
        not_Parent_Nil(n,tek)
        assign_Parent_and_Right_nodes(n,tek)
        not_Nil_Right_Node(n,tek)
      end

      private def work_With_left(n,tek)
        if (tek.left != nil)
          tek.left.parent = tek.parent
        end
        if (n.left != nil)
          n.left.parent = tek
        end
      end

      private def final_work_of_del(n,tek)
        if (n == @root)
          @root = tek
        end
        @count = @count - 1
      end

      private def assign_Parent_and_Right_nodes(n,tek)
        tek.parent = n.parent
        tek.right = n.right
      end

      private def assign_Parent_and_Right_and_Left_nodes(n,tek)
        assign_Parent_and_Right_nodes(n,tek)
        tek.left = n.left
      end

      private def work_if_right_is_not_nil(n,tek)
        if (n.right != nil)
          n.right.parent = tek
        end
      end

      private def else_Part2(n,tek)
        not_Parent_Nil(n,tek)
        tek.parent.right = tek.left
        work_With_left(n,tek)
        assign_Parent_and_Right_and_Left_nodes(n,tek)
        work_if_right_is_not_nil(n,tek)
      end

      private def set_Root_Default
        @root=nil
        @count = 0
      end

      def del_elem(elem)
        n = search(elem)
        if (n == nil)
          return
        end
        if(size == 1)
          set_Root_Default
          return
        end
        tek = n.left;
        if (tek == nil)
          work_if_tek_is_nil(n)
          return
        end
        if (tek.right == nil)
          work_if_tek_right_is_nil(n,tek)
        else
          while (tek.right != nil)
            tek = tek.right
          end
          else_Part2(n,tek)
        end
        final_work_of_del(n,tek)
      end
    end
  end
end