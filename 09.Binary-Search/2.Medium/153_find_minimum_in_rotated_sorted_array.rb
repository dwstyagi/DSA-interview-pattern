# frozen_string_literal: true

# LeetCode 153: Find Minimum in Rotated Sorted Array
#
# Problem:
# Suppose an array of length n sorted in ascending order is rotated between
# 1 and n times. Find the minimum element.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan for minimum.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n) ignores structure.
#
# 3. Optimized Accepted Approach
#    Binary search: compare nums[mid] with nums[r].
#    If nums[mid] > nums[r], the minimum is in right half (l = mid+1).
#    Else the minimum is in left half including mid (r = mid).
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[3,4,5,1,2]
# l=0,r=4: mid=2, nums[2]=5 > nums[4]=2 → l=3
# l=3,r=4: mid=3, nums[3]=1 <= nums[4]=2 → r=3
# l=r=3 → nums[3]=1 ✓
#
# Edge Cases:
# - Not rotated → return nums[0]
# - Single element → return it

def find_min_brute(nums)
  nums.min
end

def find_min(nums)
  l = 0
  r = nums.length - 1

  while l < r
    mid = (l + r) / 2
    if nums[mid] > nums[r]
      l = mid + 1   # min is in the right unsorted portion
    else
      r = mid       # mid could be the min; include it
    end
  end

  nums[l]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_min_brute([3, 4, 5, 1, 2])}"   # 1
  puts "Opt:   #{find_min([3, 4, 5, 1, 2])}"         # 1
  puts "Brute: #{find_min_brute([4, 5, 6, 7, 0, 1, 2])}"  # 0
  puts "Opt:   #{find_min([4, 5, 6, 7, 0, 1, 2])}"        # 0
  puts "Brute: #{find_min_brute([11, 13, 15, 17])}"  # 11
  puts "Opt:   #{find_min([11, 13, 15, 17])}"        # 11
end
