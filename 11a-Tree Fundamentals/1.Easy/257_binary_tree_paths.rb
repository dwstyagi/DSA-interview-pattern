# frozen_string_literal: true

# =============================================================================
# LeetCode 257: Binary Tree Paths
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given the root of a binary tree, return all root-to-leaf paths in any order.
#
# Each path should be returned as a string using "->" between node values.

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
# Carry the path string built so far as we move down the tree.
#
# How the algorithm works:
# - Start with an empty string.
# - At each node, append the node value to the path.
# - If the node is a leaf, store the completed path.
# - Otherwise recurse into children with the updated path string.
#
# Time Complexity:
#   O(n * h), because path strings can be copied at each recursive step.
#
# Space Complexity:
#   O(n * h), for the output strings, plus O(h) recursion stack.

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def binary_tree_paths_brute(root)
  result = []

  dfs = lambda do |node, path|
    return if node.nil?

    next_path = path.empty? ? node.val.to_s : "#{path}->#{node.val}"

    if node.left.nil? && node.right.nil?
      result << next_path
      return
    end

    dfs.call(node.left, next_path)
    dfs.call(node.right, next_path)
  end

  dfs.call(root, '')
  result
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force version repeatedly creates new strings as it descends.
#
# Repeated work:
# - A common prefix like "1->2" may be copied for every leaf below node 2.
# - String building happens before we know whether we are at a leaf.
#
# We can keep a mutable path array, push when entering a node, and pop when
# leaving it. Only at leaves do we convert the path into a string.

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key observation:
# DFS path problems usually follow the backtracking shape:
# - Choose: add current node to path.
# - Explore: recurse into children.
# - Unchoose: remove current node before returning to parent.
#
# The path array represents the current root-to-node path.
# Because we pop after each subtree, sibling branches do not pollute each other.

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Tree:
#     1
#    / \
#   2   3
#    \
#     5
#
# path = []
# visit 1 => [1]
# visit 2 => [1, 2]
# visit 5 => [1, 2, 5], leaf => store "1->2->5", pop 5
# pop 2
# visit 3 => [1, 3], leaf => store "1->3", pop 3
# pop 1
#
# Result: ["1->2->5", "1->3"]

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm:
# - DFS from root.
# - Push current value onto path.
# - If current node is leaf, append path.join("->") to result.
# - Recurse into left and right children.
# - Pop current value before returning.
#
# Time Complexity:
#   O(n * h) overall because each output path string has length up to h.
#
# Space Complexity:
#   O(h) auxiliary path and recursion stack, excluding output.

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

def build_paths(node, path, result)
  return if node.nil?

  path << node.val

  if node.left.nil? && node.right.nil?
    # Convert only complete root-to-leaf paths into strings.
    result << path.join('->')
  else
    build_paths(node.left, path, result)
    build_paths(node.right, path, result)
  end

  path.pop
end

def binary_tree_paths(root)
  result = []
  build_paths(root, [], result)
  result
end

# -----------------------------------------------------------------------------
# Examples
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(
    1,
    TreeNode.new(2, nil, TreeNode.new(5)),
    TreeNode.new(3)
  )

  puts binary_tree_paths_brute(root).inspect # ["1->2->5", "1->3"]
  puts binary_tree_paths(root).inspect       # ["1->2->5", "1->3"]

  single = TreeNode.new(1)

  puts binary_tree_paths_brute(single).inspect # ["1"]
  puts binary_tree_paths(single).inspect       # ["1"]
end
