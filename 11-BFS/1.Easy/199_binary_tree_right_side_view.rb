# frozen_string_literal: true

# LeetCode 199: Binary Tree Right Side View
#
# Problem:
# Given the root of a binary tree, imagine standing on the right side of it.
# Return the values of the nodes you can see ordered from top to bottom.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS: traverse right-first, track depth, keep only the first value seen
#    at each depth (which is the rightmost).
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# 2. Bottleneck
#    Both DFS and BFS are O(n) — BFS directly gives the last element per level.
#
# 3. Optimized Accepted Approach
#    BFS level-by-level. After processing each level, the last node seen is the
#    rightmost visible node. Append its value.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1 -> [2, 3] -> [null, 5, null, 4]
# Level 0: last=1 → [1]
# Level 1: last=3 → [1, 3]
# Level 2: last=4 → [1, 3, 4]  (5 is hidden behind 4)
# result = [1, 3, 4] ✓
#
# Edge Cases:
# - Empty tree -> []
# - Left-skewed tree -> each level has one node, all are "right side"

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def right_side_view_brute(root)
  result = {}
  dfs = lambda do |node, depth|
    return unless node
    result[depth] = node.val  # right-first DFS overwrites left with right
    dfs.call(node.right, depth + 1)
    dfs.call(node.left,  depth + 1)
  end
  dfs.call(root, 0)
  result.keys.sort.map { |k| result[k] }
end

def right_side_view(root)
  return [] unless root

  result = []
  queue  = [root]

  until queue.empty?
    last = nil
    queue.size.times do
      node = queue.shift
      last = node.val        # last node in this level = rightmost visible
      queue << node.left  if node.left
      queue << node.right if node.right
    end
    result << last
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2, nil, TreeNode.new(5)), TreeNode.new(3, nil, TreeNode.new(4)))
  puts "Brute: #{right_side_view_brute(root).inspect}"  # [1, 3, 4]
  puts "Opt:   #{right_side_view(root).inspect}"         # [1, 3, 4]
end
