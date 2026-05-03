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

def last_stone_weight_brute(stones)
  arr = stones.dup
  while arr.size > 1
    arr.sort!                    # sort ascending each round
    y = arr.pop                  # heaviest
    x = arr.pop                  # second heaviest
    arr << (y - x) if y != x    # push remainder if not equal
  end
  arr.empty? ? 0 : arr[0]
end

def last_stone_weight(stones)
  # Simulate max-heap with sorted array (sort once, insert in order)
  arr = stones.sort              # ascending; treat last element as max
  while arr.size > 1
    y = arr.pop                  # heaviest
    x = arr.pop                  # second heaviest
    if y != x
      diff = y - x
      # binary insert to maintain sorted order
      idx = arr.bsearch_index { |v| v >= diff } || arr.size
      arr.insert(idx, diff)
    end
  end
  arr.empty? ? 0 : arr[0]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{last_stone_weight_brute([2, 7, 4, 1, 8, 1])}"  # 1
  puts "Opt:   #{last_stone_weight([2, 7, 4, 1, 8, 1])}"        # 1
  puts "Brute: #{last_stone_weight_brute([1])}"                  # 1
  puts "Opt:   #{last_stone_weight([1])}"                        # 1
end
