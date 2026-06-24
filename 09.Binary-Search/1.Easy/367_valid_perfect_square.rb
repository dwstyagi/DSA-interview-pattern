# frozen_string_literal: true

# LeetCode 367: Valid Perfect Square
#
# -----------------------------------------------------------------------------
# 1. Problem Statement
# -----------------------------------------------------------------------------
#
# Given a positive integer num, return true if num is a perfect square,
# otherwise return false.
#
# A perfect square is an integer that can be expressed as:
#
#   x * x = num
#
# You must solve the problem without using built-in square root functions.
#
# -----------------------------------------------------------------------------
# 2. Brute Force Approach
# -----------------------------------------------------------------------------
#
# Intuition
# ---------
# A number is a perfect square if there exists some integer x such that:
#
#   x² = num
#
# The most straightforward approach is to try every possible value from 1
# to num and check whether its square equals num.
#
# Algorithm
# ---------
# 1. Iterate through every integer i from 1 to num.
# 2. Compute i * i.
# 3. If i * i == num, return true.
# 4. If the loop finishes, return false.
#
# Time Complexity
# ---------------
# O(n)
#
# Space Complexity
# ----------------
# O(1)
#
# -----------------------------------------------------------------------------
# 3. Brute Force Code
# -----------------------------------------------------------------------------

def perfect_square?(num)
  (1..num).each do |i|
    return true if i * i == num
  end

  false
end

# -----------------------------------------------------------------------------
# 4. Bottleneck Analysis
# -----------------------------------------------------------------------------
#
# The brute force solution checks every possible number one by one.
#
# Example:
#
#   num = 2_147_395_600
#
# We may need to test tens of thousands of numbers before finding the answer.
#
# The main inefficiency is:
#
#   - We examine values sequentially.
#   - Each comparison eliminates only one candidate.
#
# However, notice something important:
#
#   1², 2², 3², 4², 5², ...
#
# forms a strictly increasing sequence.
#
# Because the sequence is sorted, we should not scan linearly.
# We should search intelligently.
#
# This observation naturally suggests Binary Search.
#
# -----------------------------------------------------------------------------
# 5. Optimization Journey
# -----------------------------------------------------------------------------
#
# Observation 1
# -------------
#
# If:
#
#   mid * mid == num
#
# then we found the square root and can return true.
#
# Observation 2
# -------------
#
# If:
#
#   mid * mid < num
#
# then every number smaller than mid is also too small because:
#
#   1² < 2² < 3² < ...
#
# Therefore we can discard the entire left half.
#
# Observation 3
# -------------
#
# If:
#
#   mid * mid > num
#
# then every number larger than mid is also too large.
#
# Therefore we can discard the entire right half.
#
# This means one comparison eliminates half of the remaining search space.
#
# Search Space
# ------------
#
# The square root of num must lie between:
#
#   1 and num
#
# So we perform binary search on this range.
#
# Why Binary Search Solves the Bottleneck
# ---------------------------------------
#
# Brute Force:
#
#   Removes 1 candidate per iteration.
#
# Binary Search:
#
#   Removes half the candidates per iteration.
#
# Search space reduction:
#
#   n
#   n/2
#   n/4
#   n/8
#   ...
#
# Number of iterations:
#
#   O(log n)
#
# This is exponentially faster than O(n).
#
# -----------------------------------------------------------------------------
# 6. Dry Run
# -----------------------------------------------------------------------------
#
# Example:
#
#   num = 16
#
# Initial State:
#
#   left  = 1
#   right = 16
#
# ------------------------------------------------
# Iteration 1
#
# mid = (1 + 16) / 2 = 8
#
# square = 8 * 8 = 64
#
# 64 > 16
#
# Discard right half:
#
#   right = 7
#
# ------------------------------------------------
# Iteration 2
#
# left  = 1
# right = 7
#
# mid = (1 + 7) / 2 = 4
#
# square = 4 * 4 = 16
#
# square == num
#
# Return true
#
# ------------------------------------------------
#
# Example:
#
#   num = 14
#
# left = 1
# right = 14
#
# mid = 7
# square = 49
#
# right = 6
#
# mid = 3
# square = 9
#
# left = 4
#
# mid = 5
# square = 25
#
# right = 4
#
# mid = 4
# square = 16
#
# right = 3
#
# left > right
#
# Return false
#
# -----------------------------------------------------------------------------
# 7. Optimal Solution
# -----------------------------------------------------------------------------
#
# Algorithm
# ---------
#
# 1. Initialize:
#
#      left = 1
#      right = num
#
# 2. While left <= right:
#
#      mid = left + (right - left) / 2
#      square = mid * mid
#
# 3. If square == num:
#
#      return true
#
# 4. If square < num:
#
#      search right half
#
# 5. If square > num:
#
#      search left half
#
# 6. If the loop ends:
#
#      return false
#
# Time Complexity
# ---------------
# O(log n)
#
# Space Complexity
# ----------------
# O(1)
#
# -----------------------------------------------------------------------------
# 8. Optimal Code
# -----------------------------------------------------------------------------

class Solution
  def perfect_square?(num)
    left = 1
    right = num

    while left <= right
      mid = left + ((right - left) / 2)
      square = mid * mid

      return true if square == num

      if square < num
        left = mid + 1
      else
        right = mid - 1
      end
    end

    false
  end
end

# -----------------------------------------------------------------------------
# Example Usage / Testing
# -----------------------------------------------------------------------------

solution = Solution.new

puts solution.is_perfect_square(16)
# Expected: true

puts solution.is_perfect_square(14)
# Expected: false

puts solution.is_perfect_square(1)
# Expected: true

puts solution.is_perfect_square(25)
# Expected: true

puts solution.is_perfect_square(26)
# Expected: false
