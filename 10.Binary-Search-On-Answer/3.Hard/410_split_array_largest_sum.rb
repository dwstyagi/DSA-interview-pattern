# frozen_string_literal: true

#
# LeetCode 410. Split Array Largest Sum
#
# 1. Problem Statement
# --------------------
# Given an integer array `nums` and an integer `k`, split the array into exactly
# `k` non-empty continuous subarrays.
#
# Return the minimum possible value of the largest subarray sum.
#
# Example:
# Input: nums = [7,2,5,10,8], k = 2
# Output: 18
#
# Explanation:
# Possible splits are:
#
# [7] | [2,5,10,8]      Largest Sum = 25
# [7,2] | [5,10,8]      Largest Sum = 23
# [7,2,5] | [10,8]      Largest Sum = 18  ← Minimum
# [7,2,5,10] | [8]      Largest Sum = 24
#
# Answer = 18
#
#
# 2. Brute Force Approach
# -----------------------
#
# Intuition
# ---------
# There are multiple ways to split an array into exactly k continuous parts.
#
# For every possible split:
#
# 1. Compute the sum of every subarray.
# 2. Find the largest subarray sum.
# 3. Keep the minimum among all possibilities.
#
# This guarantees the correct answer because every valid partition is explored.
#
# Algorithm
# ---------
# Use recursion.
#
# At every position:
#
# • Choose where the current subarray ends.
# • Recursively split the remaining array into (k-1) parts.
# • The answer for this split is:
#
#     max(current_subarray_sum, largest_sum_from_remaining_parts)
#
# Among all possible ending positions, choose the minimum.
#
# Time Complexity
# ---------------
# Exponential
#
# Approximately O(2^n)
#
# Space Complexity
# ----------------
# O(k) recursion stack.
#
#
# 3. Brute Force Code
# -------------------

def dfs(nums, index, k)
  return nums[index..].sum if k == 1

  current_sum = 0
  answer = Float::INFINITY

  (index...(nums.length - k + 1)).each do |i|
    current_sum += nums[i]

    largest =
      [
        current_sum,
        dfs(nums, i + 1, k - 1)
      ].max

    answer = [answer, largest].min
  end

  answer
end

def split_array_brute(nums, k)
  dfs(nums, 0, k)
end

puts 'Brute Force Examples'
puts split_array_brute([7, 2, 5, 10, 8], 2)
puts split_array_brute([1, 4, 4], 3)

