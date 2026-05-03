# frozen_string_literal: true

# LeetCode 236: Lowest Common Ancestor of a Binary Tree
#
# Problem:
# Given a binary tree and two nodes p and q, find their lowest common ancestor
# (LCA). The LCA is the deepest node that is an ancestor of both p and q.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find path from root to p and path from root to q. Last common node in
#    both paths is the LCA.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Storing two paths — single post-order DFS pass.
#
# 3. Optimized Accepted Approach
#    Post-order DFS. If current node is p or q, return it. The LCA is the
#    node where both left and right subtrees return non-nil. If only one side
#    returns non-nil, propagate that up.
#    Time Complexity: O(n)
#    Space Complexity: O(h)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3->[5,1] 5->[6,2] 2->[7,4] 1->[0,8], p=5, q=1
# dfs(3): left=dfs(5)=5(found p), right=dfs(1)=1(found q) → both non-nil → return 3 ✓
#
# Tree: p=5, q=4
# dfs(5): is p → return 5; dfs(3): left=5, right=nil(no q found yet) → return 5
# But wait: dfs(2): right=dfs(4)=4; dfs(5): right=dfs(2)=4...
# Actually dfs(5) returns 5 (early return on finding p), dfs(1) returns nil,
# dfs(3): left=5, right=nil → return 5. But 4 is under 5 so 5 is LCA ✓
#
# Edge Cases:
# - p or q is the root -> root is LCA
# - One node is ancestor of the other

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def lowest_common_ancestor_brute(root, p, q)
  find_path = lambda do |node, target, path|
    return false unless node
    path << node
    return true if node == target
    return true if find_path.call(node.left, target, path) || find_path.call(node.right, target, path)
    path.pop
    false
  end

  path_p = []; find_path.call(root, p, path_p)
  path_q = []; find_path.call(root, q, path_q)
  set_q  = path_q.to_set
  path_p.reverse.find { |n| set_q.include?(n) }
end

def lowest_common_ancestor(root, p, q)
  return nil unless root
  return root if root == p || root == q  # found one of the targets

  left  = lowest_common_ancestor(root.left,  p, q)
  right = lowest_common_ancestor(root.right, p, q)

  # if both sides found a target, current node is LCA
  return root if left && right

  # otherwise propagate the non-nil result up
  left || right
end

if __FILE__ == $PROGRAM_NAME
  n6 = TreeNode.new(6); n7 = TreeNode.new(7); n4 = TreeNode.new(4)
  n2 = TreeNode.new(2, n7, n4); n5 = TreeNode.new(5, n6, n2)
  n0 = TreeNode.new(0); n8 = TreeNode.new(8); n1 = TreeNode.new(1, n0, n8)
  root = TreeNode.new(3, n5, n1)

  puts "Opt LCA(5,1): #{lowest_common_ancestor(root, n5, n1).val}"  # 3
  puts "Opt LCA(5,4): #{lowest_common_ancestor(root, n5, n4).val}"  # 5
end
