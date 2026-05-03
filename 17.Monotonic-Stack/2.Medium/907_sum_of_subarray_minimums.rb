# frozen_string_literal: true

# LeetCode 907: Sum of Subarray Minimums
#
# Problem:
# Given array arr, return sum of min(b) over all contiguous subarrays b.
# Answer modulo 10^9+7.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Enumerate all subarrays, find minimum of each, sum.
#    Time Complexity: O(n^2) or O(n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    For each element, find how many subarrays it's the minimum of.
#    Use previous-less-element and next-less-element arrays via monotonic stack.
#
# 3. Optimized Accepted Approach
#    For arr[i], find left[i] = distance to previous element < arr[i] (exclusive),
#    right[i] = distance to next element <= arr[i] (exclusive).
#    Contribution = arr[i] * left[i] * right[i].
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr = [3,1,2,4]
# PLE (previous less): left = [1,2,1,1] (distances)
# NLE (next less equal): right = [1,3,2,1]
# contributions: 3*1*1=3, 1*2*3=6, 2*1*2=4, 4*1*1=4 -> sum=17
#
# Edge Cases:
# - All same: each subarray min = same value
# - Strictly increasing: each element is min of only subarrays ending at it

MOD = 1_000_000_007

def sum_subarray_mins_brute(arr)
  n = arr.length
  total = 0
  n.times do |i|
    min_val = arr[i]
    (i...n).each do |j|
      min_val = [min_val, arr[j]].min
      total = (total + min_val) % MOD
    end
  end
  total
end

def sum_subarray_mins(arr)
  n = arr.length
  left = Array.new(n)   # distance to previous smaller
  right = Array.new(n)  # distance to next smaller or equal
  stack = []

  # compute left distances
  n.times do |i|
    stack.pop while !stack.empty? && arr[stack.last] >= arr[i]
    left[i] = stack.empty? ? i + 1 : i - stack.last
    stack << i
  end

  stack.clear

  # compute right distances
  (n - 1).downto(0) do |i|
    stack.pop while !stack.empty? && arr[stack.last] > arr[i]
    right[i] = stack.empty? ? n - i : stack.last - i
    stack << i
  end

  total = 0
  n.times { |i| total = (total + arr[i] * left[i] * right[i]) % MOD }
  total
end

if __FILE__ == $PROGRAM_NAME
  puts sum_subarray_mins_brute([3, 1, 2, 4])  # 17
  puts sum_subarray_mins([11, 81, 94, 43, 3]) # 444
end
