# frozen_string_literal: true

# GFG: Sort an Array (in range) using Cyclic Sort
#
# Problem:
# Given an array containing values in range 1..N, sort it in O(n) time
# and O(1) extra space using the cyclic sort technique.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use Ruby's built-in sort.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Generic comparison sort. For values in 1..N we can exploit the index-value mapping.
#
# 3. Optimized Accepted Approach
#    Cyclic Sort: value v belongs at index v-1.
#    Walk through the array; if nums[i] is not at its correct index, swap it there.
#    Advance i only when nums[i] is correctly placed.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [3, 1, 5, 4, 2]
# i=0: nums[0]=3, correct=2, nums[2]=5≠3 → swap → [5,1,3,4,2]
# i=0: nums[0]=5, correct=4, nums[4]=2≠5 → swap → [2,1,3,4,5]
# i=0: nums[0]=2, correct=1, nums[1]=1≠2 → swap → [1,2,3,4,5]
# i=0: nums[0]=1, correct=0, nums[0]=1 → advance, i=1
# ... all placed
# Result: [1,2,3,4,5]
#
# Edge Cases:
# - Already sorted -> no swaps needed
# - Reverse sorted -> max swaps but still O(n)

def cyclic_sort_brute(nums)
  nums.sort
end

def cyclic_sort(nums)
  i = 0

  while i < nums.length
    correct = nums[i] - 1 # value v belongs at index v-1

    if nums[i] != nums[correct]
      # Place nums[i] at its correct position
      nums[i], nums[correct] = nums[correct], nums[i]
    else
      # Already in correct position (or duplicate — stops infinite loop)
      i += 1
    end
  end

  nums
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{cyclic_sort_brute([3, 1, 5, 4, 2]).inspect}" # [1,2,3,4,5]
  puts "Optimized:   #{cyclic_sort([3, 1, 5, 4, 2]).inspect}"       # [1,2,3,4,5]
  puts "Brute force: #{cyclic_sort_brute([2, 6, 4, 3, 1, 5]).inspect}"
  puts "Optimized:   #{cyclic_sort([2, 6, 4, 3, 1, 5]).inspect}"
end
