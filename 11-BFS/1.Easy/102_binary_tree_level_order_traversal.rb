# frozen_string_literal: true

# LeetCode 102: Binary Tree Level Order Traversal
#
# Problem:
# Given the root of a binary tree, return the level order traversal of its
# nodes' values (i.e., from left to right, level by level).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS with level parameter, group into a hash by level, collect in order.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    DFS works but BFS is more natural for level-order; same complexity.
#
# 3. Optimized Accepted Approach
#    BFS with a queue. Snapshot queue size at start of each level, pop exactly
#    that many nodes, enqueue their children, append level to result.
#    Time Complexity: O(n)
#    Space Complexity: O(n) — up to n/2 nodes in queue at leaf level
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 3 -> [9, 20] -> [null, null, 15, 7]
# Level 0: q=[3] size=1 → pop 3, enqueue 9,20 → level=[3]
# Level 1: q=[9,20] size=2 → pop 9(no children), 20(enqueue 15,7) → level=[9,20]
# Level 2: q=[15,7] size=2 → pop both, no children → level=[15,7]
# result = [[3],[9,20],[15,7]] ✓
#
# Edge Cases:
# - Empty tree -> []
# - Single node -> [[root.val]]

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val   = val
    @left  = left
    @right = right
  end
end
# rubocop:enable Style/Documentation

def level_order_brute(root)
  levels = {}
  dfs = lambda do |node, depth|
    return unless node
    (levels[depth] ||= []) << node.val
    dfs.call(node.left,  depth + 1)
    dfs.call(node.right, depth + 1)
  end
  dfs.call(root, 0)
  levels.keys.sort.map { |k| levels[k] }
end

def level_order(root)
  return [] unless root

  result = []
  queue  = [root]

  until queue.empty?
    level = []
    queue.size.times do       # process exactly one level per iteration
      node = queue.shift
      level << node.val
      queue << node.left  if node.left
      queue << node.right if node.right
    end
    result << level
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(3, TreeNode.new(9), TreeNode.new(20, TreeNode.new(15), TreeNode.new(7)))
  puts "Brute: #{level_order_brute(root).inspect}"  # [[3],[9,20],[15,7]]
  puts "Opt:   #{level_order(root).inspect}"         # [[3],[9,20],[15,7]]
end
