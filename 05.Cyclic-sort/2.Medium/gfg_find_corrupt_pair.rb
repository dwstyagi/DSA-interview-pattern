# frozen_string_literal: true

# GFG: Find the Corrupt Pair
#
# Problem:
# Given an array of n integers where one integer occurs twice and one is missing,
# find both the repeating and missing numbers.
# (Same as LeetCode 645 Set Mismatch — just GFG naming.)
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count frequencies; duplicated has count 2, missing has count 0.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra space. Cyclic sort achieves O(1) extra.
#
# 3. Optimized Accepted Approach
#    Cyclic sort. After sorting, scan for index mismatch:
#    nums[i] != i+1 → [nums[i], i+1] is the [corrupt, missing] pair.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 1, 2, 5, 3]
# cyclic sort: [1,2,3,3,5] → index 3 has 3 (should be 4)
# duplicate=3, missing=4
#
# Edge Cases:
# - Duplicate at boundary -> handled

def find_corrupt_pair_brute(nums)
  n = nums.length
  tally = nums.tally
  dup  = tally.find { |_, cnt| cnt == 2 }&.first
  miss = (1..n).find { |i| !tally[i] }
  [dup, miss]
end

def find_corrupt_pair(nums)
  n = nums.length
  i = 0

  # Cyclic sort: value v at index v-1
  while i < n
    correct = nums[i] - 1
    if nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  nums.each_with_index do |v, idx|
    return [v, idx + 1] if v != idx + 1
  end

  [-1, -1]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_corrupt_pair_brute([3, 1, 2, 5, 3]).inspect}" # [3,4]
  puts "Optimized:   #{find_corrupt_pair([3, 1, 2, 5, 3]).inspect}"       # [3,4]
end
