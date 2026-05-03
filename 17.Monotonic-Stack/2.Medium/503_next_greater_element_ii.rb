# frozen_string_literal: true

# LeetCode 503: Next Greater Element II
#
# Problem:
# Given a circular array, return next greater number for each element.
# Search circularly. Return -1 if no greater element.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each element, scan forward circularly to find next greater.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. Simulate circular by iterating 2n with index modulo n.
#    Monotonic decreasing stack resolves elements when greater found.
#
# 3. Optimized Accepted Approach
#    Iterate 2n times. On first pass (i < n), push indices to stack.
#    When current > stack top's element, pop and set result.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 1]
# result = [-1,-1,-1]
# i=0(1): push 0
# i=1(2): 2>1 -> result[0]=2, pop; push 1
# i=2(1): 1<2, push 2
# i=3(1%3=0, 1): 1<2, no pop; skip push (i>=n)
# i=4(2%3=1, 2): 2>1 -> result[2]=2, pop; 2>=2 no pop; skip push
# Result: [2,-1,2]
#
# Edge Cases:
# - All same elements: all -1
# - Single element: [-1]

def next_greater_elements_brute(nums)
  n = nums.length
  result = Array.new(n, -1)
  n.times do |i|
    (1...n).each do |d|
      if nums[(i + d) % n] > nums[i]
        result[i] = nums[(i + d) % n]
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
  puts next_greater_elements_brute([1, 2, 1]).inspect    # [2,-1,2]
  puts next_greater_elements([1, 2, 3, 4, 3]).inspect    # [2,3,4,-1,4]
end
