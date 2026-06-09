# frozen_string_literal: true

# LeetCode 1046: Last Stone Weight
#
# Problem:
# You have an array of stones where stones[i] is the weight of the ith stone.
# Each turn, choose the two heaviest stones and smash them together.
# If they are equal, both destroyed. Otherwise, the smaller is destroyed and
# the larger loses the smaller's weight. Return the weight of the last stone,
# or 0 if none remain.
#
# Examples:
#   Input:  stones = [2,7,4,1,8,1]
#   Output: 1
#   Why:    Smash 8+7=1 left, then 4+2=2, then 2+1=1. One stone remains.
#
#   Input:  stones = [1]
#   Output: 1
#   Why:    Only one stone — nothing to smash, return it as-is.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the array on every turn to find the two heaviest stones.
#    Time Complexity: O(n² log n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Re-sorting after every smash is wasteful — we only need the top two
#    elements each time.
#
# 3. Optimized Accepted Approach
#    Use a max-heap (simulate with sorted array in Ruby, since no built-in heap).
#    Push both stones in, pop two largest, push diff if non-zero.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# stones = [2, 7, 4, 1, 8, 1]
# Heap: [8, 7, 4, 2, 1, 1]
# Smash 8 & 7 → diff = 1 → heap [4, 2, 1, 1, 1]
# Smash 4 & 2 → diff = 2 → heap [2, 1, 1, 1]
# Smash 2 & 1 → diff = 1 → heap [1, 1, 1]
# Smash 1 & 1 → equal → heap [1]
# Return 1
#
# Edge Cases:
# - Single stone -> return that stone
# - Two equal stones -> return 0

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Repeatedly sort the array
# - Take the two largest stones
# - Smash them
# - Put back the difference if non-zero
# - Continue until at most one stone remains
#
# Time: O(n^2 log n) in repeated sorting style
# Space: O(1) extra beyond array operations
def last_stone_weight_true_brute_force(stones)
  stones = stones.dup

  while stones.length > 1
    # Sort so the two heaviest stones are at the end
    stones.sort!

    heaviest = stones.pop
    second_heaviest = stones.pop

    # If they are different, push the remaining weight back
    stones << (heaviest - second_heaviest) if heaviest != second_heaviest
  end

  stones.empty? ? 0 : stones[0]
end

# -----------------------------
# OPTIMIZED MAX-HEAP SOLUTION
# -----------------------------
# Idea:
# - Use a max heap so the largest stone is always available quickly
# - Pop the two heaviest stones
# - If different, push back the difference
# - Continue until heap size is 0 or 1
#
# Time: O(n log n)
# Space: O(n)
require 'algorithms'
def last_stone_weight(stones)
  max_heap = Containers::MaxHeap.new

  # Build max heap with all stones
  stones.each do |stone|
    max_heap.push(stone)
  end

  # Keep smashing while at least two stones remain
  while max_heap.size > 1
    heaviest = max_heap.pop
    second_heaviest = max_heap.pop

    # Push back the remaining weight if non-zero
    max_heap.push(heaviest - second_heaviest) if heaviest != second_heaviest
  end

  max_heap.empty? ? 0 : max_heap.pop
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{last_stone_weight_brute([2, 7, 4, 1, 8, 1])}"  # 1
  puts "Opt:   #{last_stone_weight([2, 7, 4, 1, 8, 1])}"        # 1
  puts "Brute: #{last_stone_weight_brute([1])}"                  # 1
  puts "Opt:   #{last_stone_weight([1])}"                        # 1
end
