# frozen_string_literal: true

# =============================================================================
# LeetCode 235: Lowest Common Ancestor of a Binary Search Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given a binary search tree, find the lowest common ancestor of two given nodes.
#
# The LCA is the lowest node that has both p and q as descendants. A node can be
# a descendant of itself.

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
# Ignore the BST property and solve it like a normal binary tree.
#
# How the algorithm works:
# - Recursively search both left and right subtrees.
# - If p and q are found on different sides, current node is the LCA.
# - If current node is p or q, return it upward.
#
# Time Complexity:
#   O(n), because we may visit every node.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def lca_bst_brute(root, p, q)
  return root if root.nil? || root == p || root == q

  left = lca_bst_brute(root.left, p, q)
  right = lca_bst_brute(root.right, p, q)

  return root if left && right

  left || right
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force version ignores sorted structure.
#
# In a BST:
# - If p.val and q.val are both smaller than root.val, the LCA must be left.
# - If both are larger than root.val, the LCA must be right.
# - Otherwise root is the split point and therefore the LCA.
#
# Searching both sides wastes work when one comparison tells us the only possible
# direction.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# The LCA in a BST is the first node where p and q split directions.
#
# Cases:
# - p and q both less than root: move left.
# - p and q both greater than root: move right.
# - Otherwise root lies between them, so root is the LCA.
#
# This is like binary search for the split point.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# BST:
#          6
#        /   \
#       2     8
#      / \
#     0   4
#
# p = 2, q = 8
#
# root = 6:
#   p.val = 2 is less than 6
#   q.val = 8 is greater than 6
#   they split at 6
#
# Answer: 6.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Start at root.
# - If both target values are smaller, go left.
# - If both target values are larger, go right.
# - Otherwise return the current node.
#
# Time Complexity:
#   O(h), where h is BST height.
#
# Space Complexity:
#   O(1), using iteration.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def lowest_common_ancestor(root, p, q)
  current = root

  while current
    if p.val < current.val && q.val < current.val
      current = current.left
    elsif p.val > current.val && q.val > current.val
      current = current.right
    else
      # First split point, or one node equals current.
      return current
    end
  end
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  node2 = TreeNode.new(2, TreeNode.new(0), TreeNode.new(4))
  node8 = TreeNode.new(8)
  root = TreeNode.new(6, node2, node8)

  puts lca_bst_brute(root, node2, node8).val # 6
  puts lowest_common_ancestor(root, node2, node8).val # 6

  node4 = node2.right
  puts lca_bst_brute(root, node2, node4).val # 2
  puts lowest_common_ancestor(root, node2, node4).val # 2
end
