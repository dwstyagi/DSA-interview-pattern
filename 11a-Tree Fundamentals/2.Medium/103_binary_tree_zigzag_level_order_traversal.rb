# frozen_string_literal: true

# =============================================================================
# LeetCode 103: Binary Tree Zigzag Level Order Traversal
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the zigzag level order traversal of its
# nodes' values.
#
# The first level is left to right, the next is right to left, and the direction
# alternates on every level.

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
# Build normal level order traversal first, then reverse every odd-indexed level.
#
# How the algorithm works:
# - BFS level by level.
# - Store each level from left to right.
# - After traversal, reverse levels at index 1, 3, 5, ...
#
# Time Complexity:
#   O(n), because each node appears in one level and may be reversed once.
#
# Space Complexity:
#   O(n), because all levels are stored.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def zigzag_level_order_brute(root)
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

  levels.each_with_index.map { |level, i| i.odd? ? level.reverse : level }
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution performs a separate reverse step after building each
# level. That is acceptable, but we can place values in the desired order while
# processing the level.
#
# The repeated limitation is doing a second pass over odd levels.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# The BFS queue order should stay normal so children are discovered correctly.
# Only the level array's value order needs to change.
#
# For each level:
# - left_to_right true: append values.
# - left_to_right false: prepend values.
#
# Then flip the direction after each level.

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
# level 0 left_to_right: [3]
# level 1 right_to_left: process 9 then 20, prepend => [20, 9]
# level 2 left_to_right: [15, 7]
#
# Answer: [[3], [20, 9], [15, 7]]

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - BFS with queue-size snapshot.
# - Build each level in the current direction.
# - Toggle direction after each level.
#
# Time Complexity:
#   O(n). Note: Array#unshift can cost O(level size), but total work remains
#   acceptable for interview Ruby solutions. Reversing per odd level is also fine.
#
# Space Complexity:
#   O(w), excluding output.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def zigzag_level_order(root)
  return [] if root.nil?

  queue = [root]
  result = []
  left_to_right = true

  until queue.empty?
    level = []

    queue.size.times do
      node = queue.shift
      left_to_right ? level << node.val : level.unshift(node.val)

      queue << node.left if node.left
      queue << node.right if node.right
    end

    result << level
    left_to_right = !left_to_right
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

  puts zigzag_level_order_brute(root).inspect # [[3], [20, 9], [15, 7]]
  puts zigzag_level_order(root).inspect       # [[3], [20, 9], [15, 7]]
end
