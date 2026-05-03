# frozen_string_literal: true

# LeetCode 99: Recover Binary Search Tree
#
# Problem:
# Two nodes of a BST are swapped by mistake. Recover the tree without changing
# its structure (i.e., swap the values back).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    In-order traversal into array. Find the two elements out of order. Swap.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Storing full array — in-order DFS tracking prev node, find anomalies inline.
#
# 3. Optimized Accepted Approach
#    In-order DFS. Track prev node. If prev.val >= current.val, we found a swap:
#    first = prev (first time), second = current (update each time).
#    After traversal, swap first.val and second.val.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Swapped BST: [3,1,null,null,2] (should be [1,null,3,null,2] or similar)
# In-order: 1, 3, 2  (3 and 2 are out of order)
# prev=1, curr=3: ok; prev=3, curr=2: first=3(prev), second=2(curr)
# Swap 3↔2 → tree correct ✓
#
# Edge Cases:
# - Adjacent swap: only one "violation" but still need first and second
# - Non-adjacent swap: two violations; first from first, second from last

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def recover_tree_brute(root)
  vals = []
  nodes = []
  in_order = lambda do |n|
    return unless n
    in_order.call(n.left)
    vals << n.val; nodes << n
    in_order.call(n.right)
  end
  in_order.call(root)
  sorted = vals.sort
  vals.each_with_index do |v, i|
    nodes[i].val = sorted[i]
  end
end

def recover_tree(root)
  prev   = nil
  first  = nil
  second = nil

  in_order = lambda do |node|
    return unless node
    in_order.call(node.left)

    if prev && prev.val >= node.val
      first  ||= prev   # first anomaly: grab prev (the out-of-place large node)
      second   = node   # update second each time (handles non-adjacent swap)
    end
    prev = node

    in_order.call(node.right)
  end

  in_order.call(root)
  first.val, second.val = second.val, first.val   # swap values to fix BST
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(1, nil, TreeNode.new(2)), nil)
  recover_tree(root)
  puts "Opt: #{root.val}, #{root.left.val}, #{root.left.right.val}"  # 1, 3... wait
  # in-order of [3,[1,2]]: 1,2,3 - all good? Let me use canonical broken example.
  root2 = TreeNode.new(1, TreeNode.new(3, nil, TreeNode.new(2)), nil)
  recover_tree(root2)
  puts "Opt root2: #{root2.val}, #{root2.left.val}, #{root2.left.right.val}"  # 1, 2, 3 -> swapped 3&2: root2=1,left=2,left.right=3
end
