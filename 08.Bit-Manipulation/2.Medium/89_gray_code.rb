# frozen_string_literal: true

# LeetCode 89: Gray Code
#
# Problem:
# Given an integer n, return any valid n-bit gray code sequence.
# A gray code sequence has 2^n elements where:
# - Starts with 0
# - Each successive element differs by exactly one bit
# - All elements are distinct
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS/backtracking: start from 0, try all single-bit flips at each step.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(2^n)
#
# 2. Bottleneck
#    BFS is complex to implement for this.
#
# 3. Optimized Accepted Approach
#    Formula: gray(i) = i ^ (i >> 1).
#    This directly generates the standard Gray code sequence in O(1) per element.
#    Time Complexity: O(2^n)
#    Space Complexity: O(2^n) for result
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=2: generate 0..3
# i=0: 0 ^ 0 = 0  (00)
# i=1: 1 ^ 0 = 1  (01) — differs by 1 bit from 0 ✓
# i=2: 2 ^ 1 = 3  (11) — differs by 1 bit from 1 ✓
# i=3: 3 ^ 1 = 2  (10) — differs by 1 bit from 3 ✓
# Result: [0, 1, 3, 2]
#
# Edge Cases:
# - n=1 → [0, 1]
# - n=4 → 16 elements, all valid gray code

def gray_code_brute(n)
  result = [0]
  visited = { 0 => true }

  bfs = lambda do |current|
    return true if result.size == (1 << n)

    (0...n).each do |bit|
      next_val = current ^ (1 << bit)
      next if visited[next_val]

      visited[next_val] = true
      result << next_val
      return true if bfs.call(next_val)

      result.pop
      visited.delete(next_val)
    end

    false
  end

  bfs.call(0)
  result
end

def gray_code(n)
  (0...(1 << n)).map { |i| i ^ (i >> 1) }   # formula: i XOR (i/2)
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{gray_code_brute(2).inspect}"  # [0, 1, 3, 2]
  puts "Opt:   #{gray_code(2).inspect}"        # [0, 1, 3, 2]
  puts "Brute: #{gray_code_brute(1).inspect}"  # [0, 1]
  puts "Opt:   #{gray_code(1).inspect}"        # [0, 1]
end
