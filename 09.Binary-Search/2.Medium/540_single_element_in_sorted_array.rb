# frozen_string_literal: true

# LeetCode 540: Single Element in a Sorted Array
#
# Problem:
# You are given a sorted array consisting of only integers where every element
# appears exactly twice, except for one element which appears exactly once.
# Return the single element that appears only once.
# Must run in O(log n) time and O(1) space.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    XOR all elements — pairs cancel out, the single element remains.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    XOR is linear — the constraint demands O(log n), so we need binary search.
#
# 3. Optimized Accepted Approach
#    Binary search on even indices. In the "normal" left half, pairs satisfy
#    nums[i] == nums[i+1] when i is even. If the mid element (forced to even)
#    satisfies this, the single element is to the right; otherwise left.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1, 1, 2, 3, 3, 4, 4, 8, 8]
# lo=0, hi=8 → mid=4 (even) → nums[4]=3, nums[5]=4 → not equal → hi=4
# lo=0, hi=4 → mid=2 (even) → nums[2]=2, nums[3]=3 → not equal → hi=2
# lo=0, hi=2 → mid=1 → odd → mid=0 → nums[0]=1, nums[1]=1 → equal → lo=2
# lo=2, hi=2 → return nums[2]=2 ✓
#
# Edge Cases:
# - Single element at start [1, 2, 2] -> 1
# - Single element at end [1, 1, 2] -> 2
# - Array of length 1 [5] -> 5

def single_non_duplicate_brute(nums)
  nums.reduce(:^) # XOR all; pairs cancel
end

def single_non_duplicate(nums)
  lo, hi = 0, nums.length - 1

  while lo < hi
    mid = (lo + hi) / 2
    mid -= 1 if mid.odd? # ensure mid is even so pair partner is mid+1

    if nums[mid] == nums[mid + 1]
      lo = mid + 2 # pair is intact, single is in right half
    else
      hi = mid     # pair broken, single is mid or to the left
    end
  end

  nums[lo]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{single_non_duplicate_brute([1, 1, 2, 3, 3, 4, 4, 8, 8])}" # 2
  puts "Opt:   #{single_non_duplicate([1, 1, 2, 3, 3, 4, 4, 8, 8])}"        # 2
  puts "Brute: #{single_non_duplicate_brute([3, 3, 7, 7, 10, 11, 11])}"     # 10
  puts "Opt:   #{single_non_duplicate([3, 3, 7, 7, 10, 11, 11])}"           # 10
end
