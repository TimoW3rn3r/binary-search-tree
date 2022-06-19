require './lib/binary_search_tree'

puts 'Create binary search tree'
tree = Tree.new(Array.new(15) { rand(1..100) })
puts tree

puts 'Confirm the tree is balanced'
puts "Tree is balanced?: #{tree.balanced?}"

puts 'Print out all elements in level, pre, post and in order'
print 'Level order: '
p tree.level_order
print 'Pre order: '
p tree.preorder
print 'In order: '
p tree.inorder
print 'Post order: '
p tree.postorder

puts 'Unbalance the tree'
10.times { tree.insert((rand * 200).to_i) }
puts tree

puts 'Confirm the tree is unbalanced'
puts "Tree is balanced?: #{tree.balanced?}"

puts 'Balance the tree'
tree.rebalance
puts tree

puts 'Confirm the tree is balanced'
puts "Tree is balanced?: #{tree.balanced?}"

puts 'Print out all elements in level, pre, post and in order'
print 'Level order: '
p tree.level_order
print 'Pre order: '
p tree.preorder
print 'In order: '
p tree.inorder
print 'Post order: '
p tree.postorder
