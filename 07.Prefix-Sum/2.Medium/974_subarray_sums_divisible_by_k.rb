# frozen_string_literal: true

# LeetCode 974: Subarray Sums Divisible by K
#
# Problem:
# Given an integer array nums and an integer k, return the number of
# non-empty subarrays that have a sum divisible by k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every subarray, test if sum % k == 0.
#    Time Complexity: O(n²)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n²) pairs.
#
# 3. Optimized Accepted Approach
#    Prefix sum mod k + frequency map. If two prefix sums have the same
#    remainder, their difference (subarray sum) is divisible by k.
#    Count pairs of same-remainder prefix sums.
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [4, 5, 0, -2, -3, 1], k = 5
# freq = {0 => 1}; running = 0; count = 0
# i=0: run=4, rem=4; freq[4]=1
# i=1: run=9, rem=4; freq[4]=1 → count+=1=1; freq[4]=2
# i=2: run=9, rem=4; freq[4]=2 → count+=2=3; freq[4]=3
# i=3: run=7, rem=2; freq[2]=1
# i=4: run=4, rem=4; freq[4]=3 → count+=3=6; freq[4]=4
# i=5: run=5, rem=0; freq[0]=1 → count+=1=7
# Return 7
#
# Edge Cases:
# - All elements divisible by k → all subarrays count
# - Negative numbers require ((rem % k) + k) % k to handle negative mods

def subarrays_div_by_k_brute(nums, k)
  count = 0
  n = nums.length
  (0...n).each do |i|
    sum = 0
    (i...n).each do |j|
      sum += nums[j]
      count += 1 if sum % k == 0
    end
  end
  count
end

def subarrays_div_by_k(nums, k)
  freq = { 0 => 1 }   # remainder → count of prefix sums with that remainder
  running = 0
  count = 0

  nums.each do |n|
    running += n
    rem = ((running % k) + k) % k   # handle negative mod

    count += (freq[rem] || 0)        # each matching prefix sum creates a valid subarray
    freq[rem] = (freq[rem] || 0) + 1
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{subarrays_div_by_k_brute([4, 5, 0, -2, -3, 1], 5)}"  # 7
  puts "Opt:   #{subarrays_div_by_k([4, 5, 0, -2, -3, 1], 5)}"        # 7
  puts "Brute: #{subarrays_div_by_k_brute([5], 9)}"                    # 0
  puts "Opt:   #{subarrays_div_by_k([5], 9)}"                          # 0
end
