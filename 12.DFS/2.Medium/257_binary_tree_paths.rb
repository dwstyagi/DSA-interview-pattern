# frozen_string_literal: true

# LeetCode 257: Binary Tree Paths
#
# Problem:
# Given the root of a binary tree, return all root-to-leaf paths in any order.
# Paths are represented as strings like "1->2->5".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS collecting path arrays, join with "->".
#    Time Complexity: O(n^2) — path copying
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Path string building per node — same complexity, can build string in DFS.
#
# 3. Optimized Accepted Approach
#    DFS with current path string. At leaf, append to result.
#    Pass the growing string down (no backtracking needed since strings are
#    immutable in practice — each recursion gets its own copy).
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1->[2,3] 2->[5]
# dfs(1, "1") → dfs(2, "1->2") → dfs(5, "1->2->5") → leaf: add "1->2->5"
#            → dfs(3, "1->3") → leaf: add "1->3"
# result=["1->2->5","1->3"] ✓
#
# Edge Cases:
# - Single node -> ["val"]

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def binary_tree_paths_brute(root)
  result = []
  dfs = lambda do |node, path|
    return unless node
    path << node.val
    if node.left.nil? && node.right.nil?
      result << path.join("->")
    else
      dfs.call(node.left,  path.dup)
      dfs.call(node.right, path.dup)
    end
  end
  dfs.call(root, [])
  result
end

def binary_tree_paths(root)
  result = []

  dfs = lambda do |node, path|
    return unless node
    path += node.val.to_s                  # extend path string

    if node.left.nil? && node.right.nil?
      result << path                        # leaf: record complete path
    else
      dfs.call(node.left,  "#{path}->")
      dfs.call(node.right, "#{path}->")
    end
  end

  dfs.call(root, "")
  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2, nil, TreeNode.new(5)), TreeNode.new(3))
  puts "Brute: #{binary_tree_paths_brute(root).inspect}"  # ["1->2->5","1->3"]
  puts "Opt:   #{binary_tree_paths(root).inspect}"         # ["1->2->5","1->3"]
end
