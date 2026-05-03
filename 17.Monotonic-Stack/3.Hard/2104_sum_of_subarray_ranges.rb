# frozen_string_literal: true

# LeetCode 2104: Sum of Subarray Ranges
#
# Problem:
# Given array nums, return sum of (max - min) for all subarrays.
# range(subarray) = max element - min element.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Enumerate all subarrays, track max and min, sum differences.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    sum(max-min) = sum(max) - sum(min).
#    Use monotonic stack to compute sum of subarray maximums and minimums separately.
#    (Same technique as LC 907.)
#
# 3. Optimized Accepted Approach
#    Compute sum of subarray mins (like LC 907) and sum of subarray maxs.
#    Answer = sum_max - sum_min.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 2, 3]
# subarrays: [1]=1-1=0, [2]=0, [3]=0, [1,2]=1, [2,3]=1, [1,2,3]=2
# sum = 4
#
# Edge Cases:
# - Single element: 0 (no subarray with range > 0)
# - All same: 0

def sub_array_ranges_brute(nums)
  total = 0
  n = nums.length
  n.times do |i|
    min_v = nums[i]
    max_v = nums[i]
    (i...n).each do |j|
      min_v = [min_v, nums[j]].min
      max_v = [max_v, nums[j]].max
      total += max_v - min_v
    end
  end
  total
end

# optimized: sum_max - sum_min via monotonic stacks
def sub_array_ranges(nums)
  n = nums.length

  contribution = lambda do |arr, is_min|
    stack = []
    total = 0
    (n + 1).times do |i|
      cur = i == n ? (is_min ? -Float::INFINITY : Float::INFINITY) : arr[i]
      while !stack.empty?
        top = stack.last
        top_val = arr[top]
        break if is_min ? top_val <= cur : top_val >= cur
        stack.pop
        left = stack.empty? ? -1 : stack.last
        total += top_val * (top - left) * (i - top)
      end
      stack << i
    end
    total
  end

  contribution.call(nums, false) - contribution.call(nums, true)
end

if __FILE__ == $PROGRAM_NAME
  puts sub_array_ranges_brute([1, 2, 3])   # 4
  puts sub_array_ranges([1, 3, 3])          # 4
end
