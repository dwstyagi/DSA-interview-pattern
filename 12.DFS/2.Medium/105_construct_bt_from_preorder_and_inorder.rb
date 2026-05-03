# frozen_string_literal: true

# LeetCode 105: Construct Binary Tree from Preorder and Inorder Traversal
#
# Problem:
# Given two integer arrays preorder and inorder where preorder is the preorder
# traversal and inorder is the inorder traversal, construct and return the
# binary tree.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursively: preorder[0] is root. Find it in inorder to split left/right.
#    Linear search in inorder each time.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Linear search in inorder — use a hash map for O(1) lookup.
#
# 3. Optimized Accepted Approach
#    Build inorder index map. Recursive DFS: root = preorder[pre_idx].
#    Find split point in inorder via map. Recurse left and right.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# preorder=[3,9,20,15,7], inorder=[9,3,15,20,7]
# root=3, inorder_idx=1 → left_size=1
# left tree: preorder[1..1]=[9], inorder[0..0]=[9] → node 9
# right tree: preorder[2..4]=[20,15,7], inorder[2..4]=[15,20,7] → node 20->[15,7]
# result: 3->[9,20]->[15,7] ✓
#
# Edge Cases:
# - Single element -> single node
# - Right-skewed input

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def build_tree_brute(preorder, inorder)
  return nil if preorder.empty?
  root_val = preorder[0]
  root     = TreeNode.new(root_val)
  mid      = inorder.index(root_val)
  root.left  = build_tree_brute(preorder[1..mid], inorder[0...mid])
  root.right = build_tree_brute(preorder[mid+1..], inorder[mid+1..])
  root
end

def build_tree(preorder, inorder)
  idx_map = {}
  inorder.each_with_index { |v, i| idx_map[v] = i }
  pre_idx = [0]  # mutable reference to track current preorder position

  build = lambda do |in_lo, in_hi|
    return nil if in_lo > in_hi

    root_val = preorder[pre_idx[0]]
    pre_idx[0] += 1
    root     = TreeNode.new(root_val)
    mid      = idx_map[root_val]          # O(1) lookup

    root.left  = build.call(in_lo,  mid - 1)  # left subtree in inorder
    root.right = build.call(mid + 1, in_hi)   # right subtree in inorder
    root
  end

  build.call(0, inorder.length - 1)
end

if __FILE__ == $PROGRAM_NAME
  root = build_tree([3, 9, 20, 15, 7], [9, 3, 15, 20, 7])
  puts "Opt root: #{root.val}, left: #{root.left.val}, right: #{root.right.val}"  # 3, 9, 20
end
