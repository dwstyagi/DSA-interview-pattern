# frozen_string_literal: true

# LeetCode 327: Count of Range Sum
#
# Problem:
# Given an integer array nums and two integers lower and upper, return the
# number of range sums that lie in [lower, upper] inclusive.
# Range sum S(i, j) = sum of nums[i..j].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compute all prefix sums, check all pairs (i, j) if prefix[j]-prefix[i]
#    is in [lower, upper].
#    Time Complexity: O(n²)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    O(n²) pairs of prefix sums to check.
#
# 3. Optimized Accepted Approach
#    Merge sort on prefix sums. During merge of left and right halves,
#    for each prefix[j] in right, count how many prefix[i] in left satisfy
#    lower <= prefix[j] - prefix[i] <= upper (use two pointers in sorted left).
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-2, 5, -1], lower = -2, upper = 2
# prefix = [0, -2, 3, 2]
# Valid ranges: [-2,-2]S(0,0)=-2✓, [-2,3]S(0,1)=3✗, [-2,2]S(0,2)=2✓,
#              [3,2]S(1,2)=-1✓, (others)
# Count = 3
#
# Edge Cases:
# - Single element → check if it's in [lower, upper]
# - All zeros and lower=0, upper=0 → n*(n+1)/2 subarrays

def count_range_sum_brute(nums, lower, upper)
  n = nums.length
  prefix = Array.new(n + 1, 0)
  (0...n).each { |i| prefix[i + 1] = prefix[i] + nums[i] }

  count = 0
  (0..n).each do |i|
    (i + 1..n).each do |j|
      s = prefix[j] - prefix[i]
      count += 1 if lower <= s && s <= upper
    end
  end
  count
end

def count_range_sum(nums, lower, upper)
  prefix = [0]
  nums.each { |n| prefix << prefix[-1] + n }
  merge_count(prefix, 0, prefix.length - 1, lower, upper)
end

def merge_count(arr, left, right, lower, upper)
  return 0 if left >= right

  mid = (left + right) / 2
  count = merge_count(arr, left, mid, lower, upper) +
          merge_count(arr, mid + 1, right, lower, upper)

  # for each right[j], find left[i] where lower <= right[j] - left[i] <= upper
  lo_ptr = left
  hi_ptr = left
  (mid + 1..right).each do |j|
    lo_ptr += 1 while lo_ptr <= mid && arr[j] - arr[lo_ptr] > upper
    hi_ptr += 1 while hi_ptr <= mid && arr[j] - arr[hi_ptr] >= lower
    count += hi_ptr - lo_ptr
  end

  # merge sort the two halves
  sorted = arr[left..right].sort   # sort the current range
  arr[left..right] = sorted

  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{count_range_sum_brute([-2, 5, -1], -2, 2)}"  # 3
  puts "Opt:   #{count_range_sum([-2, 5, -1], -2, 2)}"        # 3
  puts "Brute: #{count_range_sum_brute([0], 0, 0)}"            # 1
  puts "Opt:   #{count_range_sum([0], 0, 0)}"                  # 1
end
