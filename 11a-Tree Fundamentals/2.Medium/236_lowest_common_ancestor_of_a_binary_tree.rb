# frozen_string_literal: true

# =============================================================================
# LeetCode 236: Lowest Common Ancestor of a Binary Tree
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given a binary tree, find the lowest common ancestor (LCA) of two given nodes.
#
# The LCA is the lowest node in the tree that has both p and q as descendants.
# A node can be a descendant of itself.

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
# Find the path from root to p and the path from root to q. The last common node
# in those two paths is the LCA.
#
# How the algorithm works:
# - DFS to build root-to-target path for p.
# - DFS to build root-to-target path for q.
# - Compare both paths from the beginning.
# - The last equal node is the answer.
#
# Time Complexity:
#   O(n), because each path search may scan the tree.
#
# Space Complexity:
#   O(h), for each path and recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def find_path(node, target, path)
  return false if node.nil?

  path << node
  return true if node == target

  return true if find_path(node.left, target, path)
  return true if find_path(node.right, target, path)

  path.pop
  false
end

def lowest_common_ancestor_brute(root, p, q)
  path_p = []
  path_q = []

  find_path(root, p, path_p)
  find_path(root, q, path_q)

  lca = nil
  [path_p.length, path_q.length].min.times do |i|
    break unless path_p[i] == path_q[i]

    lca = path_p[i]
  end

  lca
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force approach stores two full paths.
#
# Limitation:
# - It separates "finding nodes" from "finding the split point."
# - It may traverse shared parts of the tree twice.
#
# We can discover the LCA during one post-order traversal by asking each subtree
# whether it contains p or q.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# During DFS, a subtree can return one of three meanings:
# - nil: found neither p nor q.
# - p or q: found one target.
# - some node: found the LCA already.
#
# At a node:
# - If left returns a target and right returns a target, current node is LCA.
# - If current node is p or q, return current node.
# - Otherwise return whichever side found something.
#
# This is post-order because we need results from both children before deciding.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#        3
#       / \
#      5   1
#     / \
#    6   2
#
# p = 5, q = 1
#
# dfs(5) returns 5.
# dfs(1) returns 1.
# dfs(3) sees left = 5 and right = 1, so 3 is the LCA.

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - If root is nil, p, or q, return root.
# - Recurse left and right.
# - If both sides return non-nil, root is the LCA.
# - Otherwise return the non-nil side.
#
# Time Complexity:
#   O(n), because every node is visited once.
#
# Space Complexity:
#   O(h), due to recursion stack.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def lowest_common_ancestor(root, p, q)
  return root if root.nil? || root == p || root == q

  left = lowest_common_ancestor(root.left, p, q)
  right = lowest_common_ancestor(root.right, p, q)

  # Split point: one target found on each side.
  return root if left && right

  left || right
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  node6 = TreeNode.new(6)
  node2 = TreeNode.new(2)
  node5 = TreeNode.new(5, node6, node2)
  node1 = TreeNode.new(1)
  root = TreeNode.new(3, node5, node1)

  puts lowest_common_ancestor_brute(root, node5, node1).val # 3
  puts lowest_common_ancestor(root, node5, node1).val       # 3

  puts lowest_common_ancestor_brute(root, node5, node2).val # 5
  puts lowest_common_ancestor(root, node5, node2).val       # 5
end
