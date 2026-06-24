# frozen_string_literal: true

# LeetCode 35: Search Insert Position
#
# Problem Statement
# -----------------------------------------------------------------------------
# Given a sorted array of distinct integers nums and a target value target,
# return the index if the target is found.
#
# If the target is not found, return the index where it would be inserted
# in order.
#
# Examples:
#
# nums = [1,3,5,6], target = 5
# Output: 2
#
# nums = [1,3,5,6], target = 2
# Output: 1
#
# nums = [1,3,5,6], target = 7
# Output: 4
#
# nums = [1,3,5,6], target = 0
# Output: 0
#
# -----------------------------------------------------------------------------
# 1. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition
# ----------
# Since the array is already sorted, we can scan from left to right.
#
# The first position where:
#
#   nums[i] >= target
#
# is exactly where target belongs.
#
# - If nums[i] == target, we've found the target.
# - If nums[i] > target, target should be inserted before nums[i].
#
# If we finish scanning the entire array, target is larger than every element,
# so it should be inserted at the end.
#
#
# Algorithm
# ----------
# 1. Traverse the array from left to right.
# 2. For each index i:
#      - If nums[i] >= target, return i.
# 3. If no such element exists:
#      - Return nums.length.
#
#
# Time Complexity
# ----------------
# O(n)
#
# Space Complexity
# -----------------
# O(1)
#
# -----------------------------------------------------------------------------
# 2. Brute Force Code
# -----------------------------------------------------------------------------

def search_insert_brute_force(nums, target)
  nums.each_with_index do |num, index|
    return index if num >= target
  end

  nums.length
end

# -----------------------------------------------------------------------------
# 3. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution performs a linear scan.
#
# Worst Case:
#
# nums = [1,3,5,6]
# target = 7
#
# We must inspect every element before concluding that the insertion position
# is at the end.
#
# Complexity:
#
# O(n)
#
# The major inefficiency is that we are not utilizing the fact that:
#
# - The array is already sorted.
#
# A sorted array gives us much more information.
#
# For example:
#
# nums = [1,3,5,6]
#
# If we check the middle element:
#
# nums[1] = 3
#
# and target = 5,
#
# then we immediately know that everything left of index 1 can never contain
# the answer.
#
# The brute force solution ignores this property and continues checking one
# element at a time.
#
# -----------------------------------------------------------------------------
# 4. Optimization Journey
# -----------------------------------------------------------------------------
#
# Key Observation #1
# ------------------
# The array is sorted.
#
# Whenever an array is sorted and we're searching for a position or value,
# Binary Search should immediately come to mind.
#
#
# Key Observation #2
# ------------------
# We don't only need to find the target.
#
# We also need to determine:
#
# "Where would the target be inserted?"
#
# Let's think about what happens during binary search.
#
#
# Example:
#
# nums   = [1,3,5,6]
# target = 2
#
#
# left = 0
# right = 3
#
# mid = 1
# nums[mid] = 3
#
# Since:
#
# 3 > 2
#
# the answer must be somewhere on the left side.
#
# right = mid - 1
#
#
# Now:
#
# left = 0
# right = 0
#
# mid = 0
# nums[mid] = 1
#
# Since:
#
# 1 < 2
#
# the answer must be on the right side.
#
# left = mid + 1
#
#
# Now:
#
# left = 1
# right = 0
#
# The loop stops.
#
#
# Key Observation #3
# ------------------
# When binary search ends:
#
# left = 1
# right = 0
#
# Notice:
#
# - All indices < left contain values < target.
# - All indices > right contain values > target.
#
# Therefore:
#
# left is exactly the insertion position.
#
#
# This means:
#
# - If target exists, return its index immediately.
# - Otherwise, return left after the loop ends.
#
#
# Why Binary Search Works
# -----------------------
#
# Every comparison eliminates half of the remaining search space.
#
# n
# n/2
# n/4
# n/8
# ...
#
# This gives:
#
# O(log n)
#
# time complexity.
#
# -----------------------------------------------------------------------------
# 5. Dry Run
# -----------------------------------------------------------------------------
#
# Example:
#
# nums   = [1,3,5,6]
# target = 2
#
#
# Initial State
#
# left  = 0
# right = 3
#
#
# Iteration 1
#
# mid = (0 + 3) / 2
# mid = 1
#
# nums[1] = 3
#
# 3 > 2
#
# right = mid - 1
# right = 0
#
#
# Current State
#
# left  = 0
# right = 0
#
#
# Iteration 2
#
# mid = (0 + 0) / 2
# mid = 0
#
# nums[0] = 1
#
# 1 < 2
#
# left = mid + 1
# left = 1
#
#
# Current State
#
# left  = 1
# right = 0
#
#
# Loop Condition
#
# left <= right
#
# 1 <= 0
#
# false
#
#
# Return left
#
# return 1
#
#
# Correct insertion position:
#
# [1, 2, 3, 5, 6]
#     ^
#
# -----------------------------------------------------------------------------
# 6. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm
# ----------
#
# 1. Initialize:
#
#      left = 0
#      right = nums.length - 1
#
# 2. While left <= right:
#
#      mid = left + (right - left) / 2
#
#      If nums[mid] == target:
#          return mid
#
#      If nums[mid] < target:
#          search right half
#
#      Else:
#          search left half
#
# 3. When the loop ends:
#
#      return left
#
# because left represents the first position where target can be inserted.
#
#
# Time Complexity
# ----------------
# O(log n)
#
# Space Complexity
# -----------------
# O(1)
#
# -----------------------------------------------------------------------------
# 7. Optimal Code
# -----------------------------------------------------------------------------

def search_insert(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    mid = left + ((right - left) / 2)

    if nums[mid] == target
      return mid
    elsif nums[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  # insertion position
  left
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 5)}"   # 2
  puts "Opt:   #{search_insert([1, 3, 5, 6], 5)}"         # 2
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 2)}"   # 1
  puts "Opt:   #{search_insert([1, 3, 5, 6], 2)}"         # 1
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 7)}"   # 4
  puts "Opt:   #{search_insert([1, 3, 5, 6], 7)}"         # 4
end
