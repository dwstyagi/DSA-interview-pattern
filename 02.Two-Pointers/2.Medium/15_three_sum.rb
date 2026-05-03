# frozen_string_literal: true

# LeetCode 15: 3Sum
#
# Problem:
# Given an integer array nums, return all triplets [nums[i], nums[j], nums[k]]
# such that i, j, k are distinct indices and nums[i] + nums[j] + nums[k] == 0.
# The solution must not contain duplicate triplets.
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
    collect_triplets(nums, idx, len, result)
  end.to_a
end

def collect_triplets(nums, idx, len, result)
  ((idx + 1)...len).each do |j|
    ((j + 1)...len).each do |k|
      result.add([nums[idx], nums[j], nums[k]].sort) if (nums[idx] + nums[j] + nums[k]).zero?
    end
  end
end

def three_sum(nums)
  nums.sort!
  (0...(nums.length - 2)).each_with_object([]) do |idx, result|
    next if idx.positive? && nums[idx] == nums[idx - 1]

    result.concat(find_pairs(nums, idx))
  end
end

def find_pairs(nums, idx)
  result = []
  left = idx + 1
  right = nums.length - 1
  left, right = advance_from_sum(nums, result, idx, left, right) while left < right
  result
end

def advance_from_sum(nums, result, idx, left, right)
  sum = nums[idx] + nums[left] + nums[right]
  if sum.zero?
    result << [nums[idx], nums[left], nums[right]]
    skip_duplicates(nums, left + 1, right - 1)
  elsif sum.negative?
    [left + 1, right]
  else
    [left, right - 1]
  end
end

def skip_duplicates(nums, left, right)
  left += 1 while left < right && nums[left] == nums[left - 1]
  right -= 1 while left < right && nums[right] == nums[right + 1]
  [left, right]
end

if __FILE__ == $PROGRAM_NAME
  nums = [-1, 0, 1, 2, -1, -4]

  puts "Brute force: #{three_sum_brute(nums)}"
  puts "Optimized:   #{three_sum(nums)}"
end
