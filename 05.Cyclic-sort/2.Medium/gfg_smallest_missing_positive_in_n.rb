# frozen_string_literal: true

# GFG: Find the Smallest Missing Positive Number (in N)
#
# Problem:
# Given an array of n positive integers where all elements are in range [1, N],
# find the smallest missing positive integer.
# (This version guarantees values are in [1, N] — simpler than LC 41.)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a boolean set; scan 1..N to find the first missing.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra space. Cyclic sort gives O(1).
#
# 3. Optimized Accepted Approach
#    Cyclic sort for values in [1, N] → index 0..N-1.
#    Scan for first mismatch.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 4, 1, 5]
# After cyclic sort: [1,2,3,4,5] → all match → return 6 (n+1)
#
# nums = [2, 3, 4, 6, 1]
# After sort: [1,2,3,4,6] → idx 4 has 6≠5 → return 5
#
# Edge Cases:
# - All present 1..N -> N+1
# - All duplicates   -> 1 missing

def find_smallest_missing_in_n_brute(nums)
  present = nums.to_set
  1.upto(nums.length + 1) { |i| return i unless present.include?(i) }
end

def find_smallest_missing_in_n(nums)
  n = nums.length
  i = 0

  # Cyclic sort: value v (in 1..n) goes to index v-1
  while i < n
    correct = nums[i] - 1
    if nums[i] >= 1 && nums[i] <= n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # First position where value doesn't match is the answer
  nums.each_with_index { |v, idx| return idx + 1 if v != idx + 1 }
  n + 1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_smallest_missing_in_n_brute([2, 3, 4, 1, 5])}" # 6
  puts "Optimized:   #{find_smallest_missing_in_n([2, 3, 4, 1, 5])}"       # 6
  puts "Brute force: #{find_smallest_missing_in_n_brute([2, 3, 4, 6, 1])}" # 5
  puts "Optimized:   #{find_smallest_missing_in_n([2, 3, 4, 6, 1])}"       # 5
end
