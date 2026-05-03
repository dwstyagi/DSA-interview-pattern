# frozen_string_literal: true

# LeetCode 442: Find All Duplicates in an Array
#
# Problem:
# Given an integer array nums of length n where all integers are in range [1, n]
# and each integer appears once or twice, return an array of all integers that appear twice.
# Must run in O(n) time using only O(1) extra space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use a hash map to count frequencies.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra O(n) space. Can mark visited by negating values in-place, or use cyclic sort.
#
# 3. Optimized Accepted Approach
#    Cyclic sort places each value v at index v-1.
#    After sorting, any index where nums[i] != i+1 holds a duplicate.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) extra
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [4,3,2,7,8,2,3,1]
# After cyclic sort: [1,2,3,4,3,6,7,8] — index 4 has value 3 (not 5), index 5 has 6 (≠6)
# Wait: index 4 → should be 5, but has 3; index 5 → should be 6, but has 6...
# Duplicates 2 and 3? Actually: [1,2,3,4,3,6,7,8] → idx4 = 3≠5, idx5 = 6=6 OK
# Hmm let me reconsider: [4,3,2,7,8,2,3,1] has duplicates 2 and 3.
# After sort: index where v != i+1 → those v values are the duplicates
#
# Edge Cases:
# - No duplicates -> []
# - All duplicate  -> each appears twice

def find_duplicates_brute(nums)
  nums.tally.select { |_, cnt| cnt == 2 }.keys
end

def find_duplicates(nums)
  n = nums.length
  i = 0

  # Cyclic sort: place value v at index v-1
  while i < n
    correct = nums[i] - 1
    if nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # Collect values that are not in their correct position (those are duplicates)
  result = []
  nums.each_with_index { |v, idx| result << v if v != idx + 1 }
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_duplicates_brute([4, 3, 2, 7, 8, 2, 3, 1]).inspect}" # [2,3]
  puts "Optimized:   #{find_duplicates([4, 3, 2, 7, 8, 2, 3, 1]).inspect}"       # [2,3]
  puts "Brute force: #{find_duplicates_brute([1, 1, 2]).inspect}"                 # [1]
  puts "Optimized:   #{find_duplicates([1, 1, 2]).inspect}"                       # [1]
end
