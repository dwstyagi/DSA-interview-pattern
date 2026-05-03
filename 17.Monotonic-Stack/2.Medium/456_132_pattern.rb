# frozen_string_literal: true

# LeetCode 456: 132 Pattern
#
# Problem:
# Given array nums, return true if there exists i < j < k such that
# nums[i] < nums[k] < nums[j] (a 132 pattern).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all triples (i, j, k). Check condition.
#    Time Complexity: O(n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Three nested loops. Scan from right with a stack. Track the largest "third"
#    element seen so far (max element that could be nums[k] in the 132 pattern).
#
# 3. Optimized Accepted Approach
#    Scan from right to left with monotonic decreasing stack. Track `third` = max
#    element popped (candidate for nums[k]). When stack top < current, pop and
#    update third. If current < third, found the "1" in 132 pattern.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 1, 4, 2]
# third = -inf, stack=[]
# i=3(2): push 2, stack=[2]
# i=2(4): 4>2 -> pop, third=2; push 4, stack=[4]
# i=1(1): 1<third=2 -> return true!
#
# Edge Cases:
# - Fewer than 3 elements: false
# - All ascending: no valid triple

def find132_pattern_brute?(nums)
  n = nums.length
  n.times do |i|
    (i + 1...n).each do |j|
      (j + 1...n).each do |k|
        return true if nums[i] < nums[k] && nums[k] < nums[j]
      end
    end
  end
  false
end

def find132_pattern?(nums)
  stack = []
  third = -Float::INFINITY  # nums[k] candidate
  (nums.length - 1).downto(0) do |i|
    return true if nums[i] < third
    while !stack.empty? && stack.last < nums[i]
      third = stack.pop
    end
    stack << nums[i]
  end
  false
end

if __FILE__ == $PROGRAM_NAME
  puts find132_pattern_brute?([1, 2, 3, 4])  # false
  puts find132_pattern?([3, 1, 4, 2])         # true
  puts find132_pattern?([-1, 3, 2, 0])        # true
end