#
# 4. Bottleneck Analysis
# ----------------------
#
# The brute-force solution explores every possible partition.
#
# For an array of length n:
#
# Each position can either become a split or not become a split.
#
# This creates an exponential number of partition combinations.
#
# Additionally,
#
# many recursive calls solve exactly the same subproblem repeatedly.
#
# Example:
#
# dfs(index = 4, k = 2)
#
# may be computed from multiple recursion paths.
#
# As n grows, the running time becomes far too large.
#
#
# 5. Optimization Journey
# -----------------------
#
# Observation 1
# -------------
#
# We are NOT trying to minimize the total sum.
#
# The total sum of the array never changes.
#
# Example:
#
# [7] | [2,5,10,8]
# 7 + 25 = 32
#
# [7,2,5] | [10,8]
# 14 + 18 = 32
#
# The total sum is always 32.
#
# Instead, we are minimizing the LARGEST subarray sum.
#
#
# Observation 2
# -------------
#
# Instead of asking
#
# "Where should I split?"
#
# ask
#
# "If the largest allowed subarray sum is X,
# can I split the array into at most k subarrays?"
#
#
# This is much easier to answer.
#
#
# Observation 3
# -------------
#
# Suppose
#
# nums = [7,2,5,10,8]
#
# Maximum allowed = 18
#
# Traverse the array greedily.
#
# Current Sum
#
# 7
# 9
# 14
#
# Next number = 10
#
# 14 + 10 = 24 > 18
#
# We must split.
#
# Current partitions
#
# [7,2,5]
# [10,8]
#
# Used = 2
#
# This is valid.
#
#
# Suppose
#
# Maximum allowed = 15
#
# Current
#
# 7
# 9
# 14
#
# Next number = 10
#
# Split
#
# Current
#
# 10
#
# Next
#
# 10 + 8 = 18
#
# Split again
#
# Now we need
#
# [7,2,5]
# [10]
# [8]
#
# 3 partitions.
#
# Impossible.
#
#
# Observation 4 (Monotonic Property)
# ----------------------------------
#
# Maximum Allowed Sum
#
# 10 ❌
# 11 ❌
# 12 ❌
# 13 ❌
# 14 ❌
# 15 ❌
# 16 ❌
# 17 ❌
# 18 ✅
# 19 ✅
# 20 ✅
# 21 ✅
# 22 ✅
#
# Notice the pattern.
#
# Once a value becomes feasible,
# every larger value is also feasible.
#
# This monotonic property is exactly what Binary Search requires.
#
#
# Observation 5
# -------------
#
# The answer must lie between
#
# Left  = max(nums)
#
# because one subarray must contain the largest element.
#
# Right = sum(nums)
#
# because putting everything into one subarray creates the largest possible sum.
#
# Therefore
#
# Search Space
#
# max(nums) ---------------------- sum(nums)
#
# Binary Search can now be applied over the answer itself.
#
#
# Why Greedy Works
# ----------------
#
# For a chosen maximum allowed sum,
#
# we always keep adding elements to the current subarray.
#
# Only when adding the next element exceeds the limit do we start a new subarray.
#
# Splitting earlier would only increase the number of subarrays.
#
# Therefore,
#
# the greedy algorithm always uses the minimum possible number of subarrays for
# that limit.
#
# This makes it the correct feasibility check.
#
#
# 6. Dry Run
# -----------
#
# nums = [7,2,5,10,8]
#
# k = 2
#
# left = 10
#
# right = 32
#
#
# Iteration 1
#
# mid = 21
#
# Check
#
# 7 + 2 + 5 = 14
#
# 14 + 10 = 24 > 21
#
# Split
#
# Subarrays
#
# [7,2,5]
# [10,8]
#
# Need = 2
#
# Possible
#
# right = 21
#
#
# Iteration 2
#
# left = 10
#
# right = 21
#
# mid = 15
#
# Check
#
# 7+2+5 =14
#
# 14+10 >15
#
# Split
#
# 10+8 >15
#
# Split
#
# Need = 3
#
# Impossible
#
# left = 16
#
#
# Iteration 3
#
# mid = 18
#
# Check
#
# 7+2+5 =14
#
# 14+10 >18
#
# Split
#
# 10+8 =18
#
# Need = 2
#
# Possible
#
# right = 18
#
#
# Continue...
#
# Eventually
#
# left = right = 18
#
# Answer = 18
#
#
# 7. Optimal Solution
# -------------------
#
# Algorithm
#
# 1. Search between
#
#    max(nums)
#
#    and
#
#    sum(nums)
#
# 2. Pick the middle value.
#
# 3. Greedily count how many subarrays are needed if every subarray sum must be
#    less than or equal to mid.
#
# 4. If more than k subarrays are needed,
#    mid is too small.
#
# 5. Otherwise,
#    try to minimize the answer further.
#
# Time Complexity
# ---------------
#
# Checking feasibility
#
# O(n)
#
# Binary Search
#
# O(log(sum(nums)))
#
# Overall
#
# O(n log(sum(nums)))
#
# Space Complexity
# ----------------
#
# O(1)
#
#
# 8. Optimal Code
# ---------------

def can_split?(nums, k, max_sum)
  subarrays = 1
  current_sum = 0

  nums.each do |num|
    if current_sum + num > max_sum
      subarrays += 1

      # Already exceeded the allowed number of subarrays.
      return false if subarrays > k

      current_sum = num
    else
      current_sum += num
    end
  end

  true
end

def split_array(nums, k)
  left = nums.max
  right = nums.sum

  while left < right
    mid = left + ((right - left) / 2)

    if can_split?(nums, k, mid)
      # Mid works, try a smaller maximum sum.
      right = mid
    else
      # Mid is too small.
      left = mid + 1
    end
  end

  left
end

puts
puts 'Optimal Solution Examples'

puts split_array([7, 2, 5, 10, 8], 2)
# Expected: 18

puts split_array([1, 2, 3, 4, 5], 2)
# Expected: 9

puts split_array([1, 4, 4], 3)
# Expected: 4

puts split_array([2, 3, 1, 2, 4, 3], 5)
# Expected: 4
