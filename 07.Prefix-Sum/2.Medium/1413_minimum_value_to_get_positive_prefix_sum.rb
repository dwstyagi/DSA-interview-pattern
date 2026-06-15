# frozen_string_literal: true

# LeetCode 1413 - Minimum Value to Get Positive Step by Step Sum
#
# -----------------------------------------------------------------------------
# PROBLEM
#
# We need to choose the smallest positive integer `start_value`.
#
# Starting from start_value, add each element in nums one by one.
#
# The running sum must NEVER drop below 1.
#
# Example:
#
# nums = [-3, 2, -3, 4, 2]
#
# start = 5
#
# 5 + (-3) = 2
# 2 + 2    = 4
# 4 + (-3) = 1
# 1 + 4    = 5
# 5 + 2    = 7
#
# All values are >= 1, so answer = 5.
#
# -----------------------------------------------------------------------------
# THINKING PROCESS
#
# Let:
#
# prefix_sum[i] = sum of nums[0..i]
#
# Then every running sum becomes:
#
# start_value + prefix_sum[i]
#
# We need:
#
# start_value + prefix_sum[i] >= 1
#
# for EVERY prefix.
#
# Instead of checking all prefixes individually,
# only the SMALLEST prefix sum matters.
#
# Why?
#
# If the worst prefix is valid,
# all larger prefixes are automatically valid.
#
# Example:
#
# prefix sums:
#
# -3
# -1
# -4   <- minimum prefix
#  0
#  2
#
# Need:
#
# start_value + (-4) >= 1
#
# start_value >= 5
#
# Therefore:
#
# answer = 1 - min_prefix
#
# -----------------------------------------------------------------------------
# APPROACH 1 - TRUE BRUTE FORCE
#
# Try:
#
# start = 1
# start = 2
# start = 3
# ...
#
# For each candidate:
#
# - simulate the running sum
# - if it ever drops below 1 -> fail
# - otherwise return that start value
#
# Time:  O(answer * n)
# Space: O(1)
#
def min_start_value_brute(nums)
  start_value = 1

  loop do
    running_sum = start_value
    valid = true

    nums.each do |num|
      running_sum += num

      if running_sum < 1
        valid = false
        break
      end
    end

    return start_value if valid

    start_value += 1
  end
end

# -----------------------------------------------------------------------------
# APPROACH 2 - OPTIMIZED
#
# Key Observation:
#
# We only need the minimum prefix sum.
#
# Example:
#
# nums = [-3, 2, -3, 4, 2]
#
# running prefixes:
#
# -3
# -1
# -4
#  0
#  2
#
# min_prefix = -4
#
# Need:
#
# start_value + min_prefix >= 1
#
# start_value >= 1 - min_prefix
#
# start_value >= 1 - (-4)
# start_value >= 5
#
# Answer = 5
#
# Algorithm:
#
# 1. Build running prefix sum.
# 2. Track the smallest prefix seen.
# 3. Return 1 - min_prefix.
#
# Time:  O(n)
# Space: O(1)
#
def min_start_value(nums)
  running_sum = 0
  min_prefix = 0

  nums.each do |num|
    running_sum += num

    # Keep track of the worst prefix sum seen so far.
    min_prefix = [min_prefix, running_sum].min
  end

  # Need:
  #
  # start_value + min_prefix >= 1
  #
  # Therefore:
  #
  # start_value >= 1 - min_prefix
  #
  1 - min_prefix
end

# -----------------------------------------------------------------------------
# DRY RUN
#
# nums = [-3, 2, -3, 4, 2]
#
# running_sum   min_prefix
# --------------------------------
# -3            -3
# -1            -3
# -4            -4
#  0            -4
#  2            -4
#
# answer = 1 - (-4)
#        = 5
#
# -----------------------------------------------------------------------------
# EDGE CASES
#
# nums = [1, 2, 3]
#
# prefixes:
# 1, 3, 6
#
# min_prefix = 0
#
# answer = 1 - 0 = 1
#
# --------------------------------
#
# nums = [-5]
#
# prefixes:
# -5
#
# min_prefix = -5
#
# answer = 1 - (-5)
#        = 6
#
# -----------------------------------------------------------------------------

if __FILE__ == $PROGRAM_NAME
  puts min_start_value([-3, 2, -3, 4, 2]) # 5
  puts min_start_value([1, 2])             # 1
  puts min_start_value([1, -2, -3])        # 5
  puts min_start_value([-5])               # 6
end
