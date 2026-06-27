# frozen_string_literal: true

# =============================================================================
# LeetCode 938: Range Sum of BST
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root node of a binary search tree and two integers low and high,
# return the sum of values of all nodes with values in the inclusive range
# [low, high].

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
# Ignore the BST property and traverse every node like a normal binary tree.
#
# How the algorithm works:
# - DFS through all nodes.
# - If a node's value is between low and high, add it to the sum.
# - Recurse into both left and right children.
#
# Time Complexity:
#   O(n), because every node is visited.
#
# Space Complexity:
#   O(h), where h is the tree height.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def range_sum_bst_brute(root, low, high)
  return 0 if root.nil?

  current = root.val.between?(low, high) ? root.val : 0

  current +
    range_sum_bst_brute(root.left, low, high) +
    range_sum_bst_brute(root.right, low, high)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution wastes time exploring branches that cannot possibly
# contain valid values.
#
# In a BST:
# - Every value in the left subtree is smaller than root.val.
# - Every value in the right subtree is larger than root.val.
#
# If root.val is already less than low, then the entire left subtree is too small.
# If root.val is already greater than high, then the entire right subtree is too
# large.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# The BST ordering lets us prune.
#
# Cases:
# - root.val < low:
#   root and everything left of it are too small, so search only right.
# - root.val > high:
#   root and everything right of it are too large, so search only left.
# - low <= root.val <= high:
#   include root.val and search both sides.
#
# This directly removes irrelevant subtrees from the traversal.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# BST:
#        10
#       /  \
#      5    15
#     / \     \
#    3   7     18
#
# low = 7, high = 15
#
# visit 10: in range, add 10 and search both sides.
# visit 5: 5 < 7, skip left subtree, search right.
# visit 7: in range, add 7.
# visit 15: in range, add 15 and search both sides.
# visit 18: 18 > 15, skip right subtree.
#
# Total = 10 + 7 + 15 = 32.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Return 0 for nil.
# - If node value is below low, recurse only right.
# - If node value is above high, recurse only left.
# - Otherwise add node value plus sums from both children.
#
# Time Complexity:
#   O(n) worst case, but faster when pruning skips branches.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def range_sum_bst(root, low, high)
  return 0 if root.nil?

  # BST pruning: left side is even smaller.
  return range_sum_bst(root.right, low, high) if root.val < low

  # BST pruning: right side is even larger.
  return range_sum_bst(root.left, low, high) if root.val > high

  root.val +
    range_sum_bst(root.left, low, high) +
    range_sum_bst(root.right, low, high)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    10,
    TreeNode.new(5, TreeNode.new(3), TreeNode.new(7)),
    TreeNode.new(15, nil, TreeNode.new(18))
  )

  puts range_sum_bst_brute(root, 7, 15) # 32
  puts range_sum_bst(root, 7, 15)       # 32

  puts range_sum_bst_brute(root, 6, 10) # 17
  puts range_sum_bst(root, 6, 10)       # 17
end
