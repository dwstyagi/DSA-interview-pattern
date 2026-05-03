# frozen_string_literal: true

# LeetCode 228: Summary Ranges
#
# Problem:
# You are given a sorted unique integer array nums. Return the smallest sorted list
# of ranges that cover all the numbers in the array exactly.
# Each range [a, b] in the output should be formatted as "a->b" if a != b,
# and "a" if a == b.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compare each element to the next, group consecutive runs.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already linear; no significant optimization needed.
#
# 3. Optimized Accepted Approach
#    Walk with a start pointer. Extend while consecutive.
#    When the run breaks, output the range and start a new one.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0,1,2,4,5,7]
# start=0: 0,1,2 consecutive → run ends at 2 → "0->2"
# start=4: 4,5 consecutive → run ends at 5 → "4->5"
# start=7: single → "7"
# Result: ["0->2","4->5","7"]
#
# Edge Cases:
# - Empty array         -> []
# - All consecutive     -> ["first->last"]
# - No consecutive runs -> each number standalone

def summary_ranges_brute(nums)
  return [] if nums.empty?

  result = []
  i = 0
  while i < nums.length
    start = nums[i]
    # Advance while consecutive
    i += 1 while i + 1 < nums.length && nums[i + 1] == nums[i] + 1
    result << (nums[i] == start ? start.to_s : "#{start}->#{nums[i]}")
    i += 1
  end
  result
end

def summary_ranges(nums)
  result = []
  i = 0

  while i < nums.length
    start = nums[i]

    # Extend as far as the run of consecutive integers goes
    i += 1 while i + 1 < nums.length && nums[i + 1] == nums[i] + 1

    # Format: single value vs range
    result << (nums[i] == start ? start.to_s : "#{start}->#{nums[i]}")
    i += 1
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{summary_ranges_brute([0, 1, 2, 4, 5, 7]).inspect}" # ["0->2","4->5","7"]
  puts "Optimized:   #{summary_ranges([0, 1, 2, 4, 5, 7]).inspect}"       # ["0->2","4->5","7"]
  puts "Brute force: #{summary_ranges_brute([0, 2, 3, 4, 6, 8, 9]).inspect}"
  puts "Optimized:   #{summary_ranges([0, 2, 3, 4, 6, 8, 9]).inspect}"
end
