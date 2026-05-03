# frozen_string_literal: true

# LeetCode 637: Average of Levels in Binary Tree
#
# Problem:
# Given the root of a binary tree, return the average value of the nodes on
# each level in the form of an array.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS collecting all values per level in a hash, then compute averages.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Same complexity — BFS is cleaner and more natural for level grouping.
#
# 3. Optimized Accepted Approach
#    BFS level-by-level. Snapshot queue size, sum values for that level,
#    divide by count.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3 -> [9, 20] -> [15, 7]
# Level 0: sum=3, count=1 → avg=3.0
# Level 1: sum=29, count=2 → avg=14.5
# Level 2: sum=22, count=2 → avg=11.0
# result = [3.0, 14.5, 11.0] ✓
#
# Edge Cases:
# - Single node -> [node.val]
# - All nodes on one side (skewed tree)

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def average_of_levels_brute(root)
  levels = {}
  dfs = lambda do |node, d|
    return unless node
    (levels[d] ||= []) << node.val
    dfs.call(node.left, d + 1)
    dfs.call(node.right, d + 1)
  end
  dfs.call(root, 0)
  levels.keys.sort.map { |k| levels[k].sum.to_f / levels[k].size }
end

def average_of_levels(root)
  return [] unless root

  result = []
  queue  = [root]

  until queue.empty?
    size = queue.size
    sum  = 0
    size.times do
      node = queue.shift
      sum += node.val
      queue << node.left  if node.left
      queue << node.right if node.right
    end
    result << sum.to_f / size
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{average_of_levels_brute(root).inspect}"  # [3.0, 14.5, 11.0]
  puts "Opt:   #{average_of_levels(root).inspect}"         # [3.0, 14.5, 11.0]
end
