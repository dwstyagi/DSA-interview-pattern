# frozen_string_literal: true

#
# 1. Problem Statement
# --------------------
#
# LeetCode 4 - Median of Two Sorted Arrays
#
# Given two sorted arrays nums1 and nums2 of sizes m and n respectively,
# return the median of the two sorted arrays.
#
# The overall run time complexity should be O(log(m + n)).
#
# Examples:
#
# Input:
# nums1 = [1, 3]
# nums2 = [2]
#
# Output:
# 2.0
#
#
# Input:
# nums1 = [1, 2]
# nums2 = [3, 4]
#
# Output:
# 2.5
#

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------

#
# Intuition
# ---------
#
# The most straightforward idea is:
#
# 1. Merge both arrays into a single sorted array.
# 2. Find the median of the merged array.
#
# Since both arrays are already sorted, we can perform a standard merge
# (similar to Merge Sort).
#
# How the Algorithm Works
# -----------------------
#
# Example:
#
# nums1 = [1, 3]
# nums2 = [2]
#
# Merged:
#
# [1, 2, 3]
#
# Length = 3
#
# Median = middle element = 2
#
# For even length:
#
# [1, 2, 3, 4]
#
# Median = (2 + 3) / 2
#
# Time Complexity
# ---------------
#
# Merging requires visiting every element.
#
# Time  : O(m + n)
# Space : O(m + n)
#

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

class BruteForceSolution
  def find_median_sorted_arrays(nums1, nums2)
    merged = []

    i = 0
    j = 0

    while i < nums1.length && j < nums2.length
      if nums1[i] <= nums2[j]
        merged << nums1[i]
        i += 1
      else
        merged << nums2[j]
        j += 1
      end
    end

    while i < nums1.length
      merged << nums1[i]
      i += 1
    end

    while j < nums2.length
      merged << nums2[j]
      j += 1
    end

    n = merged.length

    if n.odd?
      merged[n / 2].to_f
    else
      (merged[(n / 2) - 1] + merged[n / 2]) / 2.0
    end
  end
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------

#
# Why is this inefficient?
# ------------------------
#
# To find the median, we don't actually need the entire merged array.
#
# Yet the brute force solution:
#
# 1. Processes every element.
# 2. Stores every element.
# 3. Builds a complete merged array.
#
# For very large inputs:
#
# nums1.length = 1,000,000
# nums2.length = 1,000,000
#
# We still merge all 2 million elements even though the median depends
# only on the middle position.
#
# Repeated Work
# -------------
#
# Most of the merge operation contributes nothing toward the final answer.
#
# We are paying O(m + n) work just to locate one position.
#
# The problem specifically asks for O(log(m + n)),
# so we must avoid processing all elements.
#
# We need a way to directly identify the median position.
#

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------

#
# Observation 1
# -------------
#
# The median splits the combined array into two halves.
#
# Example:
#
# [1, 2, 3, 4, 5]
#
# Left Half:
# [1, 2, 3]
#
# Right Half:
# [4, 5]
#
# Median = max(left half)
#
# For even length:
#
# [1, 2, 3, 4]
#
# Left Half:
# [1, 2]
#
# Right Half:
# [3, 4]
#
# Median = (max(left) + min(right)) / 2
#
# --------------------------------------------------
#
# Observation 2
# -------------
#
# Instead of merging arrays, can we partition them?
#
# Suppose:
#
# nums1 = [1, 3]
# nums2 = [2]
#
# Partition:
#
# nums1:
# [ ] | [1, 3]
#
# nums2:
# [2] | [ ]
#
# Left Side:
# [2]
#
# Right Side:
# [1, 3]
#
# Invalid because:
#
# max(left) = 2
# min(right) = 1
#
# 2 > 1
#
# --------------------------------------------------
#
# Observation 3
# -------------
#
# A valid partition must satisfy:
#
# maxLeft1 <= minRight2
#
# AND
#
# maxLeft2 <= minRight1
#
# If these conditions hold, then every element on the left side is
# less than or equal to every element on the right side.
#
# That means we have found the median split.
#
# --------------------------------------------------
#
# Observation 4
# -------------
#
# If we choose a partition in nums1, the partition in nums2 is forced.
#
# Let:
#
# partition1 = elements taken from nums1
#
# Then:
#
# partition2 =
# (total_left_elements) - partition1
#
# where:
#
# total_left_elements = (m + n + 1) / 2
#
# --------------------------------------------------
#
# Observation 5
# -------------
#
# What happens if:
#
# maxLeft1 > minRight2
#
# We took too many elements from nums1.
#
# Move left.
#
# What happens if:
#
# maxLeft2 > minRight1
#
# We took too few elements from nums1.
#
# Move right.
#
# This is exactly binary search.
#
# --------------------------------------------------
#
# Observation 6
# -------------
#
# Always binary search the smaller array.
#
# Why?
#
# Because partition1 ranges only from:
#
# 0..m
#
# Therefore binary search complexity becomes:
#
# O(log(min(m, n)))
#
# which satisfies the requirement.
#

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------

