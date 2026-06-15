# frozen_string_literal: true

# LeetCode 974: Subarray Sums Divisible by K
#
# ------------------------------------------------------------
# Pattern
# Prefix Sum + Hash Map (Frequency Counting)
#
# Core Observation:
#
# Let:
#   prefix[i] = sum(nums[0..i])
#
# A subarray (i+1..j) is divisible by k if:
#
#   (prefix[j] - prefix[i]) % k == 0
#
# Rearranging:
#
#   prefix[j] % k == prefix[i] % k
#
# Therefore:
# Every time we see a remainder that we've seen before,
# each previous occurrence creates one valid subarray.
#
# ------------------------------------------------------------
# Example
#
# nums = [4,5,0,-2,-3,1]
# k = 5
#
# Prefix sums:
#   4   -> rem 4
#   9   -> rem 4
#   9   -> rem 4
#   7   -> rem 2
#   4   -> rem 4
#   5   -> rem 0
#
# Remainder frequencies:
#
# rem 0 => 2 occurrences
# rem 4 => 4 occurrences
# rem 2 => 1 occurrence
#
# Number of valid pairs:
#
# rem 0 -> C(2,2) = 1
# rem 4 -> C(4,2) = 6
#
# Total = 7
#
# ------------------------------------------------------------
# Hash Map Meaning
#
# freq[rem]
#   = how many previous prefix sums had this remainder
#
# When current remainder = rem:
#
#   count += freq[rem]
#
# because each previous matching remainder forms a
# subarray whose sum is divisible by k.
#
# ------------------------------------------------------------
# Complexity
#
# Time:  O(n)
# Space: O(k)
#
# ------------------------------------------------------------

def subarrays_div_by_k(nums, k)
  freq = { 0 => 1 } # empty prefix has remainder 0

  running_sum = 0
  count = 0

  nums.each do |num|
    running_sum += num

    # Normalize negative remainders
    rem = ((running_sum % k) + k) % k

    # Every previous matching remainder creates
    # one valid subarray ending at current index.
    count += freq[rem] || 0

    freq[rem] = (freq[rem] || 0) + 1
  end

  count
end

if __FILE__ == $PROGRAM_NAME
  p subarrays_div_by_k([4, 5, 0, -2, -3, 1], 5) # 7
  p subarrays_div_by_k([5], 9) # 0
end
