# frozen_string_literal: true

# =============================================================================
# LeetCode 700: Search in a Binary Search Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary search tree and an integer val, return the subtree
# rooted at the node whose value equals val.
#
# If the value does not exist in the tree, return nil.

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
# Treat the BST like an ordinary binary tree and search both children.
#
# How the algorithm works:
# - If the current node is nil, return nil.
# - If the current node has the target value, return it.
# - Search the left subtree.
# - If not found, search the right subtree.
#
# Time Complexity:
#   O(n), because we may visit every node.
#
# Space Complexity:
#   O(h), where h is tree height.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def search_bst_brute(root, val)
  return nil if root.nil?
  return root if root.val == val

  left_result = search_bst_brute(root.left, val)
  return left_result if left_result

  search_bst_brute(root.right, val)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution ignores the BST ordering rule.
#
# Repeated limitation:
# - It searches branches where the value cannot exist.
# - If val is smaller than root.val, the right subtree is impossible.
# - If val is larger than root.val, the left subtree is impossible.
#
# The BST property lets us choose exactly one direction at each step.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# For every BST node:
# - left descendants are smaller.
# - right descendants are larger.
#
# Therefore:
# - If val == node.val, we found the answer.
# - If val < node.val, search left.
# - If val > node.val, search right.
#
# This is the same logic as binary search, but applied to tree pointers.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# BST:
#       4
#      / \
#     2   7
#    / \
#   1   3
#
# val = 2
#
# visit 4:
#   2 < 4, go left
# visit 2:
#   2 == 2, return node 2
#
# We never visit node 7 because the BST property proves it cannot contain 2.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If root is nil or root.val equals val, return root.
# - If val is smaller, recurse left.
# - If val is larger, recurse right.
#
# Time Complexity:
#   O(h), where h is tree height.
#   Balanced BST: O(log n), skewed BST: O(n).
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def search_bst(root, val)
  return root if root.nil? || root.val == val

  # Use BST ordering to discard one entire side.
  val < root.val ? search_bst(root.left, val) : search_bst(root.right, val)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    4,
    TreeNode.new(2, TreeNode.new(1), TreeNode.new(3)),
    TreeNode.new(7)
  )

  puts search_bst_brute(root, 2)&.val # 2
  puts search_bst(root, 2)&.val       # 2

  puts search_bst_brute(root, 5)&.val.inspect # nil
  puts search_bst(root, 5)&.val.inspect       # nil
end
