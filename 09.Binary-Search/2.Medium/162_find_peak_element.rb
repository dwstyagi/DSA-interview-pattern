# frozen_string_literal: true

#
# 1. Problem Statement
# --------------------
#
# LeetCode 162. Find Peak Element
#
# A peak element is an element that is strictly greater than its neighbors.
#
# Given an integer array nums, return the index of any peak element.
#
# You may imagine that:
# - nums[-1] = -∞
# - nums[n] = -∞
#
# The array may contain multiple peaks. Returning the index of any peak is valid.
#
# Example:
# Input: nums = [1,2,3,1]
# Output: 2
#
# Explanation:
# nums[2] = 3 is greater than both neighbors.
#

# ============================================================
# 2. Brute Force Approach
# ============================================================

#
# Intuition
# ---------
# The simplest way is to check every element and determine whether it is a
# peak.
#
# For each index:
# - Compare it with the left neighbor.
# - Compare it with the right neighbor.
# - If it is greater than both, return the index.
#
# Since the problem guarantees at least one peak exists, we will always
# find an answer.
#
# Algorithm
# ---------
# 1. Iterate through every index.
# 2. Treat out-of-bounds neighbors as -∞.
# 3. If current element is greater than both neighbors, return its index.
#
# Time Complexity:
# O(n)
#
# Space Complexity:
# O(1)
#

# ============================================================
# 3. Brute Force Code
# ============================================================

class BruteForceSolution
  def find_peak_element(nums)
    n = nums.length

    (0...n).each do |i|
      left = i.zero? ? -Float::INFINITY : nums[i - 1]
      right = i == n - 1 ? -Float::INFINITY : nums[i + 1]

      return i if nums[i] > left && nums[i] > right
    end

    -1
  end
end

# ============================================================
# 4. Bottleneck Analysis
# ============================================================

#
# The brute force solution examines elements one by one.
#
# Even if we can determine from a position that a peak must exist in a
# particular direction, we still continue checking elements sequentially.
#
# Example:
#
# nums = [1,2,3,4,5,6,7,8,9]
#
# To find the peak, we may inspect almost every element.
#
# The bottleneck is that we do not use the information provided by the
# relative ordering of neighboring elements to eliminate large portions
# of the search space.
#
# Can we discard half of the array at a time?
#
# If yes, we can improve from O(n) to O(log n).
#

# ============================================================
# 5. Optimization Journey
# ============================================================

#
# Key Observation
# ---------------
#
# Instead of checking whether nums[mid] is a peak, compare:
#
# nums[mid]
# nums[mid + 1]
#
# There are only two possibilities.
#
# --------------------------------------------------
#
# Case 1
#
# nums[mid] > nums[mid + 1]
#
# Example:
#
# 1 3 5 7 4 2
#       ^
#      mid
#
# We are on a descending slope.
#
# Since the sequence is going down, a peak must exist in the range:
#
# [left, mid]
#
# Why?
#
# - mid itself may be a peak.
# - If not, some larger element exists to the left.
# - Therefore, a peak is guaranteed to exist in the left half.
#
# So we can safely discard:
#
# [mid + 1, right]
#
# --------------------------------------------------
#
# Case 2
#
# nums[mid] < nums[mid + 1]
#
# Example:
#
# 1 2 4 6 8 5 3
#       ^
#      mid
#
# We are on an ascending slope.
#
# If we keep moving right:
#
# - Either the sequence keeps increasing and the last element becomes a
#   peak because its right neighbor is -∞.
# - Or the sequence eventually decreases, creating a peak at the turning
#   point.
#
# Therefore, a peak is guaranteed to exist in:
#
# [mid + 1, right]
#
# So we can safely discard:
#
# [left, mid]
#
# --------------------------------------------------
#
# Binary Search Insight
# ---------------------
#
# We are not searching for a specific value.
#
# We only need to keep the half that is guaranteed to contain at least one
# peak.
#
# This allows us to apply Binary Search even though the array is not
# sorted.
#
# Search Space Reduction
# ----------------------
#
# If nums[mid] > nums[mid + 1]
#     right = mid
#
# Else
#     left = mid + 1
#
# Eventually left == right.
#
# That position is guaranteed to be a peak.
#

# ============================================================
# 6. Dry Run
# ============================================================

#
# Example:
#
# nums = [1,2,3,1]
#
# Initial:
#
# left = 0
# right = 3
#
# --------------------------------------------------
#
# Iteration 1
#
# mid = 1
#
# nums[mid] = 2
# nums[mid + 1] = 3
#
# 2 < 3
#
# Peak must exist on the right side.
#
# left = mid + 1 = 2
#
# --------------------------------------------------
#
# Iteration 2
#
# left = 2
# right = 3
#
# mid = 2
#
# nums[mid] = 3
# nums[mid + 1] = 1
#
# 3 > 1
#
# Peak must exist in [left, mid].
#
# right = mid = 2
#
# --------------------------------------------------
#
# Now:
#
# left = 2
# right = 2
#
# Loop ends.
#
# Return 2.
#
# nums[2] = 3 is a peak.
#

# ============================================================
# 7. Optimal Solution
# ============================================================

#
# Algorithm
# ---------
#
# 1. Initialize:
#    left = 0
#    right = n - 1
#
# 2. While left < right:
#    - Compute mid.
#    - Compare nums[mid] and nums[mid + 1].
#
#    If nums[mid] > nums[mid + 1]:
#        A peak exists in [left, mid].
#        right = mid
#
#    Else:
#        A peak exists in [mid + 1, right].
#        left = mid + 1
#
# 3. When left == right,
#    return left.
#
# Time Complexity:
# O(log n)
#
# Space Complexity:
# O(1)
#

# ============================================================
# 8. Optimal Code
# ============================================================

class Solution
  # @param {Integer[]} nums
  # @return {Integer}
  def find_peak_element(nums)
    left = 0
    right = nums.length - 1

    while left < right
      mid = left + ((right - left) / 2)

      if nums[mid] > nums[mid + 1]
        # Peak exists in the left half (including mid)
        right = mid
      else
        # Peak exists in the right half
        left = mid + 1
      end
    end

    left
  end
end

# ============================================================
# Example Test Cases
# ============================================================

if __FILE__ == $PROGRAM_NAME
  solution = Solution.new

  nums1 = [1, 2, 3, 1]
  puts solution.find_peak_element(nums1)
  # Expected: 2

  nums2 = [1, 2, 1, 3, 5, 6, 4]
  puts solution.find_peak_element(nums2)
  # Expected: 1 or 5 (both are valid peaks)

  nums3 = [1]
  puts solution.find_peak_element(nums3)
  # Expected: 0
end
