# frozen_string_literal: true

# LeetCode 3: Longest Substring Without Repeating Characters
#
# Problem:
# Given a string text, return the length of the longest substring without
# repeating characters.
#
# Examples:
#   Input:  s = "abcabcbb"
#   Output: 3
#   Why:    "abc" is the longest window with all unique chars; when 'a' repeats, window shrinks.
#
#   Input:  s = "pwwkew"
#   Output: 3
#   Why:    "wke" is the longest unique substring (length 3). "pw" hits duplicate 'w' at index 2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every substring.
#    For each substring, check whether all characters are unique.
#    If valid, update the best length.
#
#    Time Complexity: O(n^3) in the straightforward version
#    Space Complexity: O(n)
#
#    Why O(n^3)?
#    - O(n^2) substrings
#    - O(n) work to check uniqueness for each substring
#
# 2. Bottleneck
#    Consecutive substrings overlap heavily, but brute force rebuilds the
#    uniqueness check from scratch every time.
#    We only need the longest valid window where every character appears once.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window with a frequency hash.
#    Expand right one character at a time.
#    If a character count becomes greater than 1, shrink from the left until
#    the window is valid again.
#
#    Window invariant:
#    - every character count in the window is at most 1
#
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#    Here k is the number of distinct characters in the current window.
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "abcabcbb"
#
# right = 0 -> window "a", valid, best = 1
# right = 1 -> window "ab", valid, best = 2
# right = 2 -> window "abc", valid, best = 3
# right = 3 -> window "abca", 'a' repeats
# shrink from the left until window becomes "bca"
# best stays 3
#
# continue scanning
# no later window beats length 3
#
# Final answer = 3
#
# Edge Cases:
# - empty string -> return 0
# - all same characters -> return 1
# - all unique characters -> return text.length

def length_of_longest_substring_true_brute_force(text)
  max_length = 0

  (0...text.length).each do |left|
    (left...text.length).each do |right|
      substring = text[left..right]
      next unless substring.chars.uniq.length == substring.length

      max_length = [max_length, substring.length].max
    end
  end

  max_length
end

def length_of_longest_substring(text)
  left = 0
  count = Hash.new(0)
  max_length = 0

  text.each_char.with_index do |char, right|
    count[char] += 1

    while count[char] > 1
      count[text[left]] -= 1
      left += 1
    end

    max_length = [max_length, right - left + 1].max
  end

  max_length
end

if __FILE__ == $PROGRAM_NAME
  text = 'abcabcbb'

  puts "True brute force: #{length_of_longest_substring_true_brute_force(text)}"
  puts "Optimized:        #{length_of_longest_substring(text)}"
end

# -- The optimized approach is significantly faster than the true brute force, especially for longer strings.