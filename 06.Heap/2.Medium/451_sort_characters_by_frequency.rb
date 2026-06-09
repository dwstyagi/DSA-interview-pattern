# frozen_string_literal: true

# LeetCode 451: Sort Characters By Frequency
#
# Problem:
# Given a string s, sort it in decreasing order based on the frequency of
# characters. Return any valid sorted string.
#
# Important:
# - Characters with the same frequency can appear in any order.
# - The output must contain the same characters as the input.
# - Only the order changes.
#
# Examples:
#   Input:  s = "tree"
#   Output: "eert"
#   Why:    "e" appears 2 times, "t" and "r" appear 1 time each.
#           "eetr" is also valid.
#
#   Input:  s = "cccaaa"
#   Output: "cccaaa"
#   Why:    "c" appears 3 times and "a" appears 3 times.
#           "aaaccc" is also valid.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Count frequency of each character.
#    Sort unique characters by frequency in descending order.
#    Build the result by repeating each character by its frequency.
#    Time Complexity: O(n + m log m)
#    Space Complexity: O(n + m)
#
# 2. Bottleneck
#    Sorting all unique characters costs O(m log m).
#    Here m is the number of unique characters.
#
# 3. Optimized Max-Heap Approach
#    Count frequency of each character.
#    Push [frequency, character] into MaxHeap.
#    Pop the highest frequency character each time.
#    Append character * frequency to result.
#    Time Complexity: O(n + m log m)
#    Space Complexity: O(n + m)
#
# -----------------------------------------------------------------------------
# Complexity Notes
#
# n = total characters in string
# m = unique characters in string
#
# Example:
# s = "tree"
#
# n = 4
# m = 3 because unique characters are "t", "r", "e"
#
# Counting frequency visits every character:
# O(n)
#
# Sorting or heap operations happen only on unique characters:
# O(m log m)
#
# Building the final string appends exactly n characters:
# O(n)
#
# Final time:
# O(n + m log m)
#
# Worst case:
# If every character is unique, m = n.
# Then time becomes O(n log n).
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "tree"
#
# Frequency map:
# "t" => 1
# "r" => 1
# "e" => 2
#
# MaxHeap stores:
# [1, "t"]
# [1, "r"]
# [2, "e"]
#
# Pop highest:
# [2, "e"] -> result = "ee"
#
# Pop next:
# [1, "t"] -> result = "eet"
#
# Pop next:
# [1, "r"] -> result = "eetr"
#
# Valid answer:
# "eetr"
#
# "eert" is also valid because "t" and "r" have the same frequency.
#
# Edge Cases:
# - empty string
# - one character
# - all characters same
# - all characters unique
# - uppercase and lowercase are different characters

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Count frequency of each character
# - Sort characters by frequency descending
# - Build result by repeating each character count times
#
# Time: O(n + m log m)
# Worst Case Time: O(n log n)
# Space: O(n + m)
def frequency_sort_brute_force(s)
  frequency = Hash.new(0)

  # Count every character.
  #
  # Example:
  # s = "tree"
  #
  # frequency becomes:
  # {
  #   "t" => 1,
  #   "r" => 1,
  #   "e" => 2
  # }
  s.each_char do |char|
    frequency[char] += 1
  end

  # Sort only unique characters by count descending.
  #
  # frequency.sort_by { |_char, count| -count }
  #
  # Example result:
  # [
  #   ["e", 2],
  #   ["t", 1],
  #   ["r", 1]
  # ]
  sorted_chars = frequency.sort_by do |_char, count|
    -count
  end

  result = +''

  # Add each character count times.
  #
  # ["e", 2] -> "ee"
  # ["t", 1] -> "t"
  # ["r", 1] -> "r"
  sorted_chars.each do |char, count|
    result << (char * count)
  end

  result
end

# -----------------------------
# OPTIMIZED MAX-HEAP SOLUTION
# -----------------------------
# Idea:
# - Count frequency of each character
# - Push [count, char] into MaxHeap
# - MaxHeap gives the most frequent character first
# - Append char * count to result
#
# Time: O(n + m log m)
# Worst Case Time: O(n log n)
# Space: O(n + m)
require 'algorithms'
def frequency_sort(s)
  frequency = Hash.new(0)

  s.each_char do |char|
    frequency[char] += 1
  end

  max_heap = Containers::MaxHeap.new

  # Push one heap entry per unique character.
  #
  # We push [count, char] because heap compares the first value first.
  #
  # Example:
  # [2, "e"] is greater than [1, "t"]
  frequency.each do |char, count|
    max_heap.push([count, char])
  end

  result = +''

  # Pop most frequent character first.
  until max_heap.empty?
    count, char = max_heap.pop
    result << (char * count)
  end

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{frequency_sort_brute_force("tree")}"
  puts "Opt:   #{frequency_sort("tree")}"

  puts "Brute: #{frequency_sort_brute_force("cccaaa")}"
  puts "Opt:   #{frequency_sort("cccaaa")}"

  puts "Brute: #{frequency_sort_brute_force("Aabb")}"
  puts "Opt:   #{frequency_sort("Aabb")}"
end
