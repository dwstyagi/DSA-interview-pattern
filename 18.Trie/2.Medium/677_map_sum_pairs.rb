# frozen_string_literal: true

# LeetCode 677: Map Sum Pairs
#
# Problem:
# Implement MapSum with insert(key, val) and sum(prefix).
# sum returns total value of all keys starting with the given prefix.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Store key->val in a hash. For sum, iterate all keys and check prefix.
#    Time Complexity: O(n * m) for sum
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    sum requires scanning all keys. Trie: store sum at each node during insert.
#    Then sum(prefix) = just traverse to prefix node and return its stored sum.
#
# 3. Optimized Accepted Approach
#    Trie where each node stores a running sum. On insert, if key exists,
#    compute delta = new_val - old_val; add delta to all nodes along key's path.
#
#    Time Complexity: O(m) per operation
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# insert("apple", 3): a(3)->p(3)->p(3)->l(3)->e(3)
# insert("app", 2): a(5)->p(5)->p(5), l(3)->e(3) (only updates to 'p' at depth 3)
# sum("ap"): traverse a->p -> val=5
#
# Edge Cases:
# - Re-inserting same key with different value: update delta

class MapSumBrute
  def initialize
    @map = {}
  end

  def insert(key, val)
    @map[key] = val
  end

  def sum(prefix)
    @map.sum { |k, v| k.start_with?(prefix) ? v : 0 }
  end
end

class MapSumNode
  attr_accessor :children, :val

  def initialize
    @children = {}
    @val = 0
  end
end

class MapSum
  def initialize
    @root = MapSumNode.new
    @map = {}
  end

  def insert(key, val)
    delta = val - (@map[key] || 0)
    @map[key] = val
    node = @root
    key.each_char do |c|
      node.children[c] ||= MapSumNode.new
      node = node.children[c]
      node.val += delta
    end
  end

  def sum(prefix)
    node = @root
    prefix.each_char do |c|
      return 0 unless node.children.key?(c)
      node = node.children[c]
    end
    node.val
  end
end

if __FILE__ == $PROGRAM_NAME
  ms = MapSum.new
  ms.insert('apple', 3)
  puts ms.sum('ap')    # 3
  ms.insert('app', 2)
  puts ms.sum('ap')    # 5
end
