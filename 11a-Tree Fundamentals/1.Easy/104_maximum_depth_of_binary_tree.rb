# frozen_string_literal: true

# =============================================================================
# LeetCode 104: Maximum Depth of Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return its maximum depth.
#
# The maximum depth is the number of nodes along the longest path from the root
# node down to the farthest leaf node.
#
# Example:
#   Input:
#       3
#      / \
#     9  20
#        / \
#       15  7
#
#   Output: 3
#
# Because the longest root-to-leaf path is:
#   3 -> 20 -> 15
# or
#   3 -> 20 -> 7

# -----------------------------------------------------------------------------
# Tree Node Definition
# -----------------------------------------------------------------------------

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
# We can visit the tree level by level using BFS.
# Every time we finish processing one level, we increase the depth by 1.
#
# How it works:
# - Start with the root in a queue.
# - Process all nodes currently in the queue.
# - These nodes belong to the same level.
# - Add their children to the queue for the next level.
# - Count how many levels we process.
#
# Time Complexity:
#   O(n), where n is the number of nodes.
#
# Space Complexity:
#   O(n), because the queue can store many nodes at the same level.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def max_depth_brute(root)
  return 0 if root.nil?

  queue = [root]
  depth = 0

  until queue.empty?
    level_size = queue.size

    level_size.times do
      node = queue.shift

      queue << node.left if node.left
      queue << node.right if node.right
    end

    depth += 1
  end

  depth
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The BFS solution is correct and already O(n), so it is not bad asymptotically.
#
# The main limitation is space:
# - BFS stores nodes level by level.
# - In a wide tree, the last level can contain roughly n / 2 nodes.
# - That means the queue can grow large.
#
# Also, the problem asks for depth, which is naturally recursive:
# - The depth of a tree depends on the depth of its left subtree.
# - It also depends on the depth of its right subtree.
#
# So instead of storing an entire level in a queue, we can ask each subtree for
# its own depth and combine the answers.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
#
# A binary tree is recursive.
#
# For any node:
#   max_depth(node) = 1 + max(max_depth(node.left), max_depth(node.right))
#
# Why?
# - The current node contributes 1 level.
# - The deepest path must continue either into the left subtree or right subtree.
# - We choose the deeper one.
#
# Base case:
#   If the node is nil, its depth is 0.
#
# This removes the need for a queue.
# The call stack now tracks the path we are currently exploring.
#
# This is a post-order DFS pattern:
# - First solve the left subtree.
# - Then solve the right subtree.
# - Then combine both answers at the current node.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#
#       3
#      / \
#     9  20
#        / \
#       15  7
#
# Call:
#   max_depth(3)
#
# Step-by-step:
#
#   max_depth(3)
#     left_depth  = max_depth(9)
#       max_depth(9)
#         left_depth  = max_depth(nil) => 0
#         right_depth = max_depth(nil) => 0
#         return 1 + max(0, 0) => 1
#
#     right_depth = max_depth(20)
#       max_depth(20)
#         left_depth = max_depth(15)
#           max_depth(15)
#             left_depth  = 0
#             right_depth = 0
#             return 1
#
#         right_depth = max_depth(7)
#           max_depth(7)
#             left_depth  = 0
#             right_depth = 0
#             return 1
#
#         return 1 + max(1, 1) => 2
#
#   return 1 + max(1, 2) => 3
#
# Final answer:
#   3

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If root is nil, return 0.
# - Recursively calculate the max depth of the left subtree.
# - Recursively calculate the max depth of the right subtree.
# - Return 1 plus the larger of the two depths.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), where h is the height of the tree.
#   This is recursion stack space.
#   - Balanced tree: O(log n)
#   - Skewed tree: O(n)

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def max_depth(root)
  return 0 if root.nil?

  left_depth = max_depth(root.left)
  right_depth = max_depth(root.right)

  # Current node contributes 1 level.
  1 + [left_depth, right_depth].max
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  # Example 1:
  #
  #       3
  #      / \
  #     9  20
  #        / \
  #       15  7
  #
  root = TreeNode.new(
    3,
    TreeNode.new(9),
    TreeNode.new(20, TreeNode.new(15), TreeNode.new(7))
  )

  puts max_depth_brute(root) # 3
  puts max_depth(root)       # 3

  # Example 2:
  #
  #   1
  #
  single_node = TreeNode.new(1)

  puts max_depth_brute(single_node) # 1
  puts max_depth(single_node)       # 1

  # Example 3:
  #
  # Empty tree
  empty_tree = nil

  puts max_depth_brute(empty_tree) # 0
  puts max_depth(empty_tree)       # 0

  # Example 4:
  #
  #   1
  #    \
  #     2
  #      \
  #       3
  #
  skewed_tree = TreeNode.new(1, nil, TreeNode.new(2, nil, TreeNode.new(3)))

  puts max_depth_brute(skewed_tree) # 3
  puts max_depth(skewed_tree)       # 3
end
