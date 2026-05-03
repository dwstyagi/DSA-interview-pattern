# frozen_string_literal: true

# LeetCode 152: Maximum Product Subarray
#
# Problem:
# Given integer array nums, find the contiguous subarray with the largest product.
# Return that product.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subarrays, compute product of each, track maximum.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Negative numbers can flip min to max. Track both current max and min products.
#
# 3. Optimized Accepted Approach
#    Maintain cur_max and cur_min (negative * negative = large positive).
#    At each element: new_max = max(n, cur_max*n, cur_min*n).
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [2, 3, -2, 4]
# cur_max=2, cur_min=2, result=2
# n=3: max=6, min=6, result=6
# n=-2: max=max(-2,6*-2,6*-2)=-2, min=-12, result=6
# n=4: max=max(4,-2*4,-12*4)=4, min=-48, result=6
# Result: 6
#
# Edge Cases:
# - Single element: return it (can be negative)
# - All negatives (even count): large product possible

def max_product_brute(nums)
  max_p = nums[0]
  n = nums.length
  n.times do |i|
    prod = 1
    (i...n).each do |j|
      prod *= nums[j]
      max_p = [max_p, prod].max
    end
  end
  max_p
end

def max_product(nums)
  cur_max = nums[0]
  cur_min = nums[0]
  result = nums[0]
  (1...nums.length).each do |i|
    n = nums[i]
    candidates = [n, cur_max * n, cur_min * n]
    cur_max = candidates.max
    cur_min = candidates.min
    result = [result, cur_max].max
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts max_product_brute([2, 3, -2, 4])  # 6
  puts max_product([-2, 0, -1])          # 0
end
