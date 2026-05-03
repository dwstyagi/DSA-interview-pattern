# frozen_string_literal: true

# LeetCode 4: Median of Two Sorted Arrays
#
# Problem:
# Given two sorted arrays nums1 and nums2, return the median of the two sorted
# arrays. The overall run time complexity must be O(log(m+n)).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Merge both arrays, sort, find middle element(s).
#    Time Complexity: O((m+n) log(m+n))
#    Space Complexity: O(m+n)
#
# 2. Bottleneck
#    Merging is O(m+n) — we don't need the full merged array, just the median
#    position. Binary search on the partition of the smaller array.
#
# 3. Optimized Accepted Approach
#    Binary search a partition i in nums1 (ensure nums1 is shorter).
#    Partition j in nums2 = (m+n+1)/2 - i.
#    Valid partition: max_left1 <= min_right2 AND max_left2 <= min_right1.
#    Adjust i left/right based on cross comparisons.
#    Time Complexity: O(log(min(m,n)))
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums1=[1,3], nums2=[2]
# total=3, half=2, binary search i in [0,2]
# i=1, j=1: max_l1=1, min_r1=3, max_l2=2, min_r2=INF
# max_l1<=min_r2(1<=INF) ✓, max_l2<=min_r1(2<=3) ✓ → valid
# odd total → median = max(max_l1, max_l2) = max(1,2) = 2.0 ✓
#
# Edge Cases:
# - One empty array -> median of the other
# - All elements of one < all elements of other
# - Even total length -> average of two middle elements

def find_median_sorted_arrays_brute(nums1, nums2)
  merged = (nums1 + nums2).sort
  n = merged.length
  n.odd? ? merged[n / 2].to_f : (merged[n / 2 - 1] + merged[n / 2]) / 2.0
end

def find_median_sorted_arrays(nums1, nums2)
  # Ensure nums1 is the shorter array for O(log min(m,n))
  nums1, nums2 = nums2, nums1 if nums1.length > nums2.length

  m, n   = nums1.length, nums2.length
  half   = (m + n + 1) / 2
  lo, hi = 0, m

  while lo <= hi
    i = (lo + hi) / 2   # partition in nums1
    j = half - i         # corresponding partition in nums2

    max_l1 = i.zero? ? -Float::INFINITY : nums1[i - 1]
    min_r1 = i == m     ? Float::INFINITY : nums1[i]
    max_l2 = j.zero? ? -Float::INFINITY : nums2[j - 1]
    min_r2 = j == n     ? Float::INFINITY : nums2[j]

    if max_l1 <= min_r2 && max_l2 <= min_r1
      # valid partition found
      left_max = [max_l1, max_l2].max
      return (m + n).odd? ? left_max.to_f : (left_max + [min_r1, min_r2].min) / 2.0
    elsif max_l1 > min_r2
      hi = i - 1 # too far right in nums1
    else
      lo = i + 1 # too far left in nums1
    end
  end

  0.0 # unreachable for valid input
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_median_sorted_arrays_brute([1, 3], [2])}"           # 2.0
  puts "Opt:   #{find_median_sorted_arrays([1, 3], [2])}"                 # 2.0
  puts "Brute: #{find_median_sorted_arrays_brute([1, 2], [3, 4])}"        # 2.5
  puts "Opt:   #{find_median_sorted_arrays([1, 2], [3, 4])}"              # 2.5
  puts "Brute: #{find_median_sorted_arrays_brute([], [1])}"               # 1.0
  puts "Opt:   #{find_median_sorted_arrays([], [1])}"                     # 1.0
end