#
# Example:
#
# nums1 = [1, 2]
# nums2 = [3, 4]
#
# Lengths:
#
# m = 2
# n = 2
#
# Total length = 4
#
# Required left size:
#
# (m + n + 1) / 2
#
# = (2 + 2 + 1) / 2
#
# = 2
#
# --------------------------------------------------
#
# Iteration 1
#
# left  = 0
# right = 2
#
# partition1 = 1
# partition2 = 1
#
# Partitions:
#
# nums1:
# [1] | [2]
#
# nums2:
# [3] | [4]
#
# Values:
#
# maxLeft1  = 1
# minRight1 = 2
#
# maxLeft2  = 3
# minRight2 = 4
#
# Check:
#
# maxLeft2 <= minRight1
#
# 3 <= 2
#
# False
#
# Need more elements from nums1.
#
# Move right.
#
# left = partition1 + 1
#
# left = 2
#
# --------------------------------------------------
#
# Iteration 2
#
# partition1 = 2
# partition2 = 0
#
# Partitions:
#
# nums1:
# [1, 2] | []
#
# nums2:
# [] | [3, 4]
#
# Values:
#
# maxLeft1  = 2
# minRight1 = +∞
#
# maxLeft2  = -∞
# minRight2 = 3
#
# Check:
#
# 2 <= 3  ✓
# -∞ <= +∞ ✓
#
# Valid partition found.
#
# --------------------------------------------------
#
# Even Length Median
#
# maxLeft =
# max(2, -∞)
# = 2
#
# minRight =
# min(+∞, 3)
# = 3
#
# Median =
# (2 + 3) / 2
#
# = 2.5
#
# Answer = 2.5
#

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------

#
# Algorithm
# ---------
#
# 1. Ensure nums1 is the smaller array.
# 2. Binary search on nums1.
# 3. Compute matching partition in nums2.
# 4. Calculate:
#
#    maxLeft1
#    minRight1
#    maxLeft2
#    minRight2
#
# 5. If partition is valid:
#
#       maxLeft1 <= minRight2
#       maxLeft2 <= minRight1
#
#    Then:
#
#       Odd Length:
#       median = max(maxLeft1, maxLeft2)
#
#       Even Length:
#       median =
#       (max(maxLeft1, maxLeft2) +
#        min(minRight1, minRight2)) / 2
#
# 6. Otherwise move binary search accordingly.
#
# Time Complexity
# ---------------
#
# O(log(min(m, n)))
#
# Space Complexity
# ----------------
#
# O(1)
#

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

class Solution
  def find_median_sorted_arrays(nums1, nums2)
    # Binary search on smaller array
    nums1, nums2 = nums2, nums1 if nums1.length > nums2.length

    m = nums1.length
    n = nums2.length

    left = 0
    right = m

    while left <= right
      partition1 = (left + right) / 2
      partition2 = ((m + n + 1) / 2) - partition1

      max_left1 =
        partition1.zero? ? -Float::INFINITY : nums1[partition1 - 1]

      min_right1 =
        partition1 == m ? Float::INFINITY : nums1[partition1]

      max_left2 =
        partition2.zero? ? -Float::INFINITY : nums2[partition2 - 1]

      min_right2 =
        partition2 == n ? Float::INFINITY : nums2[partition2]

      # Valid partition found
      if max_left1 <= min_right2 && max_left2 <= min_right1
        return [max_left1, max_left2].max.to_f if (m + n).odd?

        left_max = [max_left1, max_left2].max
        right_min = [min_right1, min_right2].min

        return (left_max + right_min) / 2.0
      end

      # Too many elements from nums1
      if max_left1 > min_right2
        right = partition1 - 1
      else
        # Too few elements from nums1
        left = partition1 + 1
      end
    end
  end
end

# -----------------------------------------------------------------------------
# Example Usage
# -----------------------------------------------------------------------------

solution = Solution.new

puts 'Example 1'
nums1 = [1, 3]
nums2 = [2]
puts "nums1 = #{nums1}"
puts "nums2 = #{nums2}"
puts "Median = #{solution.find_median_sorted_arrays(nums1, nums2)}"
puts

puts 'Example 2'
nums1 = [1, 2]
nums2 = [3, 4]
puts "nums1 = #{nums1}"
puts "nums2 = #{nums2}"
puts "Median = #{solution.find_median_sorted_arrays(nums1, nums2)}"
puts

puts 'Example 3'
nums1 = [0, 0]
nums2 = [0, 0]
puts "nums1 = #{nums1}"
puts "nums2 = #{nums2}"
puts "Median = #{solution.find_median_sorted_arrays(nums1, nums2)}"
puts

puts 'Example 4'
nums1 = []
nums2 = [1]
puts "nums1 = #{nums1}"
puts "nums2 = #{nums2}"
puts "Median = #{solution.find_median_sorted_arrays(nums1, nums2)}"
puts

puts 'Example 5'
nums1 = [2]
nums2 = []
puts "nums1 = #{nums1}"
puts "nums2 = #{nums2}"
puts "Median = #{solution.find_median_sorted_arrays(nums1, nums2)}"
