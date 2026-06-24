# frozen_string_literal: true

#
# 1. Problem Statement
#
# LeetCode 436 - Find Right Interval
#
# You are given an array of intervals where intervals[i] = [start_i, end_i].
#
# For each interval i, find another interval j such that:
#
#   start_j >= end_i
#
# Among all such valid intervals, choose the one with the smallest start_j.
#
# Return an array answer where:
#
#   answer[i] = index of the chosen interval
#
# If no such interval exists, return -1 for that position.
#
# Example:
#
# Input:
# intervals = [[3,4],[2,3],[1,2]]
#
# Output:
# [-1,0,1]
#
# Explanation:
#
# For [3,4]:
#   No interval starts at or after 4.
#   => -1
#
# For [2,3]:
#   Interval [3,4] starts at 3.
#   => index 0
#
# For [1,2]:
#   Interval [2,3] starts at 2.
#   => index 1
#

#
# 2. Brute Force Approach
#
# Intuition
#
# For every interval, check every other interval and find all intervals
# whose start value is greater than or equal to the current interval's end.
#
# Among those valid candidates, choose the interval having the smallest
# start value.
#
# Algorithm
#
# For each interval i:
#
# 1. Let target = end_i.
# 2. Iterate through all intervals j.
# 3. If start_j >= target:
#      - It is a valid candidate.
# 4. Track the candidate having the smallest start value.
# 5. Store its index.
# 6. If no candidate exists, store -1.
#
# Time Complexity
#
# For each interval we scan all intervals.
#
# O(n²)
#
# Space Complexity
#
# O(1)
# (excluding output array)
#

#
# 3. Brute Force Code
#
def find_right_interval_brute_force(intervals)
  n = intervals.length
  result = Array.new(n, -1)

  (0...n).each do |i|
    target = intervals[i][1]

    best_start = Float::INFINITY
    best_index = -1

    (0...n).each do |j|
      start = intervals[j][0]

      if start >= target && start < best_start
        best_start = start
        best_index = j
      end
    end

    result[i] = best_index
  end

  result
end

#
# 4. Bottleneck Analysis
#
# Why is the brute force solution inefficient?
#
# For every interval:
#
#   We repeatedly scan every interval again.
#
# Example:
#
# intervals = [[1,2],[2,3],[3,4],[4,5]]
#
# For interval [1,2]:
#   Scan all intervals.
#
# For interval [2,3]:
#   Scan all intervals again.
#
# For interval [3,4]:
#   Scan all intervals again.
#
# Much of the work is repeated.
#
# The real question being asked is:
#
#   "Find the smallest start value that is >= target."
#
# This resembles a searching problem rather than a repeated scanning problem.
#
# The bottleneck is:
#
#   Repeated linear searches.
#
# For each interval:
#   O(n)
#
# For n intervals:
#   O(n²)
#
# We need a faster way to search among start values.
#

#
# 5. Optimization Journey
#
# Observation 1
#
# We only care about interval starts.
#
# For each interval:
#
#   target = current end
#
# We need:
#
#   smallest start >= target
#
# Suppose starts are:
#
# [1, 2, 3, 5, 8]
#
# For target = 4
#
# Answer is:
#
# 5
#
# This is a searching problem.
#
# --------------------------------------------------
#
# Observation 2
#
# Binary Search works on sorted data.
#
# Let's store:
#
# [start_value, original_index]
#
# Example:
#
# intervals = [[3,4],[2,3],[1,2]]
#
# Store:
#
# [
#   [3,0],
#   [2,1],
#   [1,2]
# ]
#
# Sort by start:
#
# [
#   [1,2],
#   [2,1],
#   [3,0]
# ]
#
# Now all start values are sorted.
#
# --------------------------------------------------
#
# Observation 3
#
# What exactly are we searching for?
#
# Given:
#
# target = end_i
#
# Need:
#
# first start >= target
#
# Example:
#
# starts:
#
# 1 2 3 5 8
#
# target = 4
#
# Valid starts:
#
# 5 8
#
# We want:
#
# 5
#
# Not just any valid value.
#
# We want the FIRST valid value.
#
# --------------------------------------------------
#
# Observation 4
#
# Finding the first valid value is a classic
# Lower Bound Binary Search.
#
# Pattern:
#
# if value >= target
#   save candidate
#   search left
# else
#   search right
# end
#
# Why search left after finding a valid answer?
#
# Because there may be a smaller valid start.
#
# Example:
#
# starts:
#
# [1, 5, 6, 8]
#
# target = 5
#
# Binary search may first land on 6.
#
# 6 is valid.
#
# But 5 is even better.
#
# Therefore:
#
# 1. Save 6 as current answer.
# 2. Continue searching left.
# 3. Eventually discover 5.
#
# This guarantees we find the smallest valid start.
#
# --------------------------------------------------
#
# Data Structure Choice
#
# Sorted Array
#
# Why?
#
# Because we need:
#
#   Smallest start >= target
#
# A sorted array allows:
#
#   Binary Search
#
# Time:
#
#   O(log n)
#
# instead of
#
#   O(n)
#
# This removes the brute force bottleneck.
#

