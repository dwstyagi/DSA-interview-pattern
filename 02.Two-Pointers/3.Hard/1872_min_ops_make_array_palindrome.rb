# frozen_string_literal: true

# LeetCode 2422 (variant listed as 1872): Minimum Number of Operations to Make Array Palindrome
#
# Problem:
# Given an integer array nums, in one operation you can merge two adjacent elements
# (replace them with their sum). Return the minimum number of operations to make
# the array a palindrome.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all possible merge sequences and check for palindrome property.
#
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential combinations. Key insight: we only ever need to merge left or right side.
#
# 3. Optimized Accepted Approach
#    Two pointers: left and right starting from both ends.
#    If nums[left] == nums[right]: match found, advance both.
#    If nums[left] < nums[right]: merge left with its right neighbor (ops++, left value grows).
#    If nums[left] > nums[right]: merge right with its left neighbor (ops++, right value grows).
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [4, 3, 2, 1, 2, 3, 1]
# left=0(4), right=6(1): 4>1 → merge right: right=5(4), ops=1
# left=0(4), right=5(4): match, left=1, right=4
# left=1(3), right=4(2): 3>2 → merge right: right=3(3), ops=2
# left=1(3), right=3(3): match, left=2, right=2
# left==right → done, ops=2
#
# Edge Cases:
# - Already palindrome -> 0
# - Single element     -> 0
# - All same           -> 0

def min_operations_brute(nums)
  # Simulate all possible merges and find minimum to reach palindrome
  # (simplified brute: try greedy left-first then right-first)
  def check_palindrome(arr)
    arr == arr.reverse
  end

  count = 0
  arr = nums.dup
  left  = 0
  right = arr.length - 1

  while left < right
    if arr[left] == arr[right]
      left  += 1
      right -= 1
    elsif arr[left] < arr[right]
      arr[left + 1] += arr[left]
      arr.delete_at(left)
      right -= 1
      count += 1
    else
      arr[right - 1] += arr[right]
      arr.delete_at(right)
      right -= 1
      count += 1
    end
  end

  count
end

def min_operations(nums)
  left  = 0
  right = nums.length - 1
  # Use mutable sums for the two sides
  left_val  = nums[left]
  right_val = nums[right]
  ops = 0

  while left < right
    if left_val == right_val
      # Perfect match: move both pointers inward
      left  += 1
      right -= 1
      left_val  = nums[left]  if left  < right
      right_val = nums[right] if left  < right
    elsif left_val < right_val
      # Left side is smaller: merge left with its next neighbor
      left += 1
      left_val += nums[left]
      ops += 1
    else
      # Right side is smaller: merge right with its previous neighbor
      right -= 1
      right_val += nums[right]
      ops += 1
    end
  end

  ops
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{min_operations_brute([4, 3, 2, 1, 2, 3, 1])}" # 2
  puts "Optimized:   #{min_operations([4, 3, 2, 1, 2, 3, 1])}"       # 2
  puts "Brute force: #{min_operations_brute([1, 2, 3, 4])}"          # 3
  puts "Optimized:   #{min_operations([1, 2, 3, 4])}"                # 3
end
