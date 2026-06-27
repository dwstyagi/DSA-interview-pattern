# frozen_string_literal: true

# =============================================================================
# LeetCode 637: Average of Levels in Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the average value of the nodes on each
# level as an array.

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
# Build the complete level order traversal first, then average each level.
#
# How the algorithm works:
# - BFS through the tree.
# - Store each level's values in an array.
# - Map every level to level.sum / level.length.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(n), because all level values are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def average_of_levels_brute(root)
  return [] if root.nil?

  queue = [root]
  levels = []

  until queue.empty?
    level = []
    queue.size.times do
      node = queue.shift
      level << node.val
      queue << node.left if node.left
      queue << node.right if node.right
    end
    levels << level
  end

  levels.map { |level| level.sum.to_f / level.length }
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution stores every value, but each level only needs two
# pieces of information:
# - Sum of values.
# - Count of nodes.
#
# We can compute the average immediately after processing a level.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# Queue-size snapshot separates one level from the next.
#
# Once we know level_size:
# - Initialize sum = 0.
# - Process exactly level_size nodes.
# - Add node values to sum.
# - Average is sum / level_size.
#
# Children added during the loop belong to the next level.

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
# level 1: sum = 3, count = 1 => 3.0
# level 2: sum = 29, count = 2 => 14.5
# level 3: sum = 22, count = 2 => 11.0
#
# Answer: [3.0, 14.5, 11.0]

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - BFS level by level.
# - For each level, accumulate sum while processing level_size nodes.
# - Append sum.to_f / level_size to result.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(w), where w is maximum tree width.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def average_of_levels(root)
  return [] if root.nil?

  queue = [root]
  result = []

  until queue.empty?
    level_size = queue.size
    sum = 0

    level_size.times do
      node = queue.shift
      sum += node.val

      queue << node.left if node.left
      queue << node.right if node.right
    end

    result << sum.to_f / level_size
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

  puts average_of_levels_brute(root).inspect # [3.0, 14.5, 11.0]
  puts average_of_levels(root).inspect       # [3.0, 14.5, 11.0]
end
