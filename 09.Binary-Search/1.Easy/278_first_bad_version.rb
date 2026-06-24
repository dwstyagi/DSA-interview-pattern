# frozen_string_literal: true

# 1. Problem Statement
#
# LeetCode 278 - First Bad Version
#
# You are given n versions labeled from 1 to n.
#
# A version is considered bad if it fails quality checks. Once a version becomes
# bad, every version after it is also bad.
#
# An API is provided:
#
#     isBadVersion(version)
#
# which returns true if the given version is bad.
#
# Your task is to find the first bad version while minimizing the number of API calls.
#
# --------------------------------------------------
# 2. Brute Force Approach
# --------------------------------------------------
#
# Intuition
#
# The most straightforward idea is to check every version starting from 1.
#
# Since versions become permanently bad after the first bad version,
# the first version that returns true must be the answer.
#
# Algorithm
#
# 1. Iterate from version 1 to n.
# 2. For each version:
#    - Call isBadVersion(version).
# 3. Return the first version that is bad.
#
# Time Complexity
#
# O(n)
#
# In the worst case, the first bad version could be n.
#
# Space Complexity
#
# O(1)
#
# Only a few variables are used.
#
# --------------------------------------------------
# 3. Brute Force Code
# --------------------------------------------------
#
# def first_bad_version(n)
#   (1..n).each do |version|
#     return version if isBadVersion(version)
#   end
# end
#
# --------------------------------------------------
# 4. Bottleneck Analysis
# --------------------------------------------------
#
# Why is the brute force solution inefficient?
#
# Suppose:
#
# n = 2,126,753,390
#
# and the first bad version is near the end.
#
# The brute force solution may perform billions of API calls.
#
# The major issue is that we are ignoring an important property of the problem:
#
#     Good Good Good Good Bad Bad Bad Bad
#
# Once a version becomes bad, all versions after it are also bad.
#
# This creates a monotonic pattern:
#
#     false false false false true true true true
#
# Whenever a search space is sorted or monotonic, binary search should be considered.
#
# The repeated work comes from checking versions one-by-one even though a single
# API call can eliminate half of the remaining search space.
#
# --------------------------------------------------
# 5. Optimization Journey
# --------------------------------------------------
#
# Key Observation #1
#
# Versions are split into two regions:
#
#     [Good Versions][Bad Versions]
#
# We need the boundary between them.
#
# Example:
#
#     1 2 3 4 5 6 7
#     G G G B B B B
#
# Answer = 4
#
# This is equivalent to:
#
#     Find the first position where condition becomes true.
#
# where:
#
#     condition(version) = isBadVersion(version)
#
# --------------------------------------------------
#
# Key Observation #2
#
# Binary Search Can Find Boundaries
#
# Instead of searching for an exact value, we search for the first true.
#
# Consider:
#
#     F F F T T T T
#
# Let mid be the middle version.
#
# Case 1:
#
#     isBadVersion(mid) == true
#
# Then the answer could be:
#     - mid itself
#     - somewhere to the left
#
# So we keep:
#
#     right = mid
#
# Case 2:
#
#     isBadVersion(mid) == false
#
# Then mid cannot be the answer.
#
# Everything on the left is also good.
#
# So we keep:
#
#     left = mid + 1
#
# --------------------------------------------------
#
# Key Observation #3
#
# Why Use right = mid Instead of mid - 1?
#
# If mid is bad, mid might be the first bad version.
#
# Discarding it would risk losing the answer.
#
# Therefore:
#
#     right = mid
#
# not
#
#     right = mid - 1
#
# --------------------------------------------------
#
# Key Observation #4
#
# Termination
#
# We continue while:
#
#     left < right
#
# Eventually:
#
#     left == right
#
# At that point only one candidate remains.
#
# That candidate must be the first bad version.
#
# --------------------------------------------------
# 6. Dry Run
# --------------------------------------------------
#
# Example:
#
#     n = 5
#     first bad = 4
#
# Versions:
#
#     1 2 3 4 5
#     G G G B B
#
# Initial:
#
#     left = 1
#     right = 5
#
# --------------------------------
#
# Iteration 1
#
#     mid = 1 + (5 - 1) / 2
#         = 3
#
#     isBadVersion(3) => false
#
# Answer must be to the right.
#
#     left = 4
#     right = 5
#
# --------------------------------
#
# Iteration 2
#
#     mid = 4 + (5 - 4) / 2
#         = 4
#
#     isBadVersion(4) => true
#
# Answer may be 4 or earlier.
#
#     left = 4
#     right = 4
#
# --------------------------------
#
# Stop
#
#     left == right == 4
#
# Return:
#
#     4
#
# --------------------------------------------------
# 7. Optimal Solution
# --------------------------------------------------
#
# Algorithm
#
# 1. Set:
#        left = 1
#        right = n
#
# 2. While left < right:
#        mid = left + (right - left) / 2
#
# 3. If mid is bad:
#        right = mid
#
# 4. Otherwise:
#        left = mid + 1
#
# 5. When the loop ends:
#        return left
#
# Why It Works
#
# - A bad mid means the first bad version lies in [left, mid].
# - A good mid means the first bad version lies in [mid + 1, right].
# - Each step removes half the search space.
# - Eventually only one version remains.
#
# Time Complexity
#
# O(log n)
#
# The search space is halved every iteration.
#
# Space Complexity
#
# O(1)
#
# Only constant extra memory is used.
#
# --------------------------------------------------
# 8. Optimal Code
# --------------------------------------------------

# The isBadVersion API is already defined for you.
#
# @param {Integer} version
# @return {Boolean}
# def isBadVersion(version)
# end

# @param {Integer} n
# @return {Integer}
def first_bad_version(n)
  left = 1
  right = n

  while left < right
    # Overflow-safe midpoint calculation
    mid = left + ((right - left) / 2)

    if isBadVersion(mid)
      # Mid could be the first bad version
      right = mid
    else
      # First bad version must be after mid
      left = mid + 1
    end
  end

  left
end
