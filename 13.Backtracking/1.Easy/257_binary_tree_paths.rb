# frozen_string_literal: true

# LeetCode 257: Binary Tree Paths (Backtracking approach)
#
# Problem:
# Given the root of a binary tree, return all root-to-leaf paths as strings
# like "1->2->5".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS collecting full path arrays, join at leaf.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Path duplication at leaves — backtrack with a mutable path array.
#
# 3. Optimized Accepted Approach
#    DFS with backtracking: push node.val, recurse, pop on return.
#    At leaf, record path.join("->").
#    Time Complexity: O(n^2)
#    Space Complexity: O(n) for the path, O(h) stack
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1->[2,3] 2->[5]
# path=[], push 1 → [1]; push 2 → [1,2]; push 5 → [1,2,5]; leaf → record "1->2->5"; pop
# pop 2; push 3 → [1,3]; leaf → record "1->3"; pop; pop 1
# result=["1->2->5","1->3"] ✓
#
# Edge Cases:
# - Single node -> ["val"]
# - Skewed tree -> one path of length n

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
    result << path.join("->") if node.left.nil? && node.right.nil?
    dfs.call(node.left,  path.dup)
    dfs.call(node.right, path.dup)
  end
  dfs.call(root, [])
  result
end

def binary_tree_paths(root)
  result = []

  backtrack = lambda do |node, path|
    return unless node
    path << node.val                              # choose

    if node.left.nil? && node.right.nil?
      result << path.join("->")                   # leaf: record
    else
      backtrack.call(node.left,  path)
      backtrack.call(node.right, path)
    end

    path.pop                                      # undo (backtrack)
  end

  backtrack.call(root, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2, nil, TreeNode.new(5)), TreeNode.new(3))
  puts "Brute: #{binary_tree_paths_brute(root).inspect}"  # ["1->2->5","1->3"]
  puts "Opt:   #{binary_tree_paths(root).inspect}"         # ["1->2->5","1->3"]
end
