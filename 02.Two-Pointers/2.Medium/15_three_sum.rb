# frozen_string_literal: true

# LeetCode 15: 3Sum
#
# Problem:
# Given an integer array nums, return all triplets [nums[i], nums[j], nums[k]]
# such that i, j, k are distinct indices and nums[i] + nums[j] + nums[k] == 0.
# The solution must not contain duplicate triplets.
#
# Examples:
#   Input:  nums = [-1,0,1,2,-1,-4]
#   Output: [[-1,-1,2],[-1,0,1]]
#   Why:    Sort -> [-4,-1,-1,0,1,2]. Fix each element, two-pointer on the rest for sum=0.
#
#   Input:  nums = [0,1,1]
#   Output: []
#   Why:    No three numbers sum to 0 — only triplet is [0,1,1]=2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every triplet (i, j, k) with i < j < k.
#    If three values sum to 0, add sorted triplet to a Set to avoid duplicates.
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Three nested loops check every combination unnecessarily.
#    If we sort the array first, for a fixed i we can use two pointers
#    (left, right) to find pairs summing to -nums[i] in O(n) instead of O(n^2).
#    Sorting also makes duplicate skipping easy without a Set.
#
# 3. Optimized Accepted Approach
#    Sort the array. For each index i, use two pointers left = i+1, right = n-1.
#    Find pairs where nums[left] + nums[right] == -nums[i].
#    - sum < 0 -> move left right
#    - sum > 0 -> move right left
#    - sum == 0 -> record triplet, move both, skip duplicates
#    Skip duplicate values of i to avoid duplicate triplets.
#
#    Time Complexity: O(n^2) — O(n log n) sort + O(n^2) two pointers
#    Space Complexity: O(1) — excluding output
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-1, 0, 1, 2, -1, -4] -> sorted: [-4, -1, -1, 0, 1, 2]
#
# i=0, nums[i]=-4, left=1, right=5
#   sum = -4 + -1 + 2 = -3 < 0 -> left++
#   sum = -4 + -1 + 2 = -3 < 0 -> left++
#   sum = -4 + 0 + 2 = -2 < 0 -> left++
#   sum = -4 + 1 + 2 = -1 < 0 -> left++
#   left == right, stop
#
# i=1, nums[i]=-1, left=2, right=5
#   sum = -1 + -1 + 2 = 0 -> result=[[-1,-1,2]], left++, right--
#   sum = -1 + 0 + 1 = 0 -> result=[[-1,-1,2],[-1,0,1]], left++, right--
#   left == right, stop
#
# i=2, nums[i]=-1, skip (nums[2] == nums[1])
#
# i=3, nums[i]=0, left=4, right=5
#   sum = 0 + 1 + 2 = 3 > 0 -> right--
#   left == right, stop
#
# Final answer = [[-1, -1, 2], [-1, 0, 1]]
#
# Edge Cases:
# - Fewer than 3 elements -> return []
# - All zeros -> return [[0, 0, 0]]
# - No valid triplet -> return []

def three_sum_brute(nums)
  len = nums.length
  (0...len).each_with_object(Set.new) do |idx, result|
    ((idx + 1)...len).each do |j|
      ((j + 1)...len).each do |k|
        result.add([nums[idx], nums[j], nums[k]].sort) if (nums[idx] + nums[j] + nums[k]).zero?
      end
    end
  end.to_a
end

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
def three_sum(nums)
  nums.sort!
  result = []

  (0...(nums.size - 2)).each do |i|
    next if i.positive? && nums[i] == nums[i - 1] # Skip duplicates

    left = i + 1
    right = nums.size - 1

    while left < right
      sum = nums[i] + nums[left] + nums[right]

      if sum.zero?
        # Record triplet
        result << [nums[i], nums[left], nums[right]]
        left += 1
        right -= 1

        # Skip duplicates
        left += 1 while left < right && nums[left] == nums[left - 1]
        right -= 1 while left < right && nums[right] == nums[right + 1]

      elsif sum.negative?
        left += 1
      else
        right -= 1
      end
    end
  end

  result
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

if __FILE__ == $PROGRAM_NAME
  nums = [-1, 0, 1, 2, -1, -4]

  puts "Brute force: #{three_sum_brute(nums)}"
  puts "Optimized:   #{three_sum(nums)}"
end
