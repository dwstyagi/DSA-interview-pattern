# frozen_string_literal: true

# =============================================================================
# LeetCode 110: Balanced Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return true if it is height-balanced.
#
# A height-balanced binary tree is one where, for every node, the heights of the
# left and right subtrees differ by no more than 1.

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
# At every node, calculate the height of the left and right subtrees and check
# whether their difference is at most 1. Then recursively check both children.
#
# How the algorithm works:
# - Compute height(root.left) and height(root.right).
# - If their difference is greater than 1, return false.
# - Otherwise verify that both subtrees are balanced.
#
# Time Complexity:
#   O(n^2) in the worst case, because heights are recomputed repeatedly.
#
# Space Complexity:
#   O(h), where h is the tree height.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def tree_height(node)
  return 0 if node.nil?

  1 + [tree_height(node.left), tree_height(node.right)].max
end

def balanced_brute?(root)
  return true if root.nil?

  left_height = tree_height(root.left)
  right_height = tree_height(root.right)

  (left_height - right_height).abs <= 1 &&
    balanced_brute?(root.left) &&
    balanced_brute?(root.right)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The bottleneck is repeated height computation.
#
# A subtree's height may be recalculated once for its parent, then again when that
# subtree becomes the current root. In a skewed tree this creates O(n^2) work.
#
# We need a traversal where each node computes its height once and reports
# whether it is balanced at the same time.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# Balance depends on child heights, so this must be post-order:
# - Ask left subtree for height.
# - Ask right subtree for height.
# - Check current node.
#
# To avoid carrying two values, use a sentinel:
# - Return normal height when subtree is balanced.
# - Return -1 when subtree is unbalanced.
#
# Once any child returns -1, the whole tree is unbalanced and we keep returning
# -1 upward.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       3
#      / \
#     9  20
#        / \
#       15  7
#
# check_height(9) => 1
# check_height(15) => 1
# check_height(7) => 1
# check_height(20):
#   abs(1 - 1) = 0, return 2
# check_height(3):
#   abs(1 - 2) = 1, return 3
#
# Since final result is not -1, the tree is balanced.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Use a helper that returns subtree height or -1 if unbalanced.
# - Recursively get left and right heights.
# - If either is -1, return -1.
# - If height difference is greater than 1, return -1.
# - Otherwise return 1 + max(left_height, right_height).
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def check_height(node)
  return 0 if node.nil?

  left_height = check_height(node.left)
  return -1 if left_height == -1

  right_height = check_height(node.right)
  return -1 if right_height == -1

  # Sentinel -1 means this subtree is already unbalanced.
  return -1 if (left_height - right_height).abs > 1

  1 + [left_height, right_height].max
end

def balanced?(root)
  check_height(root) != -1
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  balanced_root = TreeNode.new(
    3,
    TreeNode.new(9),
    TreeNode.new(20, TreeNode.new(15), TreeNode.new(7))
  )

  puts balanced_brute?(balanced_root) # true
  puts balanced?(balanced_root)       # true

  unbalanced_root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(3, TreeNode.new(4), nil), nil),
    nil
  )

  puts balanced_brute?(unbalanced_root) # false
  puts balanced?(unbalanced_root)       # false
end
