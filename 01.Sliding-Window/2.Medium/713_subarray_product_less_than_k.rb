# frozen_string_literal: true

# LeetCode 713: Subarray Product Less Than K
#
# Problem:
# Given an array of positive integers nums and an integer k, return the number
# of contiguous subarrays where the product of all the elements is strictly
# less than k.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every subarray.
#    For each subarray, maintain the running product while expanding right.
#    If the product is less than k, count it.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n^2) possible subarrays
#    - O(1) work per expansion once the running product is maintained
#
# 2. Bottleneck
#    Adjacent subarrays overlap heavily, so restarting from each left index
#    repeats work.
#    Since all numbers are positive, expanding right makes the product stay
#    the same or increase, and shrinking from the left makes the product
#    decrease.
#
#    That monotonic behavior means a sliding window can work.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window.
#    Expand right and multiply nums[right] into the running product.
#    If the product becomes too large, shrink left until:
#      product < k
#
#    Once the window is valid, count all valid subarrays ending at right.
#    If the valid window is nums[left..right], then these are valid:
#    - nums[right..right]
#    - nums[right - 1..right]
#    - ...
#    - nums[left..right]
#
#    That gives:
#      right - left + 1
#
#    new valid subarrays ending at right.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [10, 5, 2, 6]
# k = 100
#
# right = 0
# product = 10
# valid window = [10]
# new subarrays ending at 0 = 1
# count = 1
#
# right = 1
# product = 10 * 5 = 50
# valid window = [10, 5]
# new subarrays ending at 1:
# - [5]
# - [10, 5]
# count += 2 -> 3
#
# right = 2
# product = 50 * 2 = 100
# invalid, shrink from left
# divide by 10 -> product = 10, left = 1
# valid window = [5, 2]
# new subarrays ending at 2:
# - [2]
# - [5, 2]
# count += 2 -> 5
#
# right = 3
# product = 10 * 6 = 60
# valid window = [5, 2, 6]
# new subarrays ending at 3:
# - [6]
# - [2, 6]
# - [5, 2, 6]
# count += 3 -> 8
#
# Final answer = 8
#
# Edge Cases:
# - k <= 1 -> answer is 0 because all nums[i] are positive integers
# - single-element windows count if nums[i] < k
# - strict inequality matters: product must be < k, not <= k

def num_subarray_product_less_than_k_true_brute_force(nums, limit)
  count = 0

  (0...nums.length).each do |left|
    product = 1

    (left...nums.length).each do |right|
      product *= nums[right]
      count += 1 if product < limit
    end
  end

  count
end

def num_subarray_product_less_than_k(nums, limit)
  return 0 if limit <= 1

  left = 0
  product = 1
  count = 0

  nums.each_with_index do |num, right|
    product *= num
    left, product = shrink_product_window(nums, left, product, limit) if product >= limit
    count += right - left + 1
  end

  count
end

def shrink_product_window(nums, left, product, limit)
  while product >= limit
    product /= nums[left]
    left += 1
  end

  [left, product]
end

if __FILE__ == $PROGRAM_NAME
  nums = [10, 5, 2, 6]
  k = 100

  puts "True brute force: #{num_subarray_product_less_than_k_true_brute_force(nums, k)}"
  puts "Optimized:        #{num_subarray_product_less_than_k(nums, k)}"
end
