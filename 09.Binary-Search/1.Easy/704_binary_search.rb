# frozen_string_literal: true

# LeetCode 704: Binary Search
#
# Problem:
# Given an array of integers nums sorted in ascending order, and an integer
# target, write a function to search target in nums. Return index if found,
# otherwise return -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    O(n) linear scan when array is sorted.
#
# 3. Optimized Accepted Approach
#    Classic binary search. Maintain [l, r] inclusive. Compare mid to target,
#    narrow the search space by half each step.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[-1,0,3,5,9,12], target=9
# l=0,r=5: mid=2, nums[2]=3 < 9 → l=3
# l=3,r=5: mid=4, nums[4]=9 == 9 → return 4 ✓
#
# Edge Cases:
# - Target not in array → return -1
# - Single element array → check directly

def search_brute(nums, target)
  nums.index(target) || -1
end

def search(nums, target)
  l = 0
  r = nums.length - 1

  while l <= r
    mid = (l + r) / 2
    if nums[mid] == target
      return mid
    elsif nums[mid] < target
      l = mid + 1   # target in right half
    else
      r = mid - 1   # target in left half
    end
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{search_brute([-1, 0, 3, 5, 9, 12], 9)}"   # 4
  puts "Opt:   #{search([-1, 0, 3, 5, 9, 12], 9)}"         # 4
  puts "Brute: #{search_brute([-1, 0, 3, 5, 9, 12], 2)}"   # -1
  puts "Opt:   #{search([-1, 0, 3, 5, 9, 12], 2)}"         # -1
end
