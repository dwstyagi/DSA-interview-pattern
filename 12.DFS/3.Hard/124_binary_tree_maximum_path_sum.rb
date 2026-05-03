# frozen_string_literal: true

# LeetCode 124: Binary Tree Maximum Path Sum
#
# Problem:
# Given the root of a binary tree, return the maximum path sum of any non-empty
# path. A path is a sequence of nodes where each pair is connected, no node
# appears twice. The path does not need to pass through the root.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For every pair of nodes, find path between them and sum values. O(n^3).
#    Time Complexity: O(n^3)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Enumerating all paths — post-order DFS computing max gain from each subtree.
#
# 3. Optimized Accepted Approach
#    Post-order DFS. At each node, gain = max(0, left_gain) + max(0, right_gain) + val.
#    Update global max with gain (path through node).
#    Return node.val + max(left_gain, right_gain) to parent (can only extend one side).
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: -10->[9,20] 20->[15,7]
# dfs(9): l=0,r=0 → gain=9, return 9
# dfs(15): return 15; dfs(7): return 7
# dfs(20): l=15,r=7 → gain=15+7+20=42, return 20+15=35
# dfs(-10): l=9,r=35 → gain=9+35-10=34, max=42 → return 42 ✓
#
# Edge Cases:
# - All negative -> max single node
# - Single node -> node.val

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def max_path_sum_brute(root)
  max_sum = [-Float::INFINITY]
  # For each node, find all paths through it and track max
  all_nodes = []
  collect = lambda { |n| return unless n; all_nodes << n; collect.call(n.left); collect.call(n.right) }
  collect.call(root)

  # DFS returning max gain from this node downward (one direction)
  gain = lambda do |node|
    return 0 unless node
    [0, node.val + [gain.call(node.left), gain.call(node.right)].max].max
  end

  all_nodes.each do |n|
    path_through = n.val + [0, gain.call(n.left)].max + [0, gain.call(n.right)].max
    max_sum[0] = [max_sum[0], path_through].max
  end
  max_sum[0]
end

def max_path_sum(root)
  max_sum = [-Float::INFINITY]

  dfs = lambda do |node|
    return 0 unless node
    left_gain  = [0, dfs.call(node.left)].max   # ignore negative contribution
    right_gain = [0, dfs.call(node.right)].max

    # path through this node (can go both directions)
    path_through = node.val + left_gain + right_gain
    max_sum[0]   = [max_sum[0], path_through].max

    node.val + [left_gain, right_gain].max         # return best single-direction gain
  end

  dfs.call(root)
  max_sum[0]
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(-10, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{max_path_sum_brute(root)}"  # 42
  puts "Opt:   #{max_path_sum(root)}"         # 42

  root2 = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))
  puts "Brute: #{max_path_sum_brute(root2)}"  # 6
  puts "Opt:   #{max_path_sum(root2)}"         # 6
end
