# frozen_string_literal: true

# LeetCode 561: Array Partition
#
# Problem:
# Given 2n integers, group them into n pairs to maximize the sum of min(a,b)
# for each pair. Return that maximum sum.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all possible pairings of 2n elements. For each pairing sum the minimums.
#    Time Complexity: O((2n)!)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Insight: to maximize sum of minimums, pair adjacent elements after sorting.
#    Larger gaps between paired elements waste the smaller element's value.
#
# 3. Optimized Accepted Approach
#    Sort the array. Sum elements at even indices (0, 2, 4, ...).
#    Each pair (arr[i], arr[i+1]) contributes arr[i] as the minimum.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 4, 3, 2]
# Sorted: [1, 2, 3, 4]
# Pairs: (1,2) -> min=1, (3,4) -> min=3
# Sum = 1 + 3 = 4
#
# Edge Cases:
# - All equal elements: sum = n * element
# - Two elements: return the smaller

def array_pair_sum_brute(nums)
  nums.sort.each_slice(2).sum(&:first)
end

# optimized: sort and sum even-indexed elements
def array_pair_sum(nums)
  sorted = nums.sort
  sum = 0
  (0...sorted.length).step(2) { |i| sum += sorted[i] }
  sum
end

if __FILE__ == $PROGRAM_NAME
  puts array_pair_sum_brute([1, 4, 3, 2])  # 4
  puts array_pair_sum([6, 2, 6, 5, 1, 2]) # 9
end
