# frozen_string_literal: true

# LeetCode 1095: Find in Mountain Array
#
# Problem:
# (This problem is an interactive problem.)
# Given a mountain array (strictly increasing then strictly decreasing), find
# the minimum index where mountainArr.get(index) == target. Return -1 if not
# found. You may call mountainArr.get() at most 100 times.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan from left to right, return first matching index.
#    Time Complexity: O(n) — too many get() calls
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan uses O(n) API calls. We need three separate binary searches.
#
# 3. Optimized Accepted Approach
#    Step 1: Binary search for the peak index.
#    Step 2: Binary search for target in the ascending left half.
#    Step 3: If not found, binary search in the descending right half.
#    Return minimum index (prefer left occurrence).
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# arr=[1,2,3,4,5,3,1], target=3
# Step1: peak → index 4 (value 5)
# Step2: ascending [0..4] → binary search 3 → found at index 2
# Result: 2 ✓
#
# arr=[1,2,3,4,5,3,1], target=1
# Step2: ascending → index 0
# Result: 0 ✓
#
# Edge Cases:
# - Target is the peak -> return peak index
# - Target only on descending side
# - Target not present -> -1

# Simulated MountainArray interface for testing
class MountainArray
  def initialize(arr)
    @arr = arr
  end

  def get(index)
    @arr[index]
  end

  def length
    @arr.length
  end
end

def find_in_mountain_array_brute(target, mountain_arr)
  (0...mountain_arr.length).each do |i|
    return i if mountain_arr.get(i) == target
  end
  -1
end

def find_in_mountain_array(target, mountain_arr)
  n = mountain_arr.length

  # Step 1: find peak index
  lo, hi = 0, n - 1
  while lo < hi
    mid = (lo + hi) / 2
    mountain_arr.get(mid) < mountain_arr.get(mid + 1) ? lo = mid + 1 : hi = mid
  end
  peak = lo

  # Step 2: binary search ascending left half [0..peak]
  lo, hi = 0, peak
  while lo <= hi
    mid = (lo + hi) / 2
    v = mountain_arr.get(mid)
    if v == target
      return mid
    elsif v < target
      lo = mid + 1
    else
      hi = mid - 1
    end
  end

  # Step 3: binary search descending right half [peak..n-1]
  lo, hi = peak, n - 1
  while lo <= hi
    mid = (lo + hi) / 2
    v = mountain_arr.get(mid)
    if v == target
      return mid
    elsif v > target
      lo = mid + 1  # descending: larger values are to the left
    else
      hi = mid - 1
    end
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  ma1 = MountainArray.new([1, 2, 3, 4, 5, 3, 1])
  puts "Brute: #{find_in_mountain_array_brute(3, ma1)}"  # 2
  ma1 = MountainArray.new([1, 2, 3, 4, 5, 3, 1])
  puts "Opt:   #{find_in_mountain_array(3, ma1)}"         # 2

  ma2 = MountainArray.new([0, 1, 2, 4, 2, 1])
  puts "Brute: #{find_in_mountain_array_brute(3, ma2)}"  # -1
  ma2 = MountainArray.new([0, 1, 2, 4, 2, 1])
  puts "Opt:   #{find_in_mountain_array(3, ma2)}"         # -1
end
