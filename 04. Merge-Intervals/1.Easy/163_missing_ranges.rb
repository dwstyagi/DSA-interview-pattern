# frozen_string_literal: true

# LeetCode 163: Missing Ranges
#
# Problem:
# You are given an inclusive range [lower, upper] and a sorted unique integer array nums,
# where all elements are within the range [lower, upper].
# Return the shortest sorted list of ranges that cover every missing number in [lower, upper].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Collect all missing numbers in [lower, upper] not in nums,
#    then group consecutive missing numbers into ranges.
#
#    Time Complexity: O(range_size)
#    Space Complexity: O(range_size)
#
# 2. Bottleneck
#    Iterating the full range can be huge. Instead, process gaps between nums elements.
#
# 3. Optimized Accepted Approach
#    Walk through gaps: before first element, between consecutive elements, after last element.
#    Use a helper to format the gap as a range string.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0,1,3,50,75], lower = 0, upper = 99
# Gap before 0: nothing (lower=0)
# Gap 1..2 → "2" (between 1 and 3)
# Gap 4..49 → "4->49"
# Gap 51..74 → "51->74"
# Gap 76..99 → "76->99"
# Result: ["2","4->49","51->74","76->99"]
#
# Edge Cases:
# - All numbers present -> []
# - Empty nums          -> ["lower->upper"]

def missing_ranges_brute(nums, lower, upper)
  result = []
  prev = lower - 1

  (nums + [upper + 1]).each do |curr|
    gap_start = prev + 1
    gap_end   = curr - 1
    if gap_start == gap_end
      result << gap_start.to_s
    elsif gap_start < gap_end
      result << "#{gap_start}->#{gap_end}"
    end
    prev = curr
  end

  result
end

def missing_ranges(nums, lower, upper)
  result = []

  # Helper: format the missing range between lo and hi (inclusive)
  add_range = ->(lo, hi) {
    return if lo > hi

    result << (lo == hi ? lo.to_s : "#{lo}->#{hi}")
  }

  # Gap before the first element
  add_range.call(lower, nums.empty? ? upper : nums[0] - 1)

  # Gaps between consecutive elements
  (0...nums.length - 1).each do |i|
    add_range.call(nums[i] + 1, nums[i + 1] - 1)
  end

  # Gap after the last element
  add_range.call(nums.empty? ? lower : nums[-1] + 1, upper) unless nums.empty?

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{missing_ranges_brute([0, 1, 3, 50, 75], 0, 99).inspect}"
  puts "Optimized:   #{missing_ranges([0, 1, 3, 50, 75], 0, 99).inspect}"
  # Both: ["2", "4->49", "51->74", "76->99"]
end
