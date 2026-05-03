# frozen_string_literal: true

# LeetCode 101: Symmetric Tree
#
# Problem:
# Given the root of a binary tree, check whether it is a mirror of itself
# (i.e., symmetric around its center).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect left subtree in-order and right subtree in reverse in-order,
#    compare sequences.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Same complexity — mirror DFS is the cleanest approach.
#
# 3. Optimized Accepted Approach
#    Mirror DFS: check if left.left mirrors right.right and left.right mirrors
#    right.left. Root calls mirror(root.left, root.right).
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1 -> [2, 2] -> [3, 4, 4, 3]
# mirror(2, 2): vals equal → mirror(3,3) ✓ && mirror(4,4) ✓ → true
# mirror(root.l, root.r) → true ✓
#
# Edge Cases:
# - Single node -> true
# - Left-only tree -> false
# - Different values at mirror positions -> false

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def is_symmetric_brute(root)
  serialize_left  = lambda { |n| n ? "#{n.val},#{serialize_left.call(n.left)},#{serialize_left.call(n.right)}" : "N" }
  serialize_right = lambda { |n| n ? "#{n.val},#{serialize_right.call(n.right)},#{serialize_right.call(n.left)}" : "N" }
  return true unless root
  serialize_left.call(root.left) == serialize_right.call(root.right)
end

def is_symmetric(root)
  mirror = lambda do |left, right|
    return true  if left.nil? && right.nil?
    return false if left.nil? || right.nil?
    return false if left.val != right.val
    mirror.call(left.left, right.right) && mirror.call(left.right, right.left)
  end

  return true unless root
  mirror.call(root.left, root.right)
end

if __FILE__ == $PROGRAM_NAME
  root1 = TreeNode.new(1, TreeNode.new(2, TreeNode.new(3), TreeNode.new(4)), TreeNode.new(2, TreeNode.new(4), TreeNode.new(3)))
  puts "Brute: #{is_symmetric_brute(root1)}"  # true
  puts "Opt:   #{is_symmetric(root1)}"          # true

  root2 = TreeNode.new(1, TreeNode.new(2, nil, TreeNode.new(3)), TreeNode.new(2, nil, TreeNode.new(3)))
  puts "Brute: #{is_symmetric_brute(root2)}"  # false
  puts "Opt:   #{is_symmetric(root2)}"          # false
end
