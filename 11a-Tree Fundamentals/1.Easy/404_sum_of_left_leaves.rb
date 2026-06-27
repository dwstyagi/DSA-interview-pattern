# frozen_string_literal: true

# =============================================================================
# LeetCode 404: Sum of Left Leaves
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the sum of all left leaves.
#
# A left leaf is a node that:
# - Is the left child of its parent.
# - Has no children of its own.

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
# Collect all left leaf values first, then sum them.
#
# How the algorithm works:
# - DFS through the tree.
# - Carry a boolean telling whether the current node is a left child.
# - If the current node is a leaf and is_left is true, store its value.
# - Sum the collected values at the end.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(k + h), where k is the number of left leaves and h is recursion depth.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def collect_left_leaves(node, is_left, values)
  return if node.nil?

  if node.left.nil? && node.right.nil?
    values << node.val if is_left
    return
  end

  collect_left_leaves(node.left, true, values)
  collect_left_leaves(node.right, false, values)
end

def sum_of_left_leaves_brute(root)
  values = []
  collect_left_leaves(root, false, values)
  values.sum
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force traversal stores left leaf values even though each value can be
# added immediately.
#
# Repeated limitation:
# - We allocate an array only to sum it later.
# - We delay a simple local addition.
#
# We can return the contribution of each subtree directly.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# To know whether a leaf is a left leaf, the node needs one piece of context from
# its parent: did we arrive through the left edge?
#
# Once we have that boolean:
# - nil contributes 0.
# - a left leaf contributes node.val.
# - every other node contributes the sum from its children.
#
# This turns the problem into a clean recursive sum.

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
# dfs(3, false):
#   dfs(9, true):
#     9 is leaf and is_left => contribute 9
#   dfs(20, false):
#     dfs(15, true):
#       15 is leaf and is_left => contribute 15
#     dfs(7, false):
#       7 is leaf but not left => contribute 0
#
# Total = 9 + 15 = 24.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Use a helper that receives node and is_left.
# - Return 0 for nil nodes.
# - Return node.val if node is a leaf and is_left is true.
# - Otherwise return left contribution plus right contribution.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), where h is the recursion depth.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def left_leaf_sum(node, is_left)
  return 0 if node.nil?

  # A node only counts when it is both a leaf and reached from the left.
  return node.val if is_left && node.left.nil? && node.right.nil?

  left_leaf_sum(node.left, true) + left_leaf_sum(node.right, false)
end

def sum_of_left_leaves(root)
  left_leaf_sum(root, false)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    3,
    TreeNode.new(9),
    TreeNode.new(20, TreeNode.new(15), TreeNode.new(7))
  )

  puts sum_of_left_leaves_brute(root) # 24
  puts sum_of_left_leaves(root)       # 24

  single = TreeNode.new(1)

  puts sum_of_left_leaves_brute(single) # 0
  puts sum_of_left_leaves(single)       # 0
end
