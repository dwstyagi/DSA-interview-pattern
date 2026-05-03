# frozen_string_literal: true

# LeetCode 297: Serialize and Deserialize Binary Tree
#
# Problem:
# Design an algorithm to serialize a binary tree to a string and deserialize
# the string back to the original tree structure.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Level-order (BFS) serialization with null markers.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Both BFS and DFS approaches are O(n). Pre-order DFS with null sentinels
#    is simpler to implement recursively.
#
# 3. Optimized Accepted Approach
#    Serialize: pre-order DFS. Write node.val or "N" for null, comma-separated.
#    Deserialize: split by comma, use index pointer. Recursively rebuild.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# Tree: 1->[2,3]->[null,null,4,5]
# Serialize: "1,2,N,N,3,4,N,N,5,N,N"
# Deserialize: read 1→node(1); read 2→node(2); read N→nil; read N→nil;
#              read 3→node(3); etc. → original tree ✓
#
# Edge Cases:
# - Empty tree -> "N"
# - Single node -> "1,N,N"

# rubocop:disable Style/Documentation
class TreeNode
  attr_accessor :val, :left, :right
  def initialize(val = 0, left = nil, right = nil)
    @val = val; @left = left; @right = right
  end
end
# rubocop:enable Style/Documentation

def serialize(root)
  result = []
  pre_order = lambda do |node|
    if node
      result << node.val.to_s
      pre_order.call(node.left)
      pre_order.call(node.right)
    else
      result << 'N'              # sentinel for null
    end
  end
  pre_order.call(root)
  result.join(',')
end

def deserialize(data)
  tokens = data.split(',')
  idx    = [0]

  build = lambda do
    token = tokens[idx[0]]
    idx[0] += 1
    return nil if token == 'N'
    node       = TreeNode.new(token.to_i)
    node.left  = build.call
    node.right = build.call
    node
  end

  build.call
end

if __FILE__ == $PROGRAM_NAME
  root = TreeNode.new(1, TreeNode.new(2), TreeNode.new(3, TreeNode.new(4), TreeNode.new(5)))
  serialized = serialize(root)
  puts "Serialized: #{serialized}"    # "1,2,N,N,3,4,N,N,5,N,N"
  restored = deserialize(serialized)
  puts "Restored root: #{restored.val}, right: #{restored.right.val}"  # 1, 3
end
