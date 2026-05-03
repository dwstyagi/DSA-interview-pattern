# frozen_string_literal: true

# LeetCode 42: Trapping Rain Water
#
# Problem:
# Given n non-negative integers representing an elevation map where the width of each bar is 1,
# compute how much water it can trap after raining.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each position, find max height to its left and right. Water at i = min(maxL, maxR) - h[i].
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Recomputing max left/right for each position wastes time.
#
# 3. Optimized Accepted Approach
#    Two-pointer: left and right pointers from both ends.
#    The side with the smaller current max determines how much water is trapped.
#    Move the pointer on the smaller-max side inward.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# height = [0,1,0,2,1,0,1,3,2,1,2,1]
# left=0(0), right=11(1), max_left=0, max_right=1
# max_right(1) > max_left(0) → water at left=0: max(0,0)-0=0, left++
# left=1(1), max_left=1 → water=0, left++
# ...
# Total water = 6
#
# Edge Cases:
# - All same height  -> 0
# - Monotonically increasing/decreasing -> 0
# - Only 2 bars      -> 0

def trap_brute(height)
  n = height.length
  water = 0

  (1...n - 1).each do |i|
    max_left  = height[0...i].max || 0
    max_right = height[(i + 1)..].max || 0
    bound = [max_left, max_right].min
    water += [bound - height[i], 0].max
  end

  water
end

def trap(height)
  return 0 if height.length < 3

  left  = 0
  right = height.length - 1
  max_left  = 0
  max_right = 0
  water = 0

  while left < right
    if height[left] <= height[right]
      # Left side is the bottleneck
      if height[left] >= max_left
        max_left = height[left] # new max on left, no water here
      else
        water += max_left - height[left] # water trapped at left
      end
      left += 1
    else
      # Right side is the bottleneck
      if height[right] >= max_right
        max_right = height[right]
      else
        water += max_right - height[right]
      end
      right -= 1
    end
  end

  water
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{trap_brute([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1])}" # 6
  puts "Optimized:   #{trap([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1])}"       # 6
  puts "Brute force: #{trap_brute([4, 2, 0, 3, 2, 5])}"                    # 9
  puts "Optimized:   #{trap([4, 2, 0, 3, 2, 5])}"                          # 9
end
