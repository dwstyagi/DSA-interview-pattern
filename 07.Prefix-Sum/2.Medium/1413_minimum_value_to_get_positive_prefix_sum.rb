# frozen_string_literal: true

# LeetCode 1413: Minimum Value to Get Positive Step by Step Sum
#
# Problem:
# Given an array nums, choose a positive integer startValue such that the
# step-by-step sum (startValue + running prefix sum) is always >= 1.
# Return the minimum such startValue.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try startValue from 1 upward. For each, simulate the prefix sums and
#    check if all are >= 1. Return the first that works.
#    Time Complexity: O(n * max_start)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear search over startValue is slow for large negative sums.
#
# 3. Optimized Accepted Approach
#    Compute running prefix sums; track the minimum prefix sum.
#    The minimum startValue needed is max(1, 1 - min_prefix_sum).
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-3, 2, -3, 4, 2]
# prefix sums: -3, -1, -4, 0, 2
# min prefix = -4
# startValue = max(1, 1 - (-4)) = max(1, 5) = 5
# Check: 5-3=2, 2+2=4, 4-3=1, 1+4=5, 5+2=7 ✓ all >= 1
#
# Edge Cases:
# - All positive → startValue = 1 (minimum must still be positive)
# - Single large negative → 1 - that value

def min_start_value_brute(nums)
  start = 1
  loop do
    running = start
    valid = true
    nums.each do |n|
      running += n
      if running < 1
        valid = false
        break
      end
    end
    return start if valid
    start += 1
  end
end

def min_start_value(nums)
  min_prefix = 0
  running = 0

  nums.each do |n|
    running += n
    min_prefix = [min_prefix, running].min   # track minimum running prefix sum
  end

  # need: startValue + min_prefix >= 1 → startValue >= 1 - min_prefix
  [1, 1 - min_prefix].max
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{min_start_value_brute([-3, 2, -3, 4, 2])}"  # 5
  puts "Opt:   #{min_start_value([-3, 2, -3, 4, 2])}"        # 5
  puts "Brute: #{min_start_value_brute([1, 2])}"              # 1
  puts "Opt:   #{min_start_value([1, 2])}"                    # 1
  puts "Brute: #{min_start_value_brute([1, -2, -3])}"         # 5
  puts "Opt:   #{min_start_value([1, -2, -3])}"               # 5
end
