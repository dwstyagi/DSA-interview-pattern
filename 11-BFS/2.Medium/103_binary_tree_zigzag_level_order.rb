# frozen_string_literal: true

# LeetCode 103: Binary Tree Zigzag Level Order Traversal
#
# Problem:
# Given the root of a binary tree, return the zigzag level order traversal of
# its nodes' values (alternating left-to-right and right-to-left per level).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS level order, then reverse odd levels.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n) — no improvement needed, just toggle direction flag.
#
# 3. Optimized Accepted Approach
#    BFS with level counter. For even levels append left-to-right (normal),
#    for odd levels reverse the collected level before appending.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3 -> [9, 20] -> [15, 7]
# Level 0 (L→R): [3]
# Level 1 (R→L): [20, 9]
# Level 2 (L→R): [15, 7]
# result = [[3],[20,9],[15,7]] ✓
#
# Edge Cases:
# - Empty tree -> []
# - Single node -> [[val]]

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def zigzag_level_order_brute(root)
  return [] unless root
  result = []
  queue  = [root]
  left_to_right = true

  until queue.empty?
    level = []
    queue.size.times do
      node = queue.shift
      level << node.val
      queue << node.left  if node.left
      queue << node.right if node.right
    end
    result << (left_to_right ? level : level.reverse)
    left_to_right = !left_to_right
  end
  result
end

def zigzag_level_order(root)
  return [] unless root

  result        = []
  queue         = [root]
  left_to_right = true

  until queue.empty?
    level = []
    queue.size.times do
      node = queue.shift
      level << node.val
      queue << node.left  if node.left
      queue << node.right if node.right
    end
    result << (left_to_right ? level : level.reverse)  # toggle direction each level
    left_to_right = !left_to_right
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{zigzag_level_order_brute(root).inspect}"  # [[3],[20,9],[15,7]]
  puts "Opt:   #{zigzag_level_order(root).inspect}"         # [[3],[20,9],[15,7]]
end
