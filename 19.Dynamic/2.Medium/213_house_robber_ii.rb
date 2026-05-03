# frozen_string_literal: true

# LeetCode 213: House Robber II
#
# Problem:
# Houses are in a circle; can't rob adjacent. Return max money.
# First and last houses are adjacent.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all non-adjacent subsets of circular arrangement.
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Circular constraint. Break circle: solve linear rob on [0..n-2] and [1..n-1].
#    Take the max of both.
#
# 3. Optimized Accepted Approach
#    Run House Robber I twice: once excluding last house, once excluding first.
#    Return max of both results.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, 2]
# Rob [2,3]: max=3. Rob [3,2]: max=3.
# Result: 3
#
# nums = [1,2,3,1]
# Rob [1,2,3]: dp->4. Rob [2,3,1]: dp->3. Max=4.
#
# Edge Cases:
# - Single house: rob it
# - Two houses: rob larger

def rob_linear(nums)
  rob1 = 0
  rob2 = 0
  nums.each { |n| rob1, rob2 = rob2, [rob2, rob1 + n].max }
  rob2
end

def rob_brute(nums)
  return nums[0] if nums.length == 1
  [rob_linear(nums[0...-1]), rob_linear(nums[1..])].max
end

def rob(nums)
  return nums[0] if nums.length == 1
  [rob_linear(nums[0...-1]), rob_linear(nums[1..])].max
end

if __FILE__ == $PROGRAM_NAME
  puts rob_brute([2, 3, 2])    # 3
  puts rob([1, 2, 3, 1])       # 4
end
