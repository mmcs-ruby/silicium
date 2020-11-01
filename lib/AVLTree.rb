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

  def initialize(node_list = nil)
    @dummy = make_dummy
    @tree_size = 0

    unless node_list.nil?
      node_list.each { |node| insert_value node }

    end

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

    if !(node_y.parent.eql? @dummy)

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

    if !(node_x.parent.eql? @dummy)

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

    unless node.eql? @dummy
      return node.left.get_height - node.right.get_height
    end

    0
  end

  def big_right_turn(node)
    if get_balance_factor(node.right) > 0
      node.right = turn_right node.right
    end

    return turn_left node
  end

  def big_left_turn(node)
    if get_balance_factor(node.left) < 0
      node.left = turn_left node.left
    end

    return turn_right node
  end

  def balance(node)
    #Big left turn
    if get_balance_factor(node) == 2
      big_left_turn(node)
    end
    #Big right turn
    if get_balance_factor(node) == -2
      big_right_turn(node)
    end

    node
  end

  def find_place(value)
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

    prev
  end

  def balance_inserted(new_node)
    root = new_node
    until root.eql? @dummy
      root.set_height(@dummy)

      if (get_balance_factor root).abs > 1
        balance root
      end

      root = root.parent
    end
  end

  def insert_value(value)
    prev = find_place value

    new_node = Node.new value, @dummy, @dummy, prev
    @tree_size += 1

    if prev.eql? @dummy
      @dummy.parent = new_node
      @dummy.left = new_node
      @dummy.right = new_node

    else
      if value < prev.data
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
    balance_inserted(new_node)

    new_node
  end

  def find(value)
    current = @dummy.parent
    until current.eql? @dummy

      if value < current.data
        current = current.left
        next
      else if current.data < value
        current = current.right
        next
        end
      end

      break
    end

    if current.eql? @dummy
      return nil
    end
    current
  end

  def get_max(node)
    temp_max = node
    unless temp_max.eql? @dummy
      until temp_max.right.eql? @dummy
        temp_max = temp_max.right
      end
    end

    temp_max
  end

  def get_min(node)
    temp_min = node
    unless temp_min.eql? @dummy
      until temp_min.right.eql? @dummy
        temp_min = temp_min.right
      end
    end

    temp_min
  end

  def delete_right_sub(elem)
    if elem.parent.eql? @dummy
      @dummy.parent = elem.right
      elem.right.parent = @dummy
      @dummy.left = get_min(elem.right)

    else
      elem.right.parent = elem.parent
      if elem.parent.right.eql? elem
        elem.parent.right = elem.right

      else
        elem.parent.left = elem.right
        if elem.eql? @dummy.left
          @dummy.left = get_min(elem.right)
        end
      end
    end
  end

  def delete_left_sub(elem)
    if elem.parent.eql? @dummy
      @dummy.parent = elem.left
      elem.left.parent = @dummy
      @dummy.right = get_max(elem.left)

    else
      elem.left.parent = elem.parent
      if elem.parent.right.eql? elem
        elem.parent.right = elem.left

        if elem.eql? @dummy.right
          @dummy.right = get_max(elem.left)
        end

      else
        elem.parent.left = elem.left
      end
    end
  end

  def delete_list(elem)
    parent = elem.parent
    if !parent.eql? dummy
      if parent.left == elem
        parent.left = @dummy
      else
        parent.right = @dummy
      end
    else
      @dummy.parent = @dummy
      @dummy.left = @dummy
      @dummy.right = @dummy
    end
  end

  def balance_deleted(balpoint)
    until balpoint.eql? dummy
      balpoint.set_height(@dummy)
      if (get_balance_factor balpoint).abs > 1
        if balpoint.parent.eql? @dummy
          @dummy.parent = balance(balpoint)
        else
          balance(balpoint)
        end
      end

      balpoint = balpoint.parent
    end
  end

  def delete(value)
    elem = find(value)
    if elem.nil?
      return nil
    end
    balpoint = elem.parent
    #elem is list
    if elem.right.eql? @dummy and elem.left.eql? @dummy
      delete_list(elem)
    else
      #elem not list with left subtree
      if elem.right.eql? @dummy
        delete_left_sub(elem)
      else
        #elem not list with right subtree
        if elem.left.eql? @dummy
          delete_right_sub(elem)
        end
      end
    end

    @tree_size -= 1
    balance_deleted(balpoint)
    elem
  end

  #def print_node(current, width = 0)
  #spaces = ''

  #(0..width).each do
  # spaces += "  "
  #end
  #if current.eql? @dummy
  #  puts "#{spaces}Dummy\n"
  # return
  #end

  #print_node current.right, width + 5
  # puts "#{spaces} #{current.data}\n"
  #print_node current.left, width + 5
  #end

  #def print_tree
  #print_node @dummy.parent
  #puts "********************************************************\n"
  #end
end