#
# 6. Dry Run
#
# intervals = [[3,4],[2,3],[1,2]]
#
# Step 1
#
# Build starts array.
#
# [
#   [3,0],
#   [2,1],
#   [1,2]
# ]
#
# Sort:
#
# [
#   [1,2],
#   [2,1],
#   [3,0]
# ]
#
# --------------------------------------------------
#
# Process interval [3,4]
#
# target = 4
#
# left = 0
# right = 2
# answer = -1
#
# mid = 1
#
# start = 2
#
# 2 >= 4 ?
#
# No
#
# left = 2
#
# mid = 2
#
# start = 3
#
# 3 >= 4 ?
#
# No
#
# left = 3
#
# Loop ends
#
# answer = -1
#
# result:
#
# [-1]
#
# --------------------------------------------------
#
# Process interval [2,3]
#
# target = 3
#
# left = 0
# right = 2
# answer = -1
#
# mid = 1
#
# start = 2
#
# 2 >= 3 ?
#
# No
#
# left = 2
#
# mid = 2
#
# start = 3
#
# 3 >= 3 ?
#
# Yes
#
# answer = 0
#
# Search left:
#
# right = 1
#
# Loop ends
#
# result:
#
# [-1, 0]
#
# --------------------------------------------------
#
# Process interval [1,2]
#
# target = 2
#
# left = 0
# right = 2
# answer = -1
#
# mid = 1
#
# start = 2
#
# 2 >= 2 ?
#
# Yes
#
# answer = 1
#
# Search left:
#
# right = 0
#
# mid = 0
#
# start = 1
#
# 1 >= 2 ?
#
# No
#
# left = 1
#
# Loop ends
#
# result:
#
# [-1, 0, 1]
#

#
# 7. Optimal Solution
#
# Algorithm
#
# 1. Store every interval's start value along with its original index.
#
#    [start, index]
#
# 2. Sort by start value.
#
# 3. For each interval:
#
#    target = interval end
#
# 4. Use binary search to find:
#
#    first start >= target
#
# 5. Save the corresponding original index.
#
# 6. If no such interval exists, store -1.
#
# Why it works
#
# The sorted array guarantees that:
#
#   All smaller starts appear before larger starts.
#
# Binary search finds the leftmost start
# that satisfies:
#
#   start >= target
#
# This is exactly the interval required by the problem.
#
# Time Complexity
#
# Sorting:
# O(n log n)
#
# Binary search for every interval:
# n * O(log n)
#
# Total:
# O(n log n)
#
# Space Complexity
#
# O(n)
#
# For storing the sorted starts array.
#

# 8. Optimal Code

def find_right_interval(intervals)
  n = intervals.length

  # Store [start, original_index]
  starts = []

  intervals.each_with_index do |interval, index|
    starts << [interval[0], index]
  end

  starts.sort_by!(&:first)

  result = Array.new(n, -1)

  intervals.each_with_index do |interval, i|
    target = interval[1]

    left = 0
    right = n - 1

    answer = -1

    # Lower bound binary search
    while left <= right
      mid = left + ((right - left) / 2)

      if starts[mid][0] >= target
        answer = starts[mid][1]
        right = mid - 1
      else
        left = mid + 1
      end
    end

    result[i] = answer
  end

  result
end

#
# Example Test Cases
#
# p find_right_interval([[1, 2]])
# [-1]
#
# p find_right_interval([[3,4],[2,3],[1,2]])
# [-1,0,1]
#
# p find_right_interval([[1,4],[2,3],[3,4]])
# [-1,2,-1]
#
