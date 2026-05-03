# frozen_string_literal: true

# LeetCode 560: Subarray Sum Equals K
#
# Problem:
# Given an integer array nums and an integer k, return the total number of
# subarrays whose sum equals k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every pair (i, j), compute subarray sum nums[i..j], count matches.
#    Time Complexity: O(n²) or O(n³) with naive sum
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Recomputing subarray sums from scratch.
#
# 3. Optimized Accepted Approach
#    Running prefix sum + hash map. For each index i with running sum S,
#    any previous index j where prefix[j] = S - k forms a valid subarray [j+1..i].
#    Track count of each prefix sum seen so far.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 1, 1], k = 2
# freq = {0 => 1}; running = 0
# i=0: running=1, look for 1-2=-1 → 0 matches; freq={0:1,1:1}
# i=1: running=2, look for 2-2=0 → 1 match; freq={0:1,1:1,2:1}; count=1
# i=2: running=3, look for 3-2=1 → 1 match; freq={0:1,1:1,2:1,3:1}; count=2
# Return 2
#
# Edge Cases:
# - k=0 → count subarrays summing to 0 (including empty? no, prefix[0]=0 counts)
# - Negative numbers allowed

def subarray_sum_brute(nums, k)
  count = 0
  n = nums.length
  (0...n).each do |i|
    sum = 0
    (i...n).each do |j|
      sum += nums[j]
      count += 1 if sum == k
    end
  end
  count
end

def subarray_sum(nums, k)
  count = 0
  running = 0
  freq = { 0 => 1 }   # prefix sum 0 seen once (empty prefix)

  nums.each do |n|
    running += n
    count += (freq[running - k] || 0)   # subarrays ending here with sum k
    freq[running] = (freq[running] || 0) + 1
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{subarray_sum_brute([1, 1, 1], 2)}"    # 2
  puts "Opt:   #{subarray_sum([1, 1, 1], 2)}"          # 2
  puts "Brute: #{subarray_sum_brute([1, 2, 3], 3)}"    # 2
  puts "Opt:   #{subarray_sum([1, 2, 3], 3)}"          # 2
end
