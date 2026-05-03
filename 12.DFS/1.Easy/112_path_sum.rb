# frozen_string_literal: true

# LeetCode 112: Path Sum
#
# Problem:
# Given the root of a binary tree and an integer targetSum, return true if the
# tree has a root-to-leaf path such that the sum of values along the path equals
# targetSum.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS collecting all root-to-leaf sums, check if targetSum is among them.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# 2. Bottleneck
#    Same complexity — can subtract from target as we go (no extra storage).
#
# 3. Optimized Accepted Approach
#    DFS: subtract node value from remaining target. At each leaf, check if
#    remaining == 0.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 5->[4,8]->[11,null]->[7,2], target=22
# 5→4→11→7: remaining=22-5-4-11-7=−5 (not leaf check... actually 7 is a leaf? no, 11 has children)
# 5→4→11→2: 22-5-4-11-2=0, leaf node 2 → true ✓
#
# Edge Cases:
# - Empty tree -> false
# - Single node matching target -> true
# - Negative values in path

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def has_path_sum_brute(root, target_sum)
  sums = []
  dfs = lambda do |node, current|
    return unless node
    current += node.val
    sums << current if node.left.nil? && node.right.nil?
    dfs.call(node.left,  current)
    dfs.call(node.right, current)
  end
  dfs.call(root, 0)
  sums.include?(target_sum)
end

def has_path_sum(root, target_sum)
  return false unless root

  remaining = target_sum - root.val
  return remaining.zero? if root.left.nil? && root.right.nil? # leaf check

  has_path_sum(root.left, remaining) || has_path_sum(root.right, remaining)
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(5,
    TreeNode.new(4, TreeNode.new(11, TreeNode.new(7), TreeNode.new(2)), nil),
    TreeNode.new(8, TreeNode.new(13), TreeNode.new(4, nil, TreeNode.new(1))))
  puts "Brute: #{has_path_sum_brute(root, 22)}"  # true
  puts "Opt:   #{has_path_sum(root, 22)}"          # true
  puts "Brute: #{has_path_sum_brute(root, 5)}"    # false
  puts "Opt:   #{has_path_sum(root, 5)}"            # false
end
