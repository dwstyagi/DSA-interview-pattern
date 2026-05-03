# frozen_string_literal: true

# LeetCode 986: Interval List Intersections
#
# Problem:
# You are given two lists of closed intervals, firstList and secondList,
# where firstList[i] = [start_i, end_i] and secondList[j] = [start_j, end_j].
# Each list of intervals is pairwise disjoint and in sorted order.
# Return the intersection of these two interval lists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For every pair (i, j) check if they intersect and collect intersections.
#
#    Time Complexity: O(m * n)
#    Space Complexity: O(m * n)
#
# 2. Bottleneck
#    Both lists are sorted; we can use two pointers to advance past non-intersecting pairs.
#
# 3. Optimized Accepted Approach
#    Two pointers i and j on firstList and secondList.
#    Intersection of [a,b] and [c,d] is [max(a,c), min(b,d)] if max(a,c) <= min(b,d).
#    Advance the pointer whose interval ends first.
#
#    Time Complexity: O(m + n)
#    Space Complexity: O(m + n) for result
#
# -----------------------------------------------------------------------------
# Dry Run
#
# A = [[0,2],[5,10],[13,23],[24,25]]
# B = [[1,5],[8,12],[15,24],[25,26]]
# i=0,j=0: [0,2]∩[1,5]=[1,2] → add, advance i (2<5)
# i=1,j=0: [5,10]∩[1,5]=[5,5] → add, advance j (5<=5)
# i=1,j=1: [5,10]∩[8,12]=[8,10] → add, advance i (10<12)
# ...
#
# Edge Cases:
# - One list empty -> []
# - No intersections -> []

def interval_intersection_brute(first_list, second_list)
  result = []
  first_list.each do |a|
    second_list.each do |b|
      lo = [a[0], b[0]].max
      hi = [a[1], b[1]].min
      result << [lo, hi] if lo <= hi
    end
  end
  result
end

def interval_intersection(first_list, second_list)
  result = []
  i = 0
  j = 0

  while i < first_list.length && j < second_list.length
    a = first_list[i]
    b = second_list[j]

    # Compute intersection of the two current intervals
    lo = [a[0], b[0]].max
    hi = [a[1], b[1]].min
    result << [lo, hi] if lo <= hi

    # Advance the pointer whose interval ends first
    if a[1] < b[1]
      i += 1
    else
      j += 1
    end
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  a = [[0, 2], [5, 10], [13, 23], [24, 25]]
  b = [[1, 5], [8, 12], [15, 24], [25, 26]]
  puts "Brute force: #{interval_intersection_brute(a, b).inspect}"
  puts "Optimized:   #{interval_intersection(a, b).inspect}"
  # Both: [[1,2],[5,5],[8,10],[15,23],[24,24],[25,25]]
end
