module Comparable
  def compare(node)
    if node.value > value
      1
    elsif node.value < value
      -1
    else
      0
    end
  end
end

class Node
  include Comparable
  attr_accessor :left_child, :right_child
  attr_reader :value

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
  attr_accessor :array

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    length = array.size
    mid_element = array[length / 2]
    node = Node.new(mid_element)
    node.left_child = build_tree(array[0...length / 2])
    node.right_child = build_tree(array[(length / 2 + 1)..-1])
    node
  end

  def insert(value)
    new_node = Node.new(value)
    cursor = @root
    loop do
      case cursor.compare(new_node)
      when 1
        if cursor.right_child.nil?
          cursor.right_child = new_node
          break
        else
          cursor = cursor.right_child
        end
      when -1
        if cursor.left_child.nil?
          cursor.left_child = new_node
          break
        else
          cursor = cursor.left_child
        end
      else
        return puts 'Number already in the tree'
      end
    end
  end

  def search_for(value)
    node = @root
    previous_node = @root
    child = :left
    loop do
      case node.value <=> value
      when 1
        previous_node = node
        child = :left
        node = node.left_child
      when -1
        previous_node = node
        child = :right
        node = node.right_child
      else
        break
      end
    end
    [node, previous_node, child]
  end

  def delete(value)
    node, previous_node, child = search_for(value)
    if node.leaf?
      delete_leaf_node(previous_node, child)
    elsif node.single_child?
      delete_single_child_node(node, previous_node, child)
    else
      puts 'double child case'
    end
  end

  def delete_leaf_node(previous_node, child)
    case child
    when :left
      previous_node.left_child = nil
    when :right
      previous_node.right_child = nil
    end
  end

  def delete_single_child_node(node, previous_node, child)
    case child
    when :left
      previous_node.left_child = node.left_child || node.right_child
    when :right
      previous_node.right_child = node.left_child || node.right_child
    end
  end

  def to_s(node = @root, prefix = '', is_left = true)
    to_s(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    to_s(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

end

tree = Tree.new([5, 6, 2, 4, 1, 9, 0, 8, 5, 6, 4, 3])
require 'pry-byebug'
binding.pry
tree.insert(3.5)
tree.delete(9)
tree.to_s
puts 'done'
