# frozen_string_literal: true

# LeetCode 113: Path Sum II
#
# Problem:
# Given the root of a binary tree and targetSum, return all root-to-leaf paths
# where the sum of node values equals targetSum.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS collecting all root-to-leaf paths, filter by sum == targetSum.
#    Time Complexity: O(n^2) — path duplication at leaf
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Collecting full paths — pass the current path, backtrack on return.
#
# 3. Optimized Accepted Approach
#    DFS with backtracking. Append node to path, subtract from remaining target.
#    At leaf: if remaining == 0, record path copy. Pop on return.
#    Time Complexity: O(n^2) — copying path at leaf is O(n)
#    Space Complexity: O(n) path + O(h) recursion
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 5->[4,8] 4->[11] 11->[7,2] 8->[13,4] 4->[5,1], target=22
# path: 5,4,11,7 sum=27 (no); 5,4,11,2 sum=22 ✓; 5,8,13 sum=26 (no);
#       5,8,4,5 sum=22 ✓; 5,8,4,1 sum=18 (no)
# result=[[5,4,11,2],[5,8,4,5]] ✓
#
# Edge Cases:
# - No valid paths -> []
# - Negative values can be part of valid paths

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def path_sum_brute(root, target_sum)
  result = []
  dfs = lambda do |node, path, remaining|
    return unless node
    path << node.val
    remaining -= node.val
    result << path.dup if node.left.nil? && node.right.nil? && remaining.zero?
    dfs.call(node.left,  path, remaining)
    dfs.call(node.right, path, remaining)
    path.pop
  end
  dfs.call(root, [], target_sum)
  result
end

def path_sum(root, target_sum)
  result = []

  dfs = lambda do |node, path, remaining|
    return unless node
    path << node.val
    remaining -= node.val

    if node.left.nil? && node.right.nil? && remaining.zero?
      result << path.dup          # leaf with exact sum → record
    else
      dfs.call(node.left,  path, remaining)
      dfs.call(node.right, path, remaining)
    end

    path.pop                       # backtrack
  end

  dfs.call(root, [], target_sum)
  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(5,
    TreeNode.new(4, TreeNode.new(11, TreeNode.new(7), TreeNode.new(2)), nil),
    TreeNode.new(8, TreeNode.new(13), TreeNode.new(4, TreeNode.new(5), TreeNode.new(1))))
  puts "Brute: #{path_sum_brute(root, 22).inspect}"  # [[5,4,11,2],[5,8,4,5]]
  puts "Opt:   #{path_sum(root, 22).inspect}"          # [[5,4,11,2],[5,8,4,5]]
end
