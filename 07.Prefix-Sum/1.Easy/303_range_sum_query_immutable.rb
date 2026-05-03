# frozen_string_literal: true

# LeetCode 303: Range Sum Query - Immutable
#
# Problem:
# Given an integer array nums, handle multiple queries of:
# sumRange(left, right) → sum of elements between indices left and right (inclusive).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each query, sum elements from left to right.
#    Time Complexity: O(n) per query
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n) per query is slow when there are many queries.
#
# 3. Optimized Accepted Approach
#    Build prefix sum array once. prefix[i] = sum of nums[0..i-1].
#    sumRange(l, r) = prefix[r+1] - prefix[l] → O(1) per query.
#    Time Complexity: O(n) build, O(1) query
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [-2, 0, 3, -5, 2, -1]
# prefix = [0, -2, -2, 1, -4, -2, -3]
# sumRange(0, 2) = prefix[3] - prefix[0] = 1 - 0 = 1
# sumRange(2, 5) = prefix[6] - prefix[2] = -3 - (-2) = -1
# sumRange(0, 5) = prefix[6] - prefix[0] = -3 - 0 = -3
#
# Edge Cases:
# - Query entire array → prefix[n] - prefix[0]
# - Single element query → prefix[l+1] - prefix[l] = nums[l]

class NumArrayBrute
  def initialize(nums)
    @nums = nums
  end

  def sum_range(left, right)
    @nums[left..right].sum   # O(n) each call
  end
end

class NumArray
  def initialize(nums)
    @prefix = [0]
    nums.each { |n| @prefix << @prefix[-1] + n }   # build prefix sums
  end

  def sum_range(left, right)
    @prefix[right + 1] - @prefix[left]   # O(1) range query
  end
end

if __FILE__ == $PROGRAM_NAME
  brute = NumArrayBrute.new([-2, 0, 3, -5, 2, -1])
  puts "Brute: #{brute.sum_range(0, 2)}"   # 1
  puts "Brute: #{brute.sum_range(2, 5)}"   # -1
  puts "Brute: #{brute.sum_range(0, 5)}"   # -3

  opt = NumArray.new([-2, 0, 3, -5, 2, -1])
  puts "Opt:   #{opt.sum_range(0, 2)}"     # 1
  puts "Opt:   #{opt.sum_range(2, 5)}"     # -1
  puts "Opt:   #{opt.sum_range(0, 5)}"     # -3
end
