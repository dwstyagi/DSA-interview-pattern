# frozen_string_literal: true

#
# 1. Problem Statement
# --------------------
#
# LeetCode 69 - Sqrt(x)
#
# Given a non-negative integer x, return the square root of x rounded down to
# the nearest integer.
#
# You are not allowed to use built-in exponent functions such as:
#   - Math.sqrt
#   - x ** 0.5
#
# Examples:
#
# Input: x = 4
# Output: 2
#
# Input: x = 8
# Output: 2
#
# Explanation:
# The square root of 8 is approximately 2.828..., and since we only return the
# integer part, the answer is 2.
#

# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------

#
# Intuition
# ---------
#
# The most direct approach is to start from 0 and keep increasing the number
# until its square becomes greater than x.
#
# The last number whose square is less than or equal to x is the answer.
#
# Algorithm
# ---------
#
# 1. Start with num = 0.
# 2. While num * num <= x:
#       increment num.
# 3. Once the condition fails:
#       return num - 1.
#
# Example (x = 8)
#
# num = 0 -> 0² = 0
# num = 1 -> 1² = 1
# num = 2 -> 2² = 4
# num = 3 -> 3² = 9 > 8
#
# Answer = 3 - 1 = 2
#
# Time Complexity
# ---------------
#
# O(√x)
#
# We may check every integer from 0 up to √x.
#
# Space Complexity
# ----------------
#
# O(1)
#

# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

#
# def my_sqrt(x)
#   num = 0
#
#   while num * num <= x
#     num += 1
#   end
#
#   num - 1
# end
#

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------

#
# Why is the brute force solution inefficient?
#
# Consider:
#
# x = 2_147_483_647
#
# The answer is approximately 46,340.
#
# The brute force approach performs roughly 46,000 iterations.
#
# While this may still pass for this constraint, the pattern does not scale well.
#
# The real issue:
#
# We are checking many values one by one even though most of them can be
# eliminated at once.
#
# For example:
#
# If mid² is greater than x, then every value larger than mid is also invalid.
#
# Similarly:
#
# If mid² is less than x, then every value smaller than mid is already known
# to be valid.
#
# The brute force approach ignores this ordering information and performs
# unnecessary checks.
#
# We need a way to eliminate large portions of the search space at once.
#

# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------

#
# Key Observation #1
# ------------------
#
# The search space is sorted.
#
# For any integer k:
#
# k² <= x   -> k is a valid candidate
# k² > x    -> k is invalid
#
# As k increases, k² also increases.
#
# This creates a monotonic pattern:
#
# Valid Valid Valid Valid Invalid Invalid Invalid ...
#
# Whenever we see a monotonic property, binary search should be considered.
#
# --------------------------------------------------
#
# Key Observation #2
# ------------------
#
# Instead of checking numbers sequentially:
#
# 1, 2, 3, 4, 5, ...
#
# we can repeatedly check the middle value.
#
# Suppose:
#
# x = 8
#
# Search range:
#
# [1, 8]
#
# mid = 4
#
# 4² = 16 > 8
#
# Therefore:
#
# 4, 5, 6, 7, 8
#
# can never be the answer.
#
# We immediately discard half of the search space.
#
# --------------------------------------------------
#
# Key Observation #3
# ------------------
#
# When mid² <= x:
#
# mid is a valid answer candidate.
#
# However, there might be a larger valid answer.
#
# So:
#
# answer = mid
# search right half
#
# When mid² > x:
#
# mid is too large.
#
# Search left half.
#
# --------------------------------------------------
#
# Binary Search Strategy
# ----------------------
#
# Maintain:
#
# left  = smallest possible answer
# right = largest possible answer
#
# At each step:
#
# mid = (left + right) / 2
#
# Case 1:
# mid² == x
#
# Exact square root found.
# Return mid.
#
# Case 2:
# mid² < x
#
# mid is valid.
# Store it as a candidate and move right.
#
# Case 3:
# mid² > x
#
# mid is too large.
# Move left.
#
# When the search ends:
#
# right points to the largest integer whose square is <= x.
#
# That is exactly floor(√x).
#
# --------------------------------------------------
#
# Why Binary Search Solves the Bottleneck
# ---------------------------------------
#
# Brute Force:
# Eliminates only one number per iteration.
#
# Binary Search:
# Eliminates half of the remaining search space per iteration.
#
# Iterations:
#
# O(√x)  ->  O(log x)
#
# A dramatic improvement.
#

# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------

#
# Example:
#
# x = 8
#
# Initial:
#
# left  = 1
# right = 8
#
# --------------------------------------------------
#
# Iteration 1
#
# mid = (1 + 8) / 2
# mid = 4
#
# square = 16
#
# 16 > 8
#
# Discard right half.
#
# right = 3
#
# --------------------------------------------------
#
# Iteration 2
#
# left  = 1
# right = 3
#
# mid = (1 + 3) / 2
# mid = 2
#
# square = 4
#
# 4 < 8
#
# 2 is a valid answer candidate.
#
# left = 3
#
# --------------------------------------------------
#
# Iteration 3
#
# left  = 3
# right = 3
#
# mid = 3
#
# square = 9
#
# 9 > 8
#
# right = 2
#
# --------------------------------------------------
#
# Loop Ends
#
# left = 3
# right = 2
#
# Condition left <= right fails.
#
# Return right.
#
# Answer = 2
#

# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------

#
# Algorithm
# ---------
#
# 1. Initialize:
#       left = 1
#       right = x
#
# 2. While left <= right:
#
#       mid = (left + right) / 2
#       square = mid * mid
#
#       If square == x:
#           return mid
#
#       If square < x:
#           left = mid + 1
#
#       Else:
#           right = mid - 1
#
# 3. Return right.
#
# Why return right?
#
# At termination:
#
# left  -> first value whose square is too large
# right -> largest value whose square is <= x
#
# Therefore:
#
# right = floor(√x)
#
# Time Complexity
# ---------------
#
# O(log x)
#
# Binary search halves the search space every iteration.
#
# Space Complexity
# ----------------
#
# O(1)
#
# Only a few variables are used.
#

# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

# @param {Integer} x
# @return {Integer}
def my_sqrt(x)
  left = 1
  right = x

  while left <= right
    mid = (left + right) / 2
    square = mid * mid

    return mid if square == x

    if square < x
      left = mid + 1
    else
      right = mid - 1
    end
  end

  # Largest value whose square is <= x
  right
end
