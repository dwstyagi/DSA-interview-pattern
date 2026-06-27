# frozen_string_literal: true

# =============================================================================
# LeetCode 101: Symmetric Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return true if the tree is symmetric around
# its center.
#
# A symmetric tree is a mirror of itself:
# - The left subtree must mirror the right subtree.
# - Matching mirrored nodes must have the same value.

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
# A tree is symmetric if its left subtree is identical to the inverted version
# of its right subtree.
#
# How the algorithm works:
# - Make a mirrored copy of the right subtree.
# - Compare the left subtree with that mirrored copy using same-tree logic.
# - If they match, the original tree is symmetric.
#
# Time Complexity:
#   O(n), because we may copy and compare all nodes.
#
# Space Complexity:
#   O(n), because the mirrored copy may contain half the tree.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def mirror_copy(node)
  return nil if node.nil?

  TreeNode.new(node.val, mirror_copy(node.right), mirror_copy(node.left))
end

def same_tree?(p, q)
  return true if p.nil? && q.nil?
  return false if p.nil? || q.nil?
  return false if p.val != q.val

  same_tree?(p.left, q.left) && same_tree?(p.right, q.right)
end

def symmetric_brute?(root)
  return true if root.nil?

  same_tree?(root.left, mirror_copy(root.right))
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force approach allocates a mirrored copy even though we only need to
# compare relationships between existing nodes.
#
# Repeated limitation:
# - We build new nodes just to compare them once.
# - The mirrored copy costs extra memory.
#
# Instead, we can compare the two sides directly in mirror order.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# For two subtrees to be mirrors:
# - Their roots must have the same value.
# - The left child of the left subtree must match the right child of the right
#   subtree.
# - The right child of the left subtree must match the left child of the right
#   subtree.
#
# So the comparison is not:
#   left.left with right.left
#
# It is:
#   left.left with right.right
#   left.right with right.left
#
# This is same-tree logic with crossed recursive calls.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       1
#      / \
#     2   2
#    / \ / \
#   3  4 4  3
#
# mirror?(left 2, right 2):
#   values match
#   mirror?(3, 3) => true
#   mirror?(4, 4) => true
#   both true => true
#
# Therefore the whole tree is symmetric.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Empty tree is symmetric.
# - Compare root.left and root.right with a helper.
# - The helper returns true if both nodes are nil.
# - It returns false if only one is nil or values differ.
# - Otherwise it compares mirrored children.
#
# Time Complexity:
#   O(n), because each node is visited once.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def mirror?(left, right)
  return true if left.nil? && right.nil?
  return false if left.nil? || right.nil?
  return false if left.val != right.val

  mirror?(left.left, right.right) && mirror?(left.right, right.left)
end

def symmetric?(root)
  return true if root.nil?

  mirror?(root.left, root.right)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  symmetric_root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(3), TreeNode.new(4)),
    TreeNode.new(2, TreeNode.new(4), TreeNode.new(3))
  )

  puts symmetric_brute?(symmetric_root) # true
  puts symmetric?(symmetric_root)       # true

  asymmetric_root = TreeNode.new(
    1,
    TreeNode.new(2, nil, TreeNode.new(3)),
    TreeNode.new(2, nil, TreeNode.new(3))
  )

  puts symmetric_brute?(asymmetric_root) # false
  puts symmetric?(asymmetric_root)       # false
end
