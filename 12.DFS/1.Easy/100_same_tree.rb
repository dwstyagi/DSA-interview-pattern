# frozen_string_literal: true

# LeetCode 100: Same Tree
#
# Problem:
# Given the roots of two binary trees p and q, return true if they are the same
# tree (same structure and same node values).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Serialize both trees (e.g., pre-order with nulls), compare strings.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Same complexity — parallel DFS is simpler and more direct.
#
# 3. Optimized Accepted Approach
#    Parallel DFS on both trees simultaneously. At each step check:
#    both null (true), one null (false), values differ (false), else recurse.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# p=1->[2,3], q=1->[2,3]
# same_tree(1,1) → vals equal → same_tree(2,2) ✓ && same_tree(3,3) ✓ → true ✓
#
# Edge Cases:
# - Both empty -> true
# - One empty -> false
# - Same structure, different values -> false

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def is_same_tree_brute(p, q)
  serialize = lambda do |node|
    return "N" unless node
    "#{node.val},#{serialize.call(node.left)},#{serialize.call(node.right)}"
  end
  serialize.call(p) == serialize.call(q)
end

def is_same_tree(p, q)
  return true  if p.nil? && q.nil?   # both null → identical
  return false if p.nil? || q.nil?   # one null → different structure
  return false if p.val != q.val      # different values

  is_same_tree(p.left, q.left) && is_same_tree(p.right, q.right)
end

if __FILE__ == $PROGRAM_NAME
  p1 = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))
  q1 = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3))
  puts "Brute: #{is_same_tree_brute(p1, q1)}"  # true
  puts "Opt:   #{is_same_tree(p1, q1)}"          # true

  p2 = TreeNode.new(1, TreeNode.new(2), nil)
  q2 = TreeNode.new(1, nil, TreeNode.new(2))
  puts "Brute: #{is_same_tree_brute(p2, q2)}"  # false
  puts "Opt:   #{is_same_tree(p2, q2)}"          # false
end
