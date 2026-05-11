# frozen_string_literal: true

# LeetCode 220: Contains Duplicate III
#
# Problem:
# Given an integer array nums and two integers indexDiff and valueDiff,
# return true if there exist two distinct indices i and j such that:
# - abs(i - j) <= indexDiff
# - abs(nums[i] - nums[j]) <= valueDiff
#
# Examples:
#   Input:  nums = [1,2,3,1], indexDiff = 3, valueDiff = 0
#   Output: true
#   Why:    nums[0]=1 and nums[3]=1: abs(0-3)=3<=3 and abs(1-1)=0<=0 -> true.
#
#   Input:  nums = [1,5,9,1,5,9], indexDiff = 2, valueDiff = 3
#   Output: false
#   Why:    No two indices within distance 2 have values within 3 of each other.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair of indices (left, right) with left < right.
#    If both the index distance and value difference conditions are satisfied,
#    return true. If no valid pair exists, return false.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n^2) pairs in the worst case
#    - O(1) work per pair
#
# 2. Bottleneck
#    For each position right, brute force scans too many earlier indices.
#    We only care about values from the last indexDiff positions, because older
#    values can never satisfy the index-distance condition.
#
#    So the real question becomes:
#    - is there any value in the recent window within
#      [nums[right] - valueDiff, nums[right] + valueDiff]?
#
#    Scanning that window linearly for every index is still too slow.
#
# 3. Optimized Accepted Approach
#    Use a sliding window + buckets.
#    Let bucket width be valueDiff + 1.
#
#    Then for each current value:
#    - remove the value that just expired from the indexDiff window
#    - compute the current bucket id
#    - if the same bucket already exists, return true
#    - check the left and right neighboring buckets for a valid value difference
#    - otherwise insert the current value into its bucket
#
#    Why this works:
#    - two values within valueDiff must fall in the same bucket or in adjacent
#      buckets when bucket width is valueDiff + 1
#    - each bucket stores at most one value, because a second value in the same
#      bucket would already satisfy the condition
#
#    Time Complexity: O(n)
#    Space Complexity: O(indexDiff)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3, 1]
# indexDiff = 3
# valueDiff = 0
#
# width = valueDiff + 1 = 1
# buckets = {}
#
# right = 0, num = 1
# bucket = 1
# bucket 1 is empty, neighbors do not help
# insert 1 -> buckets = { 1 => 1 }
#
# right = 1, num = 2
# bucket = 2
# bucket 2 is empty
# neighbor bucket 1 has value 1, but |2 - 1| = 1 > 0
# insert 2 -> buckets = { 1 => 1, 2 => 2 }
#
# right = 2, num = 3
# bucket = 3
# bucket 3 is empty
# neighbor bucket 2 has value 2, but |3 - 2| = 1 > 0
# insert 3 -> buckets = { 1 => 1, 2 => 2, 3 => 3 }
#
# right = 3, num = 1
# bucket = 1
# bucket 1 already exists
# Final answer = true
#
# Edge Cases:
# - indexDiff = 0 -> always false because distinct indices cannot have distance 0
# - valueDiff < 0 -> always false
# - valueDiff = 0 -> values must be exactly equal
# - negative numbers are safe because Ruby's div uses floor division

def contains_nearby_almost_duplicate_true_brute_force?(nums, index_diff, value_diff)
  n = nums.length

  (0...n).each do |left|
    ((left + 1)...n).each do |right|
      return true if right - left <= index_diff &&
                     (nums[right] - nums[left]).abs <= value_diff
    end
  end

  false
end

def contains_nearby_almost_duplicate?(nums, index_diff, value_diff)
  return false if index_diff.zero? || value_diff.negative?

  width = value_diff + 1
  buckets = {}

  nums.each_with_index do |num, right|
    if right > index_diff
      expired = nums[right - index_diff - 1]
      buckets.delete(expired.div(width))
    end

    bucket = num.div(width)

    return true if [bucket, bucket - 1, bucket + 1].any? { |key|
      buckets.key?(key) && (num - buckets[key]).abs <= value_diff
    }

    buckets[bucket] = num
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 2, 3, 1]
  index_diff = 3
  value_diff = 0

  puts "True brute force: #{contains_nearby_almost_duplicate_true_brute_force?(nums, index_diff, value_diff)}"
  puts "Optimized:        #{contains_nearby_almost_duplicate?(nums, index_diff, value_diff)}"
end
