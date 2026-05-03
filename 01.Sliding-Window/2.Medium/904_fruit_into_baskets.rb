# frozen_string_literal: true

# LeetCode 904: Fruit Into Baskets
#
# Problem:
# Given an array fruits where fruits[i] is the type of fruit on the i-th tree,
# return the maximum number of fruits you can collect if:
# - you have exactly 2 baskets
# - each basket can hold only one fruit type
# - each basket can hold any amount of that type
# - starting from some index, you must pick exactly one fruit from every tree
#   while moving to the right
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every starting index.
#    Expand right while tracking fruit counts in the current subarray.
#    As long as there are at most 2 distinct fruit types, update the answer.
#    Stop expanding when a third type appears.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n) choices for the start
#    - O(n) expansion in the worst case for each start
#
# 2. Bottleneck
#    We restart the scan from every left index, which repeats work on heavily
#    overlapping subarrays.
#    We only need the longest valid window where the number of distinct fruit
#    types is at most 2.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window with a frequency hash.
#    Expand right and add fruits[right] to the count hash.
#    If the number of distinct fruit types becomes greater than 2, shrink from
#    the left until the window is valid again.
#
#    Window invariant:
#    - count.length <= 2
#
#    After restoring validity, update the maximum window length.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# fruits = [1, 2, 3, 2, 2]
#
# right = 0
# count = {1 => 1}
# valid, best = 1
#
# right = 1
# count = {1 => 1, 2 => 1}
# valid, best = 2
#
# right = 2
# count = {1 => 1, 2 => 1, 3 => 1}
# invalid because there are 3 types
# shrink from the left:
# - remove 1 at index 0
# count = {2 => 1, 3 => 1}
# valid again
#
# right = 3
# count = {2 => 2, 3 => 1}
# valid, best = 3
#
# right = 4
# count = {2 => 3, 3 => 1}
# valid, best = 4
#
# Final answer = 4
#
# Edge Cases:
# - fewer than 2 distinct fruit types -> whole array is valid
# - single tree -> answer is 1
# - all fruit types different -> best window length is 2

def total_fruit_true_brute_force(fruits)
  max_length = 0

  (0...fruits.length).each do |left|
    count = Hash.new(0)

    (left...fruits.length).each do |right|
      count[fruits[right]] += 1
      break if count.length > 2

      max_length = [max_length, right - left + 1].max
    end
  end

  max_length
end

def total_fruit(fruits)
  left = 0
  count = Hash.new(0)
  max_length = 0

  fruits.each_with_index do |fruit, right|
    count[fruit] += 1
    left = shrink_fruit_window(fruits, count, left) if count.length > 2
    max_length = [max_length, right - left + 1].max
  end

  max_length
end

def shrink_fruit_window(fruits, count, left)
  while count.length > 2
    count[fruits[left]] -= 1
    count.delete(fruits[left]) if count[fruits[left]].zero?
    left += 1
  end

  left
end

if __FILE__ == $PROGRAM_NAME
  fruits = [1, 2, 3, 2, 2]

  puts "True brute force: #{total_fruit_true_brute_force(fruits)}"
  puts "Optimized:        #{total_fruit(fruits)}"
end
