# frozen_string_literal: true

# =============================================================================
# LeetCode 113: Path Sum II
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree and an integer target_sum, return all
# root-to-leaf paths where the sum of node values equals target_sum.

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
# Generate every root-to-leaf path first. Then filter paths whose sum equals the
# target.
#
# How the algorithm works:
# - DFS through the tree.
# - Store a copy of every root-to-leaf path.
# - After traversal, select paths where path.sum == target_sum.
#
# Time Complexity:
#   O(n * h), because copying/summing paths can cost up to h per leaf.
#
# Space Complexity:
#   O(p * h), where p is the number of root-to-leaf paths.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def collect_all_paths(node, path, paths)
  return if node.nil?

  path << node.val

  if node.left.nil? && node.right.nil?
    paths << path.dup
  else
    collect_all_paths(node.left, path, paths)
    collect_all_paths(node.right, path, paths)
  end

  path.pop
end

def path_sum_brute(root, target_sum)
  paths = []
  collect_all_paths(root, [], paths)
  paths.select { |path| path.sum == target_sum }
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution stores paths that may never be valid.
#
# Repeated limitation:
# - It calculates path sums after paths are complete.
# - It keeps invalid paths in memory.
#
# We can carry the remaining target during DFS and only store paths that are
# valid at a leaf.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# The remaining target after visiting a node is:
#   remaining - node.val
#
# At a leaf, the path is valid only if the remaining target becomes 0.
#
# This combines path generation and filtering into one DFS. Backtracking keeps
# one mutable path array for the current branch.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree contains path 5 -> 4 -> 11 -> 2, target = 22.
#
# path [5], remaining 17
# path [5, 4], remaining 13
# path [5, 4, 11], remaining 2
# path [5, 4, 11, 2], remaining 0
# leaf and remaining is 0, store [5, 4, 11, 2]
#
# Then pop nodes while backtracking and explore siblings.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - DFS with node, remaining target, path, and result.
# - Push current node value.
# - If leaf and remaining equals node value, store a copy of path.
# - Otherwise recurse into children with remaining - node.val.
# - Pop current value before returning.
#
# Time Complexity:
#   O(n * h) in the worst case because valid paths must be copied.
#
# Space Complexity:
#   O(h), excluding output.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def dfs_path_sum(node, remaining, path, result)
  return if node.nil?

  path << node.val
  remaining -= node.val

  if node.left.nil? && node.right.nil?
    # Copy only paths that actually satisfy the target.
    result << path.dup if remaining.zero?
  else
    dfs_path_sum(node.left, remaining, path, result)
    dfs_path_sum(node.right, remaining, path, result)
  end

  path.pop
end

def path_sum(root, target_sum)
  result = []
  dfs_path_sum(root, target_sum, [], result)
  result
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    5,
    TreeNode.new(4, TreeNode.new(11, TreeNode.new(7), TreeNode.new(2))),
    TreeNode.new(8, TreeNode.new(13), TreeNode.new(4, TreeNode.new(5), TreeNode.new(1)))
  )

  puts path_sum_brute(root, 22).inspect # [[5, 4, 11, 2], [5, 8, 4, 5]]
  puts path_sum(root, 22).inspect       # [[5, 4, 11, 2], [5, 8, 4, 5]]
end
