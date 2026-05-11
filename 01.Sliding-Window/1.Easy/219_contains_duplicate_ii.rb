# frozen_string_literal: true

# LeetCode 219: Contains Duplicate II
#
# Problem:
# Given an integer array nums and an integer k, return true if there are two
# distinct indices i and j in the array such that nums[i] == nums[j] and
# abs(i - j) <= k.
#
# Examples:
#   Input:  nums = [1,2,3,1], k = 3
#   Output: true
#   Why:    nums[0]=1 and nums[3]=1, abs(0-3)=3 <= k=3 -> true.
#
#   Input:  nums = [1,2,3,1,2,3], k = 2
#   Output: false
#   Why:    Duplicate 1s are at indices 0 and 3 (diff=3 > k=2). All pairs exceed k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair of indices (left, right) with left < right.
#    If the two values are equal and their distance is at most k, return true.
#    If no valid pair exists after checking all pairs, return false.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n^2) pairs in the worst case
#    - O(1) work per pair
#
# 2. Bottleneck
#    We compare too many pairs that are obviously irrelevant.
#    The condition only cares about duplicates within distance k.
#    So for index right, we only need to know whether the same value appeared
#    in the last k positions, not anywhere in the entire array.
#    Important:
#    - right - left is index distance
#    - right - left + 1 would be subarray length, which is not the condition
#
# 3. Optimized Accepted Approach
#    Use a sliding window Set that stores the last k elements.
#    For each index right:
#    - remove the element that is now more than k steps behind
#    - if nums[right] is already in the Set, return true
#    - otherwise add nums[right] to the Set
#
#    The Set always represents the valid window of indices that could pair
#    with the current element.
#
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3, 1]
# k = 3
#
# right = 0
# window = {}
# 1 not in window, add it
# window = {1}
#
# right = 1
# window = {1}
# 2 not in window, add it
# window = {1, 2}
#
# right = 2
# window = {1, 2}
# 3 not in window, add it
# window = {1, 2, 3}
#
# right = 3
# right is not greater than k, so nothing is removed
# 1 is already in window
# Final answer = true
#
# Edge Cases:
# - k = 0 -> always false because distinct indices cannot have distance 0
# - single element array -> false
# - duplicates may exist but still be too far apart

def contains_nearby_duplicate_true_brute_force?(nums, index_limit)
  n = nums.length

  (0...n).each do |left|
    ((left + 1)...n).each do |right|
      return true if nums[left] == nums[right] && right - left <= index_limit
    end
  end

  false
end

def contains_nearby_duplicate?(nums, index_limit)
  return false if index_limit.zero?

  window = Set.new

  nums.each_with_index do |num, right|
    window.delete(nums[right - index_limit - 1]) if right > index_limit
    return true if window.include?(num)

    window.add(num)
  end

  false
end

if __FILE__ == $PROGRAM_NAME
  nums = [1, 2, 3, 1]
  k = 3

  puts "True brute force: #{contains_nearby_duplicate_true_brute_force?(nums, k)}"
  puts "Optimized:        #{contains_nearby_duplicate?(nums, k)}"
end
