# frozen_string_literal: true

# =============================================================================
# LeetCode 226: Invert Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, invert the tree and return its root.
#
# Inverting means every node's left and right children are swapped.
#
# Example:
#       4                    4
#      / \                  / \
#     2   7      =>        7   2
#    / \ / \              / \ / \
#   1  3 6  9            9  6 3  1

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
# We can build a completely new inverted tree instead of mutating the original.
# The new root has the same value, but its left child comes from the inverted
# version of the original right subtree, and its right child comes from the
# inverted version of the original left subtree.
#
# How the algorithm works:
# - If the current node is nil, return nil.
# - Create a new node with the same value.
# - Recursively copy and invert the right subtree into the new left child.
# - Recursively copy and invert the left subtree into the new right child.
#
# Time Complexity:
#   O(n), because every node is copied once.
#
# Space Complexity:
#   O(n), for the new tree, plus O(h) recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def invert_tree_brute(root)
  return nil if root.nil?

  TreeNode.new(
    root.val,
    invert_tree_brute(root.right),
    invert_tree_brute(root.left)
  )
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution does unnecessary allocation:
# - It creates a second tree with n new nodes.
# - The problem does not require preserving the original tree.
#
# Since every node already has left and right pointers, we can simply swap those
# pointers in place. That removes the extra O(n) tree allocation.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# To invert a tree, each node only needs one local operation:
#   node.left, node.right = node.right, node.left
#
# After swapping the current node's children, the same idea must be applied to
# both subtrees.
#
# This is naturally recursive:
# - Base case: nil node returns nil.
# - Work at current node: swap children.
# - Recurse into children, which are now on opposite sides.
#
# The order can be pre-order or post-order because every node's swap is
# independent. Pre-order is simple: swap first, then recurse.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       4
#      / \
#     2   7
#
# invert_tree(4):
#   swap 4.left and 4.right
#       4
#      / \
#     7   2
#
#   invert_tree(7): leaf, swap nil children, return 7
#   invert_tree(2): leaf, swap nil children, return 2
#
# Return root 4.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Return nil if root is nil.
# - Swap root.left and root.right.
# - Recursively invert root.left.
# - Recursively invert root.right.
# - Return root.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), where h is the tree height, due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def invert_tree(root)
  return nil if root.nil?

  # Swap the two child pointers in place.
  root.left, root.right = root.right, root.left

  invert_tree(root.left)
  invert_tree(root.right)

  root
end

def preorder_values(root, result = [])
  return result if root.nil?

  result << root.val
  preorder_values(root.left, result)
  preorder_values(root.right, result)
  result
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    4,
    TreeNode.new(2, TreeNode.new(1), TreeNode.new(3)),
    TreeNode.new(7, TreeNode.new(6), TreeNode.new(9))
  )

  copied = invert_tree_brute(root)
  puts preorder_values(copied).inspect # [4, 7, 9, 6, 2, 3, 1]

  inverted = invert_tree(root)
  puts preorder_values(inverted).inspect # [4, 7, 9, 6, 2, 3, 1]

  puts invert_tree(nil).inspect # nil
end
