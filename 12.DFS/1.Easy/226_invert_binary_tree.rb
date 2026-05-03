# frozen_string_literal: true

# LeetCode 226: Invert Binary Tree
#
# Problem:
# Given the root of a binary tree, invert the tree (mirror it), and return its root.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS iteratively, swap left and right children of every node.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Same complexity — DFS is more concise recursively.
#
# 3. Optimized Accepted Approach
#    DFS (pre-order): swap children, then recurse into each child.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 4->[2,7]->[1,3,6,9]
# invert(4): swap 2↔7 → 4->[7,2]; recurse invert(7), invert(2)
# invert(7): swap 6↔9; invert(2): swap 1↔3
# result: 4->[7,2]->[9,6,3,1] ✓
#
# Edge Cases:
# - Empty tree -> nil
# - Single node -> same node
# - Already mirrored (symmetric) -> still correct

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def invert_tree_brute(root)
  return nil unless root
  queue = [root]
  until queue.empty?
    node = queue.shift
    node.left, node.right = node.right, node.left
    queue << node.left  if node.left
    queue << node.right if node.right
  end
  root
end

def invert_tree(root)
  return nil unless root
  root.left, root.right = invert_tree(root.right), invert_tree(root.left) # swap + recurse
  root
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(4, TreeNode.new(2, TreeNode.new(1), TreeNode.new(3)), TreeNode.new(7, TreeNode.new(6), TreeNode.new(9)))
  invert_tree(root)
  puts "Opt root: #{root.val}, left: #{root.left.val}, right: #{root.right.val}"  # 4, 7, 2
end
