# frozen_string_literal: true

# LeetCode 543: Diameter of Binary Tree
#
# Problem:
# Given the root of a binary tree, return the length of the diameter (the
# length of the longest path between any two nodes). The path may or may not
# pass through the root.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each node, compute left_height + right_height. Take maximum. Requires
#    computing height separately per node.
#    Time Complexity: O(n^2)
#    Space Complexity: O(h)
#
# 2. Bottleneck
#    Recomputing heights — post-order DFS computes height and updates diameter
#    in a single pass.
#
# 3. Optimized Accepted Approach
#    Post-order DFS returns height of subtree. At each node, update global max
#    with left_height + right_height. Return height = 1 + max(l, r).
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1->[2,3]->[4,5]
# dfs(4): h=0, diameter=max(0,0+0)=0 return 1
# dfs(5): h=0 return 1
# dfs(2): diameter=max(0,1+1)=2 return 2
# dfs(3): return 1
# dfs(1): diameter=max(2,2+1)=3 ✓
#
# Edge Cases:
# - Single node -> 0
# - Linear path (skewed) -> n-1

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def diameter_of_binary_tree_brute(root)
  height = lambda { |n| n ? 1 + [height.call(n.left), height.call(n.right)].max : 0 }
  max_d  = 0
  dfs = lambda do |n|
    return unless n
    max_d = [max_d, height.call(n.left) + height.call(n.right)].max
    dfs.call(n.left)
    dfs.call(n.right)
  end
  dfs.call(root)
  max_d
end

def diameter_of_binary_tree(root)
  max_d = 0

  dfs = lambda do |node|
    return 0 unless node
    l = dfs.call(node.left)
    r = dfs.call(node.right)
    max_d = [max_d, l + r].max    # path through this node
    1 + [l, r].max                # return height
  end

  dfs.call(root)
  max_d
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)), TreeNode.new(3))
  puts "Brute: #{diameter_of_binary_tree_brute(root)}"  # 3
  puts "Opt:   #{diameter_of_binary_tree(root)}"         # 3
end
