# frozen_string_literal: true

# LeetCode 525: Contiguous Array
#
# Problem:
# Given a binary array nums, return the maximum length of a contiguous
# subarray containing an equal number of 0s and 1s.
#
# -----------------------------------------------------------------------------
# Key Observation
#
# Equal number of 0s and 1s means:
#
#   count(1s) - count(0s) = 0
#
# Convert:
#
#   0 -> -1
#   1 -> +1
#
# Now the problem becomes:
#
#   Find the longest subarray whose sum is 0.
#
# -----------------------------------------------------------------------------
# Prefix Sum Insight
#
# Let running be the prefix sum.
#
# If the same running sum appears at two indices:
#
#   running[i] == running[j]
#
# Then:
#
#   running[j] - running[i] = 0
#
# Meaning the subarray between them has sum 0.
#
# Since 0s were converted to -1 and 1s to +1,
# that subarray contains an equal number of 0s and 1s.
#
# -----------------------------------------------------------------------------
# Why Store the FIRST Occurrence?
#
# Example:
#
#   running sum 0 seen at:
#
#   index -1
#   index  3
#   index  8
#
# Using the earliest occurrence gives:
#
#   8 - (-1) = 9
#
# which is longer than:
#
#   8 - 3 = 5
#
# Therefore, store only the first time a running sum appears.
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [0, 1, 0]
#
# Convert conceptually:
#
#   [-1, 1, -1]
#
# first_seen = { 0 => -1 }
#
# i=0
# running = -1
# first time seeing -1
# store: { -1 => 0 }
#
# i=1
# running = 0
# seen before at index -1
# length = 1 - (-1) = 2
# max_len = 2
#
# i=2
# running = -1
# seen before at index 0
# length = 2 - 0 = 2
# max_len = 2
#
# Answer = 2
#
# -----------------------------------------------------------------------------
# Time Complexity: O(n)
# Space Complexity: O(n)

def find_max_length(nums)
  # running_sum => earliest index where it appeared
  first_seen = { 0 => -1 }

  running = 0
  max_len = 0

  nums.each_with_index do |bit, index|
    # Treat:
    # 0 as -1
    # 1 as +1
    running += bit.zero? ? -1 : 1

    if first_seen.key?(running)
      # Same running sum seen before.
      # Subarray between previous index and current index sums to 0.
      length = index - first_seen[running]
      max_len = [max_len, length].max
    else
      # Store only the first occurrence
      # to maximize future lengths.
      first_seen[running] = index
    end
  end

  max_len
end

# -----------------------------------------------------------------------------
# Brute Force (for understanding)

def find_max_length_brute(nums)
  n = nums.length
  max_len = 0

  (0...n).each do |start|
    zeros = 0
    ones = 0

    (start...n).each do |finish|
      nums[finish].zero? ? zeros += 1 : ones += 1

      max_len = [max_len, finish - start + 1].max if zeros == ones
    end
  end

  max_len
end

# -----------------------------------------------------------------------------
# Test Cases

if __FILE__ == $PROGRAM_NAME
  puts find_max_length([0, 1])                # 2
  puts find_max_length([0, 1, 0])             # 2
  puts find_max_length([0, 1, 1, 0, 0, 1]) # 6
  puts find_max_length([0, 0, 0])             # 0
  puts find_max_length([1, 1, 1])             # 0
end
