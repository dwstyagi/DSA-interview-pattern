# frozen_string_literal: true

# LeetCode 169: Majority Element
#
# Problem:
# Given array nums, return the majority element — the element appearing
# more than n/2 times. The majority element always exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each element, count its occurrences. Return when count > n/2.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Counting each element repeatedly wastes work. Use a hash or sorting.
#    Boyer-Moore voting achieves O(n) time and O(1) space.
#
# 3. Optimized Accepted Approach
#    Boyer-Moore Voting: maintain candidate and count. If count == 0, new candidate.
#    Same element: count++; different element: count--.
#    Majority element survives all cancellations.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 2, 1, 1, 1, 2, 2]
# candidate=2, count=1 -> 2: count=2 -> 1: count=1 -> 1: count=0
# -> 1: candidate=1,count=1 -> 2: count=0 -> 2: candidate=2,count=1
# Result: 2 (but majority is 2, correct)
#
# Edge Cases:
# - Single element: return it
# - All same: return that element

def majority_element_brute(nums)
  n = nums.length
  nums.each do |num|
    count = nums.count(num)
    return num if count > n / 2
  end
end

# optimized: Boyer-Moore voting
def majority_element(nums)
  candidate = nil
  count = 0
  nums.each do |num|
    if count == 0
      candidate = num
      count = 1
    elsif num == candidate
      count += 1
    else
      count -= 1
    end
  end
  candidate
end

if __FILE__ == $PROGRAM_NAME
  puts majority_element_brute([3, 2, 3])             # 3
  puts majority_element([2, 2, 1, 1, 1, 2, 2])       # 2
end
