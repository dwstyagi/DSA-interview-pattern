# frozen_string_literal: true

# LeetCode 98: Validate Binary Search Tree
#
# Problem:
# Given the root of a binary tree, determine if it is a valid BST.
# A valid BST: left subtree < node < right subtree (strictly), recursively.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    In-order traversal should produce strictly increasing sequence. Collect and check.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Collecting all values — pass min/max bounds during DFS to avoid extra array.
#
# 3. Optimized Accepted Approach
#    DFS with valid range [min, max]. Root starts with (-INF, +INF).
#    Left child: range becomes [min, node.val].
#    Right child: range becomes [node.val, max].
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 5->[1,4] 4->[3,6]
# dfs(5, -INF, INF): valid (5 in range)
# dfs(1, -INF, 5): valid
# dfs(4, 5, INF): 4 < 5 → invalid → false ✓
#
# Edge Cases:
# - Duplicate values -> false (BST requires strict inequality)
# - INT_MIN/MAX edge values -> use Float::INFINITY

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def is_valid_bst_brute(root)
  vals = []
  in_order = lambda do |n|
    return unless n
    in_order.call(n.left)
    vals << n.val
    in_order.call(n.right)
  end
  in_order.call(root)
  vals.each_cons(2).all? { |a, b| a < b }
end

def is_valid_bst(root)
  validate = lambda do |node, min_val, max_val|
    return true unless node
    return false if node.val <= min_val || node.val >= max_val

    validate.call(node.left,  min_val,   node.val) &&
      validate.call(node.right, node.val, max_val)
  end

  validate.call(root, -Float::INFINITY, Float::INFINITY)
end

if __FILE__ == $PROGRAM_NAME
  root1 = TreeNode.new(2, TreeNode.new(1), TreeNode.new(3))
  puts "Brute: #{is_valid_bst_brute(root1)}"  # true
  puts "Opt:   #{is_valid_bst(root1)}"          # true

  root2 = TreeNode.new(5, TreeNode.new(1), TreeNode.new(4, TreeNode.new(3), TreeNode.new(6)))
  puts "Brute: #{is_valid_bst_brute(root2)}"  # false
  puts "Opt:   #{is_valid_bst(root2)}"          # false
end
