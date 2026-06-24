# frozen_string_literal: true

# 1. Problem Statement
#
# LeetCode 540 - Single Element in a Sorted Array
#
# You are given a sorted array where:
# - Every element appears exactly twice.
# - Except for one element which appears only once.
#
# Return the single element that appears only once.
#
# Constraints:
# - Time complexity must be O(log n).
# - Space complexity must be O(1).
#
# Example:
# nums = [1,1,2,3,3,4,4,8,8]
#
# Output:
# 2
#

# ============================================================
# 2. Brute Force Approach
# ============================================================

#
# Intuition
# ---------
# Since every number appears twice except one, we can count the
# frequency of every element and return the one whose frequency is 1.
#
# How It Works
# ------------
# 1. Traverse the array.
# 2. Store frequencies in a hash map.
# 3. Traverse the hash map.
# 4. Return the element whose count equals 1.
#
# Time Complexity
# ---------------
# O(n)
#
# Space Complexity
# ----------------
# O(n)
#

# ============================================================
# 3. Brute Force Code
# ============================================================

#
# def single_non_duplicate(nums)
#   frequency = Hash.new(0)
#
#   nums.each do |num|
#     frequency[num] += 1
#   end
#
#   frequency.each do |num, count|
#     return num if count == 1
#   end
# end
#

# ============================================================
# 4. Bottleneck Analysis
# ============================================================

#
# Why is the brute force solution inefficient?
#
# Although O(n) is acceptable for many problems, this problem
# explicitly asks for O(log n) time.
#
# The brute force solution:
# 1. Visits every element.
# 2. Stores extra information in a hash.
# 3. Does not utilize the fact that the array is already sorted.
#
# The main bottleneck is:
# - Full array traversal.
# - Additional O(n) memory.
#
# We need a solution that takes advantage of the sorted order.
#

# ============================================================
# 5. Optimization Journey
# ============================================================

#
# Observation 1
# -------------
# The array is sorted.
#
# Example:
#
# Index: 0 1 2 3 4 5 6 7 8
# Value: 1 1 2 3 3 4 4 8 8
#
# Single element = 2
#
# Let's look at pair positions.
#
# Before the single element:
#
# (0,1) => 1,1
# (2,3) => 2,?
#
# Normally pairs start at EVEN indices.
#
# Consider a perfect paired array:
#
# [1,1,2,2,3,3,4,4]
#
# Pairs begin at:
# 0, 2, 4, 6 ...
#
# All even indices.
#
# Observation 2
# -------------
# After the single element appears, the pairing pattern shifts.
#
# Example:
#
# [1,1,2,3,3,4,4,5,5]
#
# Index:
# 0 1 2 3 4 5 6 7 8
#
# Pairs become:
#
# (3,4) => 3,3
# (5,6) => 4,4
# (7,8) => 5,5
#
# Now pairs start at ODD indices.
#
# Important Insight
# -----------------
# Before the single element:
# - Pair starts at even index.
#
# After the single element:
# - Pair starts at odd index.
#
# This creates a monotonic property.
#
# Whenever we see a valid pair beginning at an even index,
# the single element must lie to the right.
#
# Whenever the pairing rule breaks,
# the single element must be at or before that position.
#
# This monotonic behavior suggests Binary Search.
#
# Binary Search Setup
# -------------------
#
# We choose mid.
#
# To safely compare pairs, we force mid to be even.
#
# Why?
#
# Suppose:
#
# mid = 5
#
# Index 5 could be the SECOND element of a pair.
#
# Comparing:
# nums[5] with nums[6]
#
# doesn't reliably tell us anything.
#
# Instead:
#
# if mid is odd
#   mid -= 1
#
# Now mid always points to the first element
# of a potential pair.
#
# Then:
#
# nums[mid] == nums[mid + 1]
#
# means the pair is intact.
#
# Case 1
# -------
# nums[mid] == nums[mid + 1]
#
# Pair is valid.
#
# Single element must be after this pair.
#
# left = mid + 2
#
# Case 2
# -------
# nums[mid] != nums[mid + 1]
#
# Pairing breaks here.
#
# Single element is at mid or to its left.
#
# right = mid
#
# Eventually left == right.
#
# That index contains the answer.
#

# ============================================================
# 6. Dry Run
# ============================================================

#
# nums = [1,1,2,3,3,4,4,8,8]
#
# left = 0
# right = 8
#
# --------------------------------
# Iteration 1
#
# mid = (0 + 8) / 2 = 4
#
# mid is already even
#
# nums[4] = 3
# nums[5] = 4
#
# Not equal
#
# right = 4
#
# --------------------------------
# Iteration 2
#
# left = 0
# right = 4
#
# mid = (0 + 4) / 2 = 2
#
# mid is even
#
# nums[2] = 2
# nums[3] = 3
#
# Not equal
#
# right = 2
#
# --------------------------------
# Iteration 3
#
# left = 0
# right = 2
#
# mid = (0 + 2) / 2 = 1
#
# Odd index
#
# mid -= 1
#
# mid = 0
#
# nums[0] = 1
# nums[1] = 1
#
# Equal
#
# left = 2
#
# --------------------------------
#
# left = 2
# right = 2
#
# Stop.
#
# Answer = nums[2] = 2
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
#
#    a. Compute mid.
#
#    b. If mid is odd:
#       mid -= 1
#
#    c. Compare:
#       nums[mid] and nums[mid + 1]
#
#       If equal:
#         left = mid + 2
#
#       Else:
#         right = mid
#
# 3. Return nums[left]
#
# Why It Works
# ------------
#
# Before the single element:
# - Pairs begin at even indices.
#
# After the single element:
# - Pair alignment shifts.
#
# Binary search identifies the first position
# where this alignment breaks.
#
# Time Complexity
# ---------------
# O(log n)
#
# Space Complexity
# ----------------
# O(1)
#

# ============================================================
# 8. Optimal Code
# ============================================================

def single_non_duplicate(nums)
  left = 0
  right = nums.length - 1

  while left < right
    mid = (left + right) / 2

    # Always point to the first index of a potential pair.
    mid -= 1 if mid.odd?

    if nums[mid] == nums[mid + 1]
      # Pair is valid, answer lies to the right.
      left = mid + 2
    else
      # Pairing breaks here, answer lies on left side.
      right = mid
    end
  end

  nums[left]
end

#
# Example 1
# ----------
#
# Input:
# nums = [1,1,2,3,3,4,4,8,8]
#
# Output:
# 2
#
# Explanation:
# Every element appears twice except 2.
#
# Example 2
# ----------
#
# Input:
# nums = [3,3,7,7,10,11,11]
#
# Output:
# 10
#
# Explanation:
# Every element appears twice except 10.
#
# Example 3
# ----------
#
# Input:
# nums = [1]
#
# Output:
# 1
#
# Explanation:
# The only element in the array is the answer.
#
# Constraints
# -----------
# 1 <= nums.length <= 100000
# 0 <= nums[i] <= 100000
#
# nums.length is odd.
# Every element appears exactly twice except one.
# nums is sorted in non-decreasing order.
#
