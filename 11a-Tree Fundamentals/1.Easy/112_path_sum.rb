# frozen_string_literal: true

# =============================================================================
# LeetCode 112: Path Sum
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree and an integer target_sum, return true if the
# tree has a root-to-leaf path whose node values add up to target_sum.
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
# Collect every root-to-leaf path sum, then check whether target_sum appears in
# that list.
#
# How the algorithm works:
# - DFS through the tree while carrying the current sum.
# - When a leaf is reached, store that path sum.
# - After traversal, check whether any stored sum equals target_sum.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(l + h), where l is the number of leaves and h is recursion depth.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def collect_path_sums(node, current_sum, sums)
  return if node.nil?

  current_sum += node.val

  if node.left.nil? && node.right.nil?
    sums << current_sum
    return
  end

  collect_path_sums(node.left, current_sum, sums)
  collect_path_sums(node.right, current_sum, sums)
end

def path_sum_brute?(root, target_sum)
  sums = []
  collect_path_sums(root, 0, sums)
  sums.include?(target_sum)
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution stores all leaf sums even though we only need to know
# whether one valid path exists.
#
# Repeated limitation:
# - It continues collecting sums after a valid path may already have been found.
# - It uses extra space for the sums array.
#
# We can return true immediately when a valid root-to-leaf path is found.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# Instead of carrying the growing path sum, carry the remaining target.
#
# At each node:
#   remaining = target_sum - node.val
#
# When we reach a leaf, the path is valid if:
#   remaining == 0
#
# This keeps the recursive state simple and avoids storing all path sums.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#       5
#      / \
#     4   8
#    /
#   11
#  /  \
# 7    2
#
# target_sum = 22
#
# has_path_sum?(5, 22):
#   remaining after 5 = 17
#   go left to 4, remaining = 13
#   go left to 11, remaining = 2
#   go right to 2, remaining = 0
#   node 2 is leaf and remaining is 0 => true

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If root is nil, return false.
# - Subtract root.val from target_sum.
# - If root is a leaf, return whether the remaining sum is 0.
# - Otherwise recurse into left or right child.
#
# Time Complexity:
#   O(n) in the worst case.
#
# Space Complexity:
#   O(h), where h is the tree height.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def has_path_sum?(root, target_sum)
  return false if root.nil?

  remaining = target_sum - root.val

  # Only a root-to-leaf path can satisfy the problem.
  return remaining.zero? if root.left.nil? && root.right.nil?

  has_path_sum?(root.left, remaining) || has_path_sum?(root.right, remaining)
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    5,
    TreeNode.new(4, TreeNode.new(11, TreeNode.new(7), TreeNode.new(2))),
    TreeNode.new(8, TreeNode.new(13), TreeNode.new(4, nil, TreeNode.new(1)))
  )

  puts path_sum_brute?(root, 22) # true
  puts has_path_sum?(root, 22)   # true

  puts path_sum_brute?(root, 26) # true
  puts has_path_sum?(root, 26)   # true

  puts path_sum_brute?(root, 5) # false
  puts has_path_sum?(root, 5)   # false
end
