# frozen_string_literal: true

# =============================================================================
# LeetCode 199: Binary Tree Right Side View
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return the values visible when looking at the
# tree from the right side, ordered from top to bottom.

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
# First compute the full level order traversal. The right side view is the last
# value from each level.
#
# How the algorithm works:
# - BFS through the tree and build all levels.
# - For each level array, take level[-1].
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(n), because all levels are stored before extracting the answer.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def right_side_view_brute(root)
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

  levels.map(&:last)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution stores more than the problem asks for.
#
# Repeated limitation:
# - Each level may contain many nodes.
# - Only the last node of that level matters for the final answer.
#
# We can still use BFS, but record only the final node processed at each level.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# In normal left-to-right BFS, the rightmost node is the last node processed in a
# level.
#
# The queue-size snapshot tells us which node is last:
# - If i == level_size - 1, append node.val to the answer.
#
# This preserves level-order behavior while avoiding the full levels array.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#     1
#    / \
#   2   3
#    \   \
#     5   4
#
# level [1] => last is 1
# level [2, 3] => last is 3
# level [5, 4] => last is 4
#
# Answer: [1, 3, 4]

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - BFS level by level.
# - For each level, process exactly level_size nodes.
# - Append the value of the last node in that level.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(w), where w is the maximum tree width.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def right_side_view(root)
  return [] if root.nil?

  queue = [root]
  result = []

  until queue.empty?
    level_size = queue.size

    level_size.times do |i|
      node = queue.shift
      result << node.val if i == level_size - 1

      queue << node.left if node.left
      queue << node.right if node.right
    end
  end

  result
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    1,
    TreeNode.new(2, nil, TreeNode.new(5)),
    TreeNode.new(3, nil, TreeNode.new(4))
  )

  puts right_side_view_brute(root).inspect # [1, 3, 4]
  puts right_side_view(root).inspect       # [1, 3, 4]

  puts right_side_view(nil).inspect # []
end
