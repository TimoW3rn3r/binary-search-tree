module Comparable
  def compare(node)
    if self.value > node.value
      1
    elsif self.value < node.value
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
end

class Tree
  attr_reader :root
  attr_accessor :array

  def initialize(array)
     @root = build_tree(array.uniq.sort)
  end

  def build_tree(array = @array)
    return nil if array.empty?

    length = array.size
    mid_element = array[length / 2]
    @root = Node.new(mid_element)
    @root.left_child = Tree.new(array[0...length / 2])
    @root.right_child = Tree.new(array[(length / 2 + 1)..-1])
    @root
  end
end

tree = Tree.new([5, 6, 2, 4, 1, 9, 0, 8, 5, 6, 4, 3])
require 'pry-byebug'
binding.pry
puts 'done'
