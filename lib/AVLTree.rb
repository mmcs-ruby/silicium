class AvlTree
  class Node
    attr_accessor :left, :right, :parent, :data, :is_dummy, :height

    def initialize(d, l = nil , r = nil, p = nil)
      @data = d
      @right = r
      @left = l
      @parent = p
      @is_dummy = false
      @height = 1
    end

    def get_height
      if is_dummy
        return 0
      end
      @height
    end

    def set_height(dummy)
      unless @left.eql? dummy
        @left.set_height dummy
      end

      unless @right.eql? dummy
        @right.set_height dummy
      end

      @height = [@left.get_height, @right.get_height].max + 1
    end
  end

  attr_accessor :dummy, :tree_size

  def make_dummy
    @dummy = Node.new 0

    @dummy.is_dummy = true
    @dummy.right = @dummy
    @dummy.left = @dummy
    @dummy.parent = @dummy
  end

  def initialize(node_list = null)
    @dummy = make_dummy
    @tree_size = node_list.nil? ? 0 : node_list.size

    node_list.each {|node| insert_value node}

  end

  #small right turn
  def turn_right(node_y)
    node_x = node_y.left
    node_y.left = node_x.right

    unless node_x.right.eql? @dummy
      node_x.right.parent = node_y
    end

    node_x.right = node_y
    node_x.parent = node_y.parent

    if !node_y.parent.eql? dummy

      if node_y.parent.left.eql? node_y
        node_y.parent.left = node_x
      else
        node_y.parent.right = node_x
      end

    else
      @dummy.parent = node_y
    end

    node_y.parent = node_x
    node_x.set_height @dummy
    node_y.set_height @dummy
    node_x
  end

  #small left turn
  def turn_left(node_x)
    node_y = node_x.right
    node_x.right = node_y.left

    unless node_y.left.eql? @dummy
      node_y.left.parent = node_x
    end

    node_y.left = node_x
    node_y.parent = node_x.parent

    if !node_x.parent.eql? dummy

      if node_x.parent.left.eql? node_x
        node_x.parent.left = node_y
      else
        node_x.parent.right = node_y
      end

    else
      @dummy.parent = node_y
    end

    node_x.parent = node_y
    node_x.set_height @dummy
    node_y.set_height @dummy
    node_y
  end

  def get_balance_factor(node)

    unless node.eql? dummy
      return node.left.get_height - node.right.get_height
    end

    0
  end

  def balance(node)
    #Big left turn
    if (get_balance_factor node) == 2

      if (get_balance_factor node.left) < 0
        node.left = turn_left node.left
      end

      return turn_right node
    end
    #Big right turn
    if (get_balance_factor node) == -2

      if (get_balance_factor node.right) > 0
        node.right = turn_right node.right
      end

      turn_left node
    end
  end

  def insert_value(value)
    prev = @dummy
    current = @dummy.parent

    until current.eql? @dummy
      prev = current

      if value < current.data
        current = current.left
        next
      else
        current = current.right
        next
      end
    end
    new_node = Node.new value, @dummy, @dummy, prev
    @tree_size += 1

    if prev.eql? @dummy
      @dummy.parent = new_node
      @dummy.left = new_node
      @dummy.right = new_node

    else if value < prev.data
           prev.left = new_node

           if @dummy.left.eql? prev
             @dummy.left = new_node
           end

         else
           prev.right = new_node

           if @dummy.right.eql? prev
             @dummy.right = new_node
           end
         end
    end

    root = new_node
    until root.eql? @dummy
      root.set_height(@dummy)

      if (get_balance_factor root).abs > 1
        balance root
      end

      root = root.parent
    end
    new_node
  end

  def print_node(current, width = 0)
    spaces = ''

    (0..width).each do
      spaces += "  "
    end
    if current.eql? @dummy
      puts "#{spaces}Dummy\n"
      return
    end

    print_node current.right, width + 5
    puts "#{spaces} #{current.data}\n"
    print_node current.left, width + 5
  end

  def print_tree
    print_node @dummy.parent
    puts "********************************************************\n"
  end
end

my_tree = AvlTree.new([2, 3])
my_tree.insert_value 4
my_tree.insert_value 6
my_tree.insert_value 13
my_tree.insert_value 8
my_tree.insert_value 4
my_tree.print_tree


