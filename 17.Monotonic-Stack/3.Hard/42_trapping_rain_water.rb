# frozen_string_literal: true

# LeetCode 42: Trapping Rain Water
#
# Problem:
# Given elevation heights, compute how much water can be trapped after rain.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each position, find max height to its left and right. Water trapped =
#    min(max_left, max_right) - height[i].
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Recomputing max left/right for each position. Precompute or use two-pointer.
#
# 3. Optimized Accepted Approach
#    Two pointers: left and right. Track left_max and right_max.
#    Move the pointer with smaller max inward. Water = max - height.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# height = [0,1,0,2,1,0,1,3,2,1,2,1]
# lo=0,hi=11, left_max=0, right_max=1
# height[lo]=0 <= height[hi]=1: water+=left_max-height[lo]=0; lo=1
# height[lo]=1: left_max=1; lo=2
# height[lo]=0: water+=1-0=1; lo=3
# ... continues, total=6
#
# Edge Cases:
# - No bars or single bar: 0
# - Monotonically increasing/decreasing: 0

def trap_brute(height)
  n = height.length
  total = 0
  (1...n - 1).each do |i|
    left_max = height[0..i].max
    right_max = height[i..].max
    total += [left_max, right_max].min - height[i]
  end
  total
end

def trap(height)
  lo = 0
  hi = height.length - 1
  left_max = 0
  right_max = 0
  water = 0
  while lo < hi
    if height[lo] <= height[hi]
      if height[lo] >= left_max
        left_max = height[lo]
      else
        water += left_max - height[lo]
      end
      lo += 1
    else
      if height[hi] >= right_max
        right_max = height[hi]
      else
        water += right_max - height[hi]
      end
      hi -= 1
    end
  end
  water
end

if __FILE__ == $PROGRAM_NAME
  puts trap_brute([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1])  # 6
  puts trap([4, 2, 0, 3, 2, 5])                            # 9
end
