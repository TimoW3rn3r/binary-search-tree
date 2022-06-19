module Comparable
  def compare(node)
    node.value <=> value
  end
end

class Node
  include Comparable
  attr_accessor :left_child, :right_child, :value

  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
  end

  def leaf?
    left_child.nil? && right_child.nil?
  end

  def single_child?
    !leaf? && (left_child.nil? || right_child.nil?)
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    length = array.size
    mid_element = array[length / 2]
    node = Node.new(mid_element)
    node.left_child = build_tree(array[0...length / 2])
    node.right_child = build_tree(array[(length / 2 + 1)..])
    node
  end

  def insert(value, node = @root)
    return nil if node.value == value

    if value < node.value
      node.left_child.nil? ? node.left_child = Node.new(value) : insert(value, node.left_child)
    else
      node.right_child.nil? ? node.right_child = Node.new(value) : insert(value, node.right_child)
    end
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.value
      node.left_child = delete(value, node.left_child)
    elsif value > node.value
      node.right_child = delete(value, node.right_child)
    else
      if node == root
        return @root = node.right_child if node.left_child.nil?

        return @root = node.left_child if node.right_child.nil?
      end
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      leftmost_node = leftmost_leaf(node.right_child)
      node.value = leftmost_node.value
      node.right_child = delete(leftmost_node.value, node.right_child)
    end
    node
  end

  def leftmost_leaf(node)
    node = node.left_child until node.left_child.nil?
    puts "leftmost is #{node.value}"
    node
  end

  def find(value, node = root)
    return node if node.nil? || node.value == value

    value < node.value ? find(value, node.left_child) : find(value, node.right_child)
  end

  def level_order
    values = []
    queue = [root]
    until queue.empty?
      shifted = queue.shift
      values << shifted.value
      yield shifted if block_given?
      queue << shifted.left_child unless shifted.left_child.nil?
      queue << shifted.right_child unless shifted.right_child.nil?
    end
    block_given? ? nil : values
  end

  def level_order_rec(queue = [root], values = [], &block)
    return if queue.empty?

    shifted = queue.shift
    values << shifted.value
    block.call(shifted) if block_given?
    queue << shifted.left_child unless shifted.left_child.nil?
    queue << shifted.right_child unless shifted.right_child.nil?
    level_order_rec(queue, values, &block)
    values unless block_given?
  end

  def preorder(node = root, values = [], &block)
    return unless node

    values.append(node.value)
    block.call(node) if block_given?
    preorder(node.left_child, values, &block)
    preorder(node.right_child, values, &block)

    values unless block_given?
  end

  def inorder(node = root, values = [], &block)
    return unless node

    inorder(node.left_child, values, &block)
    values.append(node.value)
    block.call(node) if block_given?
    inorder(node.right_child, values, &block)

    values unless block_given?
  end

  def postorder(node = root, values = [], &block)
    return unless node

    postorder(node.left_child, values, &block)
    postorder(node.right_child, values, &block)
    values.append(node.value)
    block.call(node) if block_given?

    values unless block_given?
  end

  def height(node)
    return 0 if node.nil? || node.leaf?

    [1 + height(node.left_child), 1 + height(node.right_child)].max
  end

  def depth(node, cursor = root)
    return 0 if cursor.nil? || node == cursor

    1 + (cursor.compare(node).positive? ? depth(node, cursor.right_child) : depth(node, cursor.left_child))
  end

  def balanced?
    level_order do |node|
      return false if height(node.left_child) - height(node.right_child) > 1
    end
    true
  end

  def rebalance
    @root = build_tree(level_order.sort)
  end

  def to_s(node = @root, prefix = '', is_left = true)
    to_s(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    to_s(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
