# frozen_string_literal: true

# LeetCode 35: Search Insert Position
#
# Problem:
# Given a sorted array of distinct integers and a target value, return the
# index if target is found. If not, return the index where it would be
# inserted to keep the array sorted.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Linear scan until finding target or a value greater than target.
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Linear scan on sorted array.
#
# 3. Optimized Accepted Approach
#    Lower-bound binary search: half-open [l, r) → first index where nums[i] >= target.
#    Time Complexity: O(log n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# nums=[1,3,5,6], target=5 → found at index 2
# nums=[1,3,5,6], target=2 → not found; insert at index 1
# nums=[1,3,5,6], target=7 → insert at index 4 (end)
#
# Edge Cases:
# - Insert at beginning → return 0
# - Insert at end → return n

def search_insert_brute(nums, target)
  nums.each_with_index { |n, i| return i if n >= target }
  nums.length
end

def search_insert(nums, target)
  l = 0
  r = nums.length   # half-open: r can be nums.length (insert at end)

  while l < r
    mid = (l + r) / 2
    if nums[mid] < target
      l = mid + 1   # target must be to the right
    else
      r = mid       # nums[mid] >= target; this or left is the answer
    end
  end

  l
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 5)}"   # 2
  puts "Opt:   #{search_insert([1, 3, 5, 6], 5)}"         # 2
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 2)}"   # 1
  puts "Opt:   #{search_insert([1, 3, 5, 6], 2)}"         # 1
  puts "Brute: #{search_insert_brute([1, 3, 5, 6], 7)}"   # 4
  puts "Opt:   #{search_insert([1, 3, 5, 6], 7)}"         # 4
end
