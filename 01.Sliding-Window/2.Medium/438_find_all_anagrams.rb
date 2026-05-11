# frozen_string_literal: true

# LeetCode 438: Find All Anagrams in a String
#
# Problem:
# Given two strings text and pattern, return an array of all starting indices
# of pattern's anagrams in text. An anagram uses the same characters with the
# same frequencies, just in any order.
#
# Example:
# text = "cbaebabacd"
# pattern = "abc"
# answer = [0, 6]
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Slide a window of size pattern.length across text.
#    For each window, build its character count from scratch and compare it
#    with the character count of pattern.
#
#    Time Complexity: O(n * k)
#    Space Complexity: O(1)
#
#    Here:
#    - n = text.length
#    - k = pattern.length
#
# 2. Bottleneck
#    Consecutive windows overlap heavily, but brute force rebuilds the whole
#    count from scratch every time.
#    When the window moves by one step, only one character leaves and one
#    character enters.
#
# 3. Optimized Accepted Approach
#    Use a fixed-size sliding window of length pattern.length.
#    Track:
#    - pattern_count: frequency of characters in pattern
#    - window_count: frequency of characters in the current window of text
#
#    Build the first window once, compare, then slide:
#    - add the incoming character
#    - remove the outgoing character
#    - compare again
#
#    Since the problem uses lowercase English letters, arrays of size 26 are a
#    clean frequency structure.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "cbaebabacd"
# pattern = "abc"
#
# pattern_count = counts of "abc"
#
# first window = "cba"
# window_count matches pattern_count
# result = [0]
#
# slide through:
# "bae" -> not a match
# "aeb" -> not a match
# "eba" -> not a match
# "bab" -> not a match
# "aba" -> not a match
# "bac" -> match
# result = [0, 6]
#
# Final answer = [0, 6]
#
# Edge Cases:
# - pattern longer than text -> return []
# - no matching window -> return []
# - repeated characters in pattern must match by frequency

def find_anagrams_true_brute_force(text, pattern)
  return [] if pattern.length > text.length

  result = []
  pattern_count = lowercase_count(pattern)
  window_size = pattern.length

  (0..(text.length - window_size)).each do |left|
    result << left if lowercase_count(text[left, window_size]) == pattern_count
  end

  result
end

def find_anagrams(text, pattern)
  window_size = pattern.length
  return [] if window_size.zero? || window_size > text.length

  result = []
  pattern_count = lowercase_count(pattern)
  window_count = lowercase_count(text[0, window_size])

  result << 0 if window_count == pattern_count

  (window_size...text.length).each do |right|
    window_count[lowercase_index(text[right])] += 1
    window_count[lowercase_index(text[right - window_size])] -= 1
    result << right - window_size + 1 if window_count == pattern_count
  end

  result
end

def lowercase_count(text)
  count = Array.new(26, 0)
  text.each_char { |char| count[lowercase_index(char)] += 1 }
  count
end

def lowercase_index(char)
  char.ord - 'a'.ord
end

if __FILE__ == $PROGRAM_NAME
  text = 'cbaebabacd'
  pattern = 'abc'

  puts "True brute force: #{find_anagrams_true_brute_force(text, pattern)}"
  puts "Optimized:        #{find_anagrams(text, pattern)}"
end
