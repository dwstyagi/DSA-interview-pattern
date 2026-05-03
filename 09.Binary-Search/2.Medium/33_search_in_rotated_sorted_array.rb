# frozen_string_literal: true

# LeetCode 33: Search in Rotated Sorted Array
#
# Problem:
# Given an integer array nums sorted in ascending order and rotated at some
# pivot, and an integer target, return the index of target or -1 if not found.
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
#    O(n) ignores sorted structure.
#
# 3. Optimized Accepted Approach
#    Modified binary search. At each mid, at least one half is sorted.
#    Test which half is sorted, then check if target lies in that range.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[4,5,6,7,0,1,2], target=0
# l=0,r=6: mid=3, nums[3]=7
#   Left sorted? nums[0]=4 <= nums[3]=7 → yes, left is sorted
#   Target in [4,7]? 0 not in → l=4
# l=4,r=6: mid=5, nums[5]=1
#   Left sorted? nums[4]=0 <= nums[5]=1 → yes
#   Target in [0,1]? 0 is in → r=4
# l=r=4, nums[4]=0 == target → return 4 ✓
#
# Edge Cases:
# - Not rotated → standard binary search works
# - Target = pivot element

def search_rotated_brute(nums, target)
  nums.index(target) || -1
end

def search_rotated(nums, target)
  l = 0
  r = nums.length - 1

  while l <= r
    mid = (l + r) / 2
    return mid if nums[mid] == target

    if nums[l] <= nums[mid]   # left half is sorted
      if nums[l] <= target && target < nums[mid]
        r = mid - 1   # target in sorted left half
      else
        l = mid + 1   # target in right half
      end
    else                      # right half is sorted
      if nums[mid] < target && target <= nums[r]
        l = mid + 1   # target in sorted right half
      else
        r = mid - 1   # target in left half
      end
    end
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{search_rotated_brute([4, 5, 6, 7, 0, 1, 2], 0)}"   # 4
  puts "Opt:   #{search_rotated([4, 5, 6, 7, 0, 1, 2], 0)}"         # 4
  puts "Brute: #{search_rotated_brute([4, 5, 6, 7, 0, 1, 2], 3)}"   # -1
  puts "Opt:   #{search_rotated([4, 5, 6, 7, 0, 1, 2], 3)}"         # -1
  puts "Brute: #{search_rotated_brute([1], 0)}"                      # -1
  puts "Opt:   #{search_rotated([1], 0)}"                            # -1
end
