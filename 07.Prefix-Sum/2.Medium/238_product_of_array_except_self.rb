# frozen_string_literal: true

# LeetCode 238: Product of Array Except Self
#
# Problem:
# Given an integer array nums, return an array answer such that answer[i] is
# equal to the product of all elements except nums[i].
# Must run in O(n) and without using division.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each index i, multiply all other elements.
#    Time Complexity: O(n²)
#    Space Complexity: O(1) extra
#
# 2. Bottleneck
#    Recomputing the product for each index.
#
# 3. Optimized Accepted Approach
#    Left pass: result[i] = product of all elements to the left of i.
#    Right pass: multiply result[i] by product of all elements to the right.
#    No division needed, O(1) extra space (aside from output).
#    Time Complexity: O(n)
#    Space Complexity: O(1) extra (output array not counted)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3, 4]
# After left pass:  result = [1, 1, 2, 6]   (product of elements before each)
# Right pass (right accumulator):
#   i=3: result[3] *= 1 → 6;  right=4
#   i=2: result[2] *= 4 → 8;  right=12
#   i=1: result[1] *= 12 → 12; right=24
#   i=0: result[0] *= 24 → 24; right=24
# result = [24, 12, 8, 6]
#
# Edge Cases:
# - Array contains zeros → other elements multiplied normally
# - Single zeros handled naturally by the passes

def product_except_self_brute(nums)
  n = nums.length
  Array.new(n) { |i| (nums[0...i] + nums[i + 1..]).reduce(1, :*) }
end

def product_except_self(nums)
  n = nums.length
  result = Array.new(n, 1)

  # left pass: result[i] = product of nums[0..i-1]
  left = 1
  (0...n).each do |i|
    result[i] = left
    left *= nums[i]
  end

  # right pass: multiply by product of nums[i+1..n-1]
  right = 1
  (n - 1).downto(0) do |i|
    result[i] *= right
    right *= nums[i]
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{product_except_self_brute([1, 2, 3, 4]).inspect}"    # [24,12,8,6]
  puts "Opt:   #{product_except_self([1, 2, 3, 4]).inspect}"          # [24,12,8,6]
  puts "Brute: #{product_except_self_brute([-1, 1, 0, -3, 3]).inspect}"
  puts "Opt:   #{product_except_self([-1, 1, 0, -3, 3]).inspect}"
end
