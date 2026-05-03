# frozen_string_literal: true

# LeetCode 645: Set Mismatch
#
# Problem:
# You have a set of integers s, which originally contains all the numbers from 1 to n.
# Due to an error, one number in s got duplicated to another number in the set,
# which results in the repetition of one number and the loss of another number.
# Return [duplicated, missing].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use tally: find the number appearing twice and the number missing.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Extra O(n) for the hash. Cyclic sort finds both in O(1) space.
#
# 3. Optimized Accepted Approach
#    Cyclic sort: place value v at index v-1.
#    After sorting, the position where nums[i] != i+1 reveals:
#    - nums[i] is the duplicate
#    - i+1 is the missing number
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 2, 4]
# cyclic sort: [1,2,2,4] → index 2 should have 3 but has 2
# duplicate = 2, missing = 3
# Return [2, 3]
#
# Edge Cases:
# - Duplicate is 1 or n -> handled by mismatch check

def find_error_nums_brute(nums)
  tally = nums.tally
  dup  = tally.find { |_, cnt| cnt == 2 }&.first
  miss = (1..nums.length).find { |i| !tally[i] }
  [dup, miss]
end

def find_error_nums(nums)
  n = nums.length
  i = 0

  # Cyclic sort: value v goes to index v-1
  while i < n
    correct = nums[i] - 1
    if nums[i] != nums[correct]
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      i += 1
    end
  end

  # Find the one position that's wrong
  nums.each_with_index do |v, idx|
    return [v, idx + 1] if v != idx + 1
  end

  [-1, -1]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_error_nums_brute([1, 2, 2, 4]).inspect}" # [2,3]
  puts "Optimized:   #{find_error_nums([1, 2, 2, 4]).inspect}"       # [2,3]
  puts "Brute force: #{find_error_nums_brute([1, 1]).inspect}"       # [1,2]
  puts "Optimized:   #{find_error_nums([1, 1]).inspect}"             # [1,2]
end
