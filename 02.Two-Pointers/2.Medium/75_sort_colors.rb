# frozen_string_literal: true

# LeetCode 75: Sort Colors
#
# Problem:
# Given an integer array nums containing only 0, 1, and 2, sort the array
# in-place so that all 0s come first, then all 1s, then all 2s.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count how many 0s, 1s, and 2s exist.
#    Then overwrite the array with that many 0s, followed by 1s, followed by 2s.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
#    This is accepted, but it uses two passes.
#
# 2. Bottleneck
#    The counting approach scans once to count and again to rewrite.
#    Since there are only three values, we can partition the array in one pass.
#
# 3. Optimized Accepted Approach
#    Use the Dutch National Flag algorithm with three pointers:
#    - low: next position where 0 should go
#    - mid: current index being inspected
#    - high: next position where 2 should go
#
#    Regions:
#    - nums[0...low] are 0s
#    - nums[low...mid] are 1s
#    - nums[mid..high] are unknown
#    - nums[(high + 1)..] are 2s
#
#    Rules:
#    - nums[mid] == 0 -> swap with low, move low and mid
#    - nums[mid] == 1 -> move mid
#    - nums[mid] == 2 -> swap with high, move high only
#
#    Why not move mid after swapping with high?
#    The value swapped from high has not been inspected yet.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 0, 2, 1, 1, 0]
#
# low = 0, mid = 0, high = 5
#
# nums[mid] = 2
# swap mid and high -> [0, 0, 2, 1, 1, 2]
# high = 4
# mid stays 0 because the new nums[mid] must be inspected
#
# nums[mid] = 0
# swap mid and low -> [0, 0, 2, 1, 1, 2]
# low = 1, mid = 1
#
# nums[mid] = 0
# swap mid and low -> [0, 0, 2, 1, 1, 2]
# low = 2, mid = 2
#
# nums[mid] = 2
# swap mid and high -> [0, 0, 1, 1, 2, 2]
# high = 3
#
# nums[mid] = 1
# mid = 3
#
# nums[mid] = 1
# mid = 4
# mid > high, stop
#
# Final array = [0, 0, 1, 1, 2, 2]
#
# Edge Cases:
# - all values same -> array stays valid
# - already sorted -> array stays valid
# - reverse sorted -> still handled in one pass

def sort_colors_true_brute_force(nums)
  count = Array.new(3, 0)
  nums.each { |num| count[num] += 1 }

  write = 0
  count.each_with_index do |frequency, color|
    frequency.times do
      nums[write] = color
      write += 1
    end
  end
end

def sort_colors(nums)
  low = 0
  mid = 0
  high = nums.length - 1

  while mid <= high
    case nums[mid]
    when 0
      nums[low], nums[mid] = nums[mid], nums[low]
      low += 1
      mid += 1
    when 1
      mid += 1
    when 2
      nums[mid], nums[high] = nums[high], nums[mid]
      high -= 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  brute_force_nums = [2, 0, 2, 1, 1, 0]
  optimized_nums = [2, 0, 2, 1, 1, 0]

  sort_colors_true_brute_force(brute_force_nums)
  sort_colors(optimized_nums)

  puts "True brute force: #{brute_force_nums}"
  puts "Optimized:        #{optimized_nums}"
end
