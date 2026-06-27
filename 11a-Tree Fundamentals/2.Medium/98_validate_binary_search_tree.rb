# frozen_string_literal: true

# =============================================================================
# LeetCode 98: Validate Binary Search Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, determine whether it is a valid binary search
# tree.
#
# In a valid BST, every node must satisfy:
# - all values in the left subtree are strictly smaller than node.val
# - all values in the right subtree are strictly greater than node.val

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val = 0, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition:
# Inorder traversal of a valid BST produces values in strictly increasing order.
#
# How the algorithm works:
# - Traverse left subtree.
# - Visit current node.
# - Traverse right subtree.
# - Store all values in an array.
# - Verify every value is smaller than the next value.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(n), because all values are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def inorder_values(node, values)
  return if node.nil?

  inorder_values(node.left, values)
  values << node.val
  inorder_values(node.right, values)
end

def valid_bst_brute?(root)
  values = []
  inorder_values(root, values)

  (1...values.length).all? { |i| values[i - 1] < values[i] }
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# Inorder traversal is good, but storing all values is unnecessary.
#
# Also, a common incorrect approach checks only direct children:
#   left.val < root.val < right.val
#
# That misses deeper violations, such as a node in the right subtree that is
# smaller than an ancestor.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# Each node has an allowed value range inherited from all ancestors.
#
# For a node with bounds (low, high):
# - node.val must be strictly between low and high.
# - left child gets upper bound node.val.
# - right child gets lower bound node.val.
#
# This catches deep violations because ancestor constraints travel downward.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#      5
#     / \
#    1   4
#       / \
#      3   6
#
# validate(5, -inf, inf) ok
# validate(1, -inf, 5) ok
# validate(4, 5, inf) fails because 4 <= 5
#
# Answer: false.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Recursively validate each node with low and high bounds.
# - Return false if node.val is not inside the open interval.
# - Recurse left with high = node.val.
# - Recurse right with low = node.val.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def valid_with_bounds?(node, low, high)
  return true if node.nil?
  return false if low && node.val <= low
  return false if high && node.val >= high

  valid_with_bounds?(node.left, low, node.val) &&
    valid_with_bounds?(node.right, node.val, high)
end

def valid_bst?(root)
  valid_with_bounds?(root, nil, nil)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  valid = TreeNode.new(2, TreeNode.new(1), TreeNode.new(3))

  puts valid_bst_brute?(valid) # true
  puts valid_bst?(valid)       # true

  invalid = TreeNode.new(
    5,
    TreeNode.new(1),
    TreeNode.new(4, TreeNode.new(3), TreeNode.new(6))
  )

  puts valid_bst_brute?(invalid) # false
  puts valid_bst?(invalid)       # false
end
