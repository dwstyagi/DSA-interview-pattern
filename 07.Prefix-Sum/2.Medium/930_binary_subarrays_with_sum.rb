# frozen_string_literal: true

# LeetCode 930: Binary Subarrays With Sum
#
# Problem:
# Given a binary array nums and an integer goal, return the number of
# non-empty subarrays with a sum equal to goal.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check all subarrays, count those with sum == goal.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs.
#
# 3. Optimized Accepted Approach
#    Same as Subarray Sum Equals K (LC 560): prefix sum + frequency hash map.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1,0,1,0,1], goal = 2
# freq = {0=>1}; running = 0; count = 0
# i=0: run=1, look for 1-2=-1 → 0; freq={0:1,1:1}
# i=1: run=1, look for 1-2=-1 → 0; freq={0:1,1:2}
# i=2: run=2, look for 2-2=0 → 1; count=1; freq={0:1,1:2,2:1}
# i=3: run=2, look for 2-2=0 → 1; count=2; freq[2]=2
# i=4: run=3, look for 3-2=1 → 2; count=4; freq={...3:1}
# Return 4
#
# Edge Cases:
# - goal=0 → subarrays of all zeros
# - All ones → subarrays of exactly goal ones

def num_subarrays_with_sum_brute(nums, goal)
  count = 0
  n = nums.length
  (0...n).each do |i|
    sum = 0
    (i...n).each do |j|
      sum += nums[j]
      count += 1 if sum == goal
    end
  end
  count
end

def num_subarrays_with_sum(nums, goal)
  freq = { 0 => 1 }
  running = 0
  count = 0

  nums.each do |n|
    running += n
    count += (freq[running - goal] || 0)
    freq[running] = (freq[running] || 0) + 1
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{num_subarrays_with_sum_brute([1, 0, 1, 0, 1], 2)}"  # 4
  puts "Opt:   #{num_subarrays_with_sum([1, 0, 1, 0, 1], 2)}"        # 4
  puts "Brute: #{num_subarrays_with_sum_brute([0, 0, 0, 0, 0], 0)}"  # 15
  puts "Opt:   #{num_subarrays_with_sum([0, 0, 0, 0, 0], 0)}"        # 15
end
