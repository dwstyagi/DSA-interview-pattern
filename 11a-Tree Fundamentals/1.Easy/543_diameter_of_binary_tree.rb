# frozen_string_literal: true

# =============================================================================
# LeetCode 543: Diameter of Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the length of the diameter of the tree.
#
# The diameter is the length of the longest path between any two nodes. This path
# may or may not pass through the root. Length is counted in edges, not nodes.

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
# For every node, pretend the longest path passes through that node.
# The path through a node uses the height of its left subtree plus the height of
# its right subtree.
#
# How the algorithm works:
# - Visit every node.
# - For each node, compute height(left) and height(right).
# - Candidate diameter through this node is left_height + right_height.
# - Keep the maximum candidate.
#
# Time Complexity:
#   O(n^2) in the worst case, because height is recomputed for many subtrees.
#
# Space Complexity:
#   O(h), where h is tree height, due to recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def height_brute(node)
  return 0 if node.nil?

  1 + [height_brute(node.left), height_brute(node.right)].max
end

def diameter_brute_dfs(node)
  return 0 if node.nil?

  through_node = height_brute(node.left) + height_brute(node.right)
  left_best = diameter_brute_dfs(node.left)
  right_best = diameter_brute_dfs(node.right)

  [through_node, left_best, right_best].max
end

def diameter_of_binary_tree_brute(root)
  diameter_brute_dfs(root)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The repeated work is height calculation.
#
# Example:
# - To compute the diameter at the root, we calculate the height of a subtree.
# - Then when we move into that subtree, we calculate the height of its children
#   again.
#
# The same subtree heights are recomputed many times. We need each node to return
# its height only once while also updating the best diameter seen so far.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# A post-order DFS gives both child heights before processing the current node.
#
# At each node:
# - left_height tells the longest downward path on the left.
# - right_height tells the longest downward path on the right.
# - left_height + right_height is the best path passing through this node.
#
# But what we return to the parent is different:
# - The parent can only extend one side.
# - So we return 1 + max(left_height, right_height).
#
# This is the key pattern:
#   update global answer with both sides
#   return one-side contribution upward

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       1
#      / \
#     2   3
#    / \
#   4   5
#
# dfs(4) returns height 1, best diameter still 0.
# dfs(5) returns height 1, best diameter still 0.
# dfs(2):
#   left_height = 1, right_height = 1
#   diameter through 2 = 2
#   best = 2
#   return height 2
# dfs(3) returns height 1.
# dfs(1):
#   left_height = 2, right_height = 1
#   diameter through 1 = 3
#   best = 3
#
# Answer: 3 edges.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Run post-order DFS.
# - For each node, compute left and right subtree heights.
# - Update the best diameter with left_height + right_height.
# - Return 1 + max(left_height, right_height) as the height.
#
# Time Complexity:
#   O(n), because each node is visited once.
#
# Space Complexity:
#   O(h), where h is tree height.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def diameter_of_binary_tree(root)
  best = 0

  height = lambda do |node|
    return 0 if node.nil?

    left_height = height.call(node.left)
    right_height = height.call(node.right)

    # Path through this node uses both sides, counted in edges.
    best = [best, left_height + right_height].max

    1 + [left_height, right_height].max
  end

  height.call(root)
  best
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    1,
    TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)),
    TreeNode.new(3)
  )

  puts diameter_of_binary_tree_brute(root) # 3
  puts diameter_of_binary_tree(root)       # 3

  single = TreeNode.new(1)

  puts diameter_of_binary_tree_brute(single) # 0
  puts diameter_of_binary_tree(single)       # 0
end
