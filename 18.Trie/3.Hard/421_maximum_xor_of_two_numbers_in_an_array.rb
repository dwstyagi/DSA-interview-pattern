# frozen_string_literal: true

# LeetCode 421: Maximum XOR of Two Numbers in an Array
#
# Problem:
# Given integer array nums, return the maximum XOR of any two elements.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs (i, j), compute XOR, track maximum.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n^2) pairs. Binary trie: insert all numbers bit by bit (MSB first).
#    For each number, greedily pick opposite bits to maximize XOR.
#
# 3. Optimized Accepted Approach
#    Build a binary trie of all numbers (32 bits MSB to LSB).
#    For each number, traverse trie picking the opposite bit when available.
#
#    Time Complexity: O(n * 32) = O(n)
#    Space Complexity: O(n * 32)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 10, 5, 25, 2, 8]
# Insert all in trie (32-bit). For 25 (11001):
# traverse: want 0 at bit 31? both 0. ... at bit 4: 25=1, want 0 -> pick 0 (number with 0 at bit4)
# After greedy traversal, best XOR = 28 (25 XOR 5 = 28)
#
# Edge Cases:
# - Single element: XOR with itself = 0
# - All same: XOR = 0

class XORNode
  attr_accessor :children

  def initialize
    @children = {}
  end
end

def find_maximum_xor_brute(nums)
  max_xor = 0
  n = nums.length
  n.times { |i| n.times { |j| max_xor = [max_xor, nums[i] ^ nums[j]].max } }
  max_xor
end

def find_maximum_xor(nums)
  root = XORNode.new

  insert = lambda do |num|
    node = root
    31.downto(0) do |i|
      bit = (num >> i) & 1
      node.children[bit] ||= XORNode.new
      node = node.children[bit]
    end
  end

  max_xor_for = lambda do |num|
    node = root
    xor_val = 0
    31.downto(0) do |i|
      bit = (num >> i) & 1
      want = 1 - bit
      if node.children.key?(want)
        xor_val |= (1 << i)
        node = node.children[want]
      else
        node = node.children[bit]
      end
    end
    xor_val
  end

  nums.each { |n| insert.call(n) }
  nums.map { |n| max_xor_for.call(n) }.max
end

if __FILE__ == $PROGRAM_NAME
  puts find_maximum_xor_brute([3, 10, 5, 25, 2, 8])  # 28
  puts find_maximum_xor([0])                           # 0
end
