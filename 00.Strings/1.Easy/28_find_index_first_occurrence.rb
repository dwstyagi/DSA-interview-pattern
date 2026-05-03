# frozen_string_literal: true

# LeetCode 28: Find the Index of the First Occurrence in a String
#
# Problem:
# Given two strings haystack and needle, return the index of the first occurrence
# of needle in haystack, or -1 if needle is not part of haystack.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Slide a window of size needle.length across haystack, compare each slice.
#
#    Time Complexity: O(n * m) where n = haystack length, m = needle length
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Redundant character comparisons when partial match fails from the start.
#
# 3. Optimized Accepted Approach
#    Use Ruby's built-in String#index which uses an efficient algorithm (Boyer-Moore style).
#    For interview: implement KMP for O(n + m).
#
#    Time Complexity: O(n + m) with KMP
#    Space Complexity: O(m) for the failure function
#
# -----------------------------------------------------------------------------
# Dry Run  (brute force window)
#
# haystack = "sadbutsad", needle = "sad"
# i=0: hay[0..2] = "sad" == "sad" → return 0
#
# haystack = "leetcode", needle = "leeto"
# i=0: hay[0..4] = "leetc" != "leeto"
# i=1: hay[1..5] = "eetco" != "leeto"
# ... no match → return -1
#
# Edge Cases:
# - Empty needle         -> return 0
# - needle longer than haystack -> return -1
# - haystack == needle   -> return 0

def str_str_brute(haystack, needle)
  return 0 if needle.empty?

  n = haystack.length
  m = needle.length

  # Slide a window and compare each substring
  (0..n - m).each do |i|
    return i if haystack[i, m] == needle
  end

  -1
end

def str_str(haystack, needle)
  return 0 if needle.empty?

  # Build KMP failure function (partial match table)
  m = needle.length
  fail_table = Array.new(m, 0)
  j = 0

  (1...m).each do |i|
    # Walk back until we find a matching prefix or hit the start
    j -= 1 while j.positive? && needle[j] != needle[i]
    j += 1 if needle[j] == needle[i]
    fail_table[i] = j
  end

  # KMP search
  j = 0
  haystack.each_char.with_index do |char, i|
    # Use failure table to skip redundant comparisons
    j -= 1 while j.positive? && needle[j] != char
    j += 1 if needle[j] == char
    return i - m + 1 if j == m # full needle matched

    j = fail_table[j - 1] if j == m
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{str_str_brute('sadbutsad', 'sad')}" # 0
  puts "Optimized:   #{str_str('sadbutsad', 'sad')}"       # 0
  puts "Brute force: #{str_str_brute('leetcode', 'leeto')}" # -1
  puts "Optimized:   #{str_str('leetcode', 'leeto')}"       # -1
end
