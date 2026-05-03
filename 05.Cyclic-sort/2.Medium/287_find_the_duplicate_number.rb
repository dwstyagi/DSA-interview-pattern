# frozen_string_literal: true

# LeetCode 287: Find the Duplicate Number
#
# Problem:
# Given an array of integers nums containing n+1 integers where each integer is in [1, n],
# there is only one repeated number. Return this repeated number.
# Must use only constant extra space and not modify the array.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort the array (modifies it) and find the duplicate.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(1) but modifies array
#
# 2. Bottleneck
#    Can't modify the array; need O(1) space. Fast-slow pointer (Floyd's cycle detection)
#    treats the array as a linked list.
#
# 3. Optimized Accepted Approach (Floyd's Cycle Detection)
#    Treat nums as a linked list: i → nums[i].
#    The duplicate creates a cycle. Find cycle with fast/slow pointer, then find entry.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums = [1,3,4,2,2]
# Phase 1: slow=1→3→2→4→2..., fast=3→2→2→2... meet at 2
# Phase 2: slow2=0→1→3→2, slow=2→4→2 → meet at 2
# duplicate = 2
#
# Edge Cases:
# - Duplicate at beginning -> works
# - All pointing to same   -> works
# - n=1                    -> the only number

def find_duplicate_brute(nums)
  seen = {}
  nums.each { |n| return n if seen[n]; seen[n] = true }
end

def find_duplicate(nums)
  # Floyd's cycle detection in the implicit linked list i → nums[i]
  slow = nums[0]
  fast = nums[0]

  # Phase 1: find the meeting point inside the cycle
  loop do
    slow = nums[slow]
    fast = nums[nums[fast]]
    break if slow == fast
  end

  # Phase 2: find the entry point of the cycle (= the duplicate)
  slow2 = nums[0]
  while slow2 != slow
    slow2 = nums[slow2]
    slow  = nums[slow]
  end

  slow
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{find_duplicate_brute([1, 3, 4, 2, 2])}" # 2
  puts "Optimized:   #{find_duplicate([1, 3, 4, 2, 2])}"       # 2
  puts "Brute force: #{find_duplicate_brute([3, 1, 3, 4, 2])}" # 3
  puts "Optimized:   #{find_duplicate([3, 1, 3, 4, 2])}"       # 3
end
