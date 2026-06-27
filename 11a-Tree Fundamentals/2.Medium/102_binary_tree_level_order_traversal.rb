# frozen_string_literal: true

# =============================================================================
# LeetCode 102: Binary Tree Level Order Traversal
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the level order traversal of its nodes'
# values. Each level should be grouped into its own array.
#
# Example:
#   root = [3,9,20,nil,nil,15,7]
#   output = [[3], [9, 20], [15, 7]]

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
# DFS can collect each node into a bucket based on its depth.
#
# How the algorithm works:
# - Start DFS at depth 0.
# - When visiting a node, create result[depth] if needed.
# - Append node.val into that depth bucket.
# - Recurse left and right with depth + 1.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h) recursion stack, excluding the output.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def level_order_dfs(node, depth, result)
  return if node.nil?

  result[depth] ||= []
  result[depth] << node.val

  level_order_dfs(node.left, depth + 1, result)
  level_order_dfs(node.right, depth + 1, result)
end

def level_order_brute(root)
  result = []
  level_order_dfs(root, 0, result)
  result
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# DFS is correct, but the problem asks for level order, which is naturally BFS.
#
# The limitation:
# - DFS jumps down a path before finishing the current level.
# - We need an explicit depth argument to place values into the right buckets.
#
# BFS processes the tree in the same order the output is grouped.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# A queue gives first-in-first-out order, which matches level order traversal.
#
# The crucial trick is taking a snapshot of queue.size at the start of each level.
# That size tells us exactly how many nodes belong to the current level. Children
# added during that loop belong to the next level and should not be processed yet.

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
# queue = [3]
# level_size = 1 => level [3], enqueue 9, 20
# result = [[3]]
#
# queue = [9, 20]
# level_size = 2 => level [9, 20], enqueue 15, 7
# result = [[3], [9, 20]]
#
# queue = [15, 7]
# level_size = 2 => level [15, 7]
# result = [[3], [9, 20], [15, 7]]

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Return [] for nil root.
# - Initialize queue with root.
# - While queue is not empty, snapshot the current queue size.
# - Process exactly that many nodes into a level array.
# - Enqueue children for the next level.
# - Append the level array to result.
#
# Time Complexity:
#   O(n), because every node is processed once.
#
# Space Complexity:
#   O(w), where w is the maximum width of the tree.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def level_order(root)
  return [] if root.nil?

  queue = [root]
  result = []

  until queue.empty?
    level = []
    level_size = queue.size

    level_size.times do
      node = queue.shift
      level << node.val

      queue << node.left if node.left
      queue << node.right if node.right
    end

    result << level
  end

  result
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

  puts level_order_brute(root).inspect # [[3], [9, 20], [15, 7]]
  puts level_order(root).inspect       # [[3], [9, 20], [15, 7]]

  puts level_order(nil).inspect # []
end
