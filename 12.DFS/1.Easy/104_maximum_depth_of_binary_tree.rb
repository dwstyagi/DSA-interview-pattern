# frozen_string_literal: true

# LeetCode 104: Maximum Depth of Binary Tree
#
# Problem:
# Given the root of a binary tree, return its maximum depth (number of nodes
# along the longest path from root to the farthest leaf node).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS level-order, count levels.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Both BFS and DFS are O(n) — DFS is more concise recursively.
#
# 3. Optimized Accepted Approach
#    Post-order DFS: max depth = 1 + max(left_depth, right_depth).
#    Base case: null node returns 0.
#    Time Complexity: O(n)
#    Space Complexity: O(h) — recursion stack, h = height
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3 -> [9, 20] -> [null, null, 15, 7]
# dfs(3) = 1 + max(dfs(9), dfs(20))
# dfs(9) = 1 + max(0, 0) = 1
# dfs(20)= 1 + max(dfs(15), dfs(7)) = 1 + max(1,1) = 2
# dfs(3) = 1 + max(1, 2) = 3 ✓
#
# Edge Cases:
# - Empty tree -> 0
# - Single node -> 1
# - Skewed tree -> n

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def max_depth_brute(root)
  return 0 unless root
  queue = [root]
  depth = 0
  until queue.empty?
    queue.size.times { node = queue.shift; queue << node.left if node.left; queue << node.right if node.right }
    depth += 1
  end
  depth
end

def max_depth(root)
  return 0 unless root
  1 + [max_depth(root.left), max_depth(root.right)].max
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{max_depth_brute(root)}"  # 3
  puts "Opt:   #{max_depth(root)}"         # 3
end
