# frozen_string_literal: true

# LeetCode 111: Minimum Depth of Binary Tree
#
# Problem:
# Given a binary tree, find its minimum depth. The minimum depth is the number
# of nodes along the shortest path from the root to the nearest leaf node.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS: recurse both children, return min of non-null paths. Handle the
#    skewed-tree case (one child null doesn't count as a leaf).
#    Time Complexity: O(n)
#    Space Complexity: O(h) — recursion stack
#
# 2. Bottleneck
#    DFS visits the entire tree in worst case. BFS short-circuits at the first
#    leaf found (optimal for wide shallow trees).
#
# 3. Optimized Accepted Approach
#    BFS level-by-level. Return depth as soon as we dequeue a leaf node.
#    Time Complexity: O(n) worst case, O(w * d) where d is min depth
#    Space Complexity: O(w) — max width of BFS queue
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 2 -> [null, 3] -> [4] -> [5] -> [6]
# Brute DFS returns 5 (root-to-6); BFS finds 6 at depth 5.
# Single-child nodes are NOT leaves, so we must go all the way down.
#
# Edge Cases:
# - Empty tree -> 0
# - Single node -> 1
# - Skewed (all right children) -> n

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def min_depth_brute(root)
  return 0 unless root
  return 1 if root.left.nil? && root.right.nil?                 # leaf

  return 1 + min_depth_brute(root.right) if root.left.nil?      # skip null left
  return 1 + min_depth_brute(root.left)  if root.right.nil?     # skip null right

  1 + [min_depth_brute(root.left), min_depth_brute(root.right)].min
end

def min_depth(root)
  return 0 unless root

  queue = [[root, 1]]

  until queue.empty?
    node, depth = queue.shift
    return depth if node.left.nil? && node.right.nil? # first leaf found

    queue << [node.left,  depth + 1] if node.left
    queue << [node.right, depth + 1] if node.right
  end
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{min_depth_brute(root)}"  # 2
  puts "Opt:   #{min_depth(root)}"         # 2

  skewed = TreeNode.new(1, nil, TreeNode.new(2))
  puts "Brute: #{min_depth_brute(skewed)}"  # 2
  puts "Opt:   #{min_depth(skewed)}"         # 2
end
