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
    left_child.nil? || right_child.nil?
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
          cursor.left_clild = new_node
          break
        else 
          cursor = cursor.left_child
        end
      else
        return 'Number already in the tree'
      end

    end
  end
end

tree = Tree.new([5, 6, 2, 4, 1, 9, 0, 8, 5, 6, 4, 3])
require 'pry-byebug'
binding.pry
tree.insert(3.5)
puts 'done'
