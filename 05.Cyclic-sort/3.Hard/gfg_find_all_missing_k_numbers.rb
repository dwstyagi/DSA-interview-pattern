# frozen_string_literal: true

# GFG: Find All Missing K Numbers
#
# Problem:
# Given an array of n integers in range [1, n], some numbers may appear more than once
# and some may be missing. Find all K missing numbers.
# (Generalization: return all numbers in [1, n] not present in nums.)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a set; collect all missing numbers in [1, n].
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra space. Cyclic sort achieves O(1) extra.
#
# 3. Optimized Accepted Approach
#    Same as LC 448 (Find All Numbers Disappeared in an Array).
#    Cyclic sort, then collect all indices where nums[i] != i+1.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) extra
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 1, 8, 2, 3, 5, 1], looking for missing in [1,8]
# After cyclic sort: [1,2,3,1,5,3,2,8] → positions 3,5,6 have wrong values
# → missing are 4, 6, 7
#
# Edge Cases:
# - No missing   -> []
# - All missing  -> [1..n]

def find_all_missing_k_brute(nums)
  n = nums.length
  present = nums.to_set
  (1..n).reject { |i| present.include?(i) }
end

def find_all_missing_k(nums)
  n = nums.length
  i = 0

  # Cyclic sort: place value v at index v-1
  while i < n
    correct = nums[i] - 1
    if nums[i] >= 1 && nums[i] <= n && nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # Collect indices where the value doesn't match
  result = []
  nums.each_with_index { |v, idx| result << (idx + 1) if v != idx + 1 }
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_all_missing_k_brute([2, 3, 1, 8, 2, 3, 5, 1]).inspect}" # [4,6,7]
  puts "Optimized:   #{find_all_missing_k([2, 3, 1, 8, 2, 3, 5, 1]).inspect}"       # [4,6,7]
end
