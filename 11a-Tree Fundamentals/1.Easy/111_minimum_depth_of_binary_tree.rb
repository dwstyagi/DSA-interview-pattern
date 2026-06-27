# frozen_string_literal: true

# =============================================================================
# LeetCode 111: Minimum Depth of Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return its minimum depth.
#
# The minimum depth is the number of nodes along the shortest path from the root
# node down to the nearest leaf node.
#
# A leaf is a node with no left child and no right child.

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
# We can find the nearest leaf by scanning the tree level by level.
# The first leaf we see in BFS must be at the minimum depth because BFS explores
# all nodes at depth 1 before depth 2, all nodes at depth 2 before depth 3, and
# so on.
#
# How the algorithm works:
# - Put the root in a queue with depth 1.
# - Remove nodes from the queue one by one.
# - If the current node is a leaf, return its depth immediately.
# - Otherwise, add its non-nil children with depth + 1.
#
# Time Complexity:
#   O(n), where n is the number of nodes. In the worst case we visit all nodes.
#
# Space Complexity:
#   O(n), because the queue can hold many nodes from the same level.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def min_depth_brute(root)
  return 0 if root.nil?

  queue = [[root, 1]]

  until queue.empty?
    node, depth = queue.shift

    return depth if node.left.nil? && node.right.nil?

    queue << [node.left, depth + 1] if node.left
    queue << [node.right, depth + 1] if node.right
  end
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# BFS is actually excellent for this problem because it can stop at the first
# leaf. The main limitation is memory:
# - In a wide tree, the queue may hold many nodes at once.
# - If the interview expects recursion practice, BFS does not highlight the
#   recursive tree structure.
#
# A tempting recursive formula is:
#   1 + min(min_depth(left), min_depth(right))
#
# But that is wrong when one child is nil. A nil child is not a leaf path, so it
# must not be counted as depth 0 if the other child exists.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# A leaf is the stopping point. A missing child is not a valid root-to-leaf path.
#
# For each node:
# - If it is nil, depth is 0.
# - If it is a leaf, depth is 1.
# - If only one child exists, the minimum depth must go through that child.
# - If both children exist, choose the smaller child depth.
#
# This gives us a leaf-aware recursive solution.

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
# min_depth(3):
#   left = min_depth(9)
#     9 is leaf => 1
#   right = min_depth(20)
#     left = min_depth(15) => 1
#     right = min_depth(7) => 1
#     both exist => 1 + min(1, 1) = 2
#   both exist => 1 + min(1, 2) = 2
#
# Answer: 2, path 3 -> 9.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - Return 0 for nil root.
# - Return 1 for a leaf.
# - If one child is missing, recurse only into the existing child.
# - If both children exist, return 1 plus the smaller subtree depth.
#
# Time Complexity:
#   O(n), because each node is visited once.
#
# Space Complexity:
#   O(h), where h is the tree height, due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def min_depth(root)
  return 0 if root.nil?
  return 1 if root.left.nil? && root.right.nil?

  return 1 + min_depth(root.right) if root.left.nil?
  return 1 + min_depth(root.left) if root.right.nil?

  1 + [min_depth(root.left), min_depth(root.right)].min
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

  puts min_depth_brute(root) # 2
  puts min_depth(root)       # 2

  skewed = TreeNode.new(1, nil, TreeNode.new(2, nil, TreeNode.new(3)))

  puts min_depth_brute(skewed) # 3
  puts min_depth(skewed)       # 3

  puts min_depth_brute(nil) # 0
  puts min_depth(nil)       # 0
end
