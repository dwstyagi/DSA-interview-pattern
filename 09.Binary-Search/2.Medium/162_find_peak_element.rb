# frozen_string_literal: true

# LeetCode 162: Find Peak Element
#
# Problem:
# A peak element is an element strictly greater than its neighbors.
# Given nums, return the index of any peak element. nums[-1] and nums[n]
# are considered -infinity.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan: find index where nums[i] > both neighbors.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n) linear.
#
# 3. Optimized Accepted Approach
#    Binary search: if nums[mid] < nums[mid+1], peak is in right half (l=mid+1).
#    Else peak is at mid or left (r=mid). Converges to a peak.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,2,3,1]
# l=0,r=3: mid=1, nums[1]=2 < nums[2]=3 → l=2
# l=2,r=3: mid=2, nums[2]=3 > nums[3]=1 → r=2
# l=r=2 → peak at index 2 (value 3) ✓
#
# Edge Cases:
# - Monotone increasing → last element is peak
# - Monotone decreasing → first element is peak
# - Any valid peak accepted

def find_peak_element_brute(nums)
  n = nums.length
  nums.each_with_index do |v, i|
    left_ok  = i == 0 || nums[i - 1] < v
    right_ok = i == n - 1 || nums[i + 1] < v
    return i if left_ok && right_ok
  end
  -1
end

def find_peak_element(nums)
  l = 0
  r = nums.length - 1

  while l < r
    mid = (l + r) / 2
    if nums[mid] < nums[mid + 1]
      l = mid + 1   # ascending slope → peak is to the right
    else
      r = mid       # descending slope or plateau → peak at mid or left
    end
  end

  l
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_peak_element_brute([1, 2, 3, 1])}"   # 2
  puts "Opt:   #{find_peak_element([1, 2, 3, 1])}"         # 2
  puts "Brute: #{find_peak_element_brute([1, 2, 1, 3, 5, 6, 4])}"  # 5 or 1
  puts "Opt:   #{find_peak_element([1, 2, 1, 3, 5, 6, 4])}"        # 5 or 1
end
