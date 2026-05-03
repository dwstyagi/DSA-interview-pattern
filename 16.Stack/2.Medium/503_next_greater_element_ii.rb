# frozen_string_literal: true

# LeetCode 503: Next Greater Element II
#
# Problem:
# Given a circular array, return the next greater number for each element.
# Search circularly. If no greater element exists, return -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each element, scan forward (circularly) to find next greater.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. Monotonic stack + simulate circular by iterating twice.
#
# 3. Optimized Accepted Approach
#    Iterate 2n times (i % n). Monotonic decreasing stack of indices.
#    When current > stack top, pop and set result. On second pass, don't push.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 1]
# result = [-1,-1,-1], stack=[]
# i=0(1): push 0 -> stack=[0]
# i=1(2): 2>nums[0]=1 -> result[0]=2, pop; push 1 -> stack=[1]
# i=2(1): 1<nums[1]=2 -> push 2 -> stack=[1,2]
# i=3(1%3=0): 1<nums[1]=2 -> push (but already filled, skip when i>=n)
# i=4(2): 2>nums[2]=1 -> result[2]=2, pop; 2>nums[1]=2? no. push (skip i>=n)
# Result: [2,-1,2]
#
# Edge Cases:
# - All same: all -1
# - Strictly increasing: first n-1 elements wrap to find larger, last is -1

def next_greater_elements_brute(nums)
  n = nums.length
  result = Array.new(n, -1)
  n.times do |i|
    (1...n).each do |j|
      if nums[(i + j) % n] > nums[i]
        result[i] = nums[(i + j) % n]
        break
      end
    end
  end
  result
end

def next_greater_elements(nums)
  n = nums.length
  result = Array.new(n, -1)
  stack = []
  (2 * n).times do |i|
    while !stack.empty? && nums[stack.last] < nums[i % n]
      result[stack.pop] = nums[i % n]
    end
    stack << (i % n) if i < n
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts next_greater_elements_brute([1, 2, 1]).inspect  # [2,-1,2]
  puts next_greater_elements([1, 2, 3, 4, 3]).inspect  # [2,3,4,-1,4]
end
