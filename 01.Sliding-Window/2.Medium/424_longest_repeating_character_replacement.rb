# frozen_string_literal: true

# LeetCode 424: Longest Repeating Character Replacement
#
# Problem:
# Given a string s and an integer k, return the length of the longest
# substring that can be turned into a string of repeating characters after
# performing at most k replacements.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every substring.
#    For each substring, count the frequency of each character and find the
#    highest frequency max_freq.
#    The substring is valid if:
#      substring_length - max_freq <= k
#    If valid, update the maximum length.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
#    Why O(n^2)?
#    - O(n^2) possible substrings
#    - frequency counts are maintained incrementally while expanding right
#
# 2. Bottleneck
#    Adjacent substrings overlap heavily, so restarting from each left index
#    repeats work.
#    We do not need every valid substring. We only need the longest window
#    such that the number of required replacements stays within k.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window.
#    Track character counts in the current window and maintain max_freq,
#    the highest frequency of any character in the window logic.
#
#    A window is valid if:
#      window_length - max_freq <= k
#
#    If the window becomes invalid, move left forward until it becomes valid.
#
#    Important trick:
#    - when shrinking the window, we do not decrease max_freq
#    - keeping max_freq stale is still correct for the final answer and keeps
#      the solution O(n)
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "AABABBA"
# k = 1
#
# right = 0, window = "A"
# counts: A:1, max_freq = 1
# replacements needed = 1 - 1 = 0, valid
# best = 1
#
# right = 1, window = "AA"
# counts: A:2, max_freq = 2
# replacements needed = 2 - 2 = 0, valid
# best = 2
#
# right = 2, window = "AAB"
# counts: A:2, B:1, max_freq = 2
# replacements needed = 3 - 2 = 1, valid
# best = 3
#
# right = 3, window = "AABA"
# counts: A:3, B:1, max_freq = 3
# replacements needed = 4 - 3 = 1, valid
# best = 4
#
# right = 4, window = "AABAB"
# counts: A:3, B:2, max_freq = 3
# replacements needed = 5 - 3 = 2, invalid
# shrink from the left until valid again
#
# Final answer = 4
#
# Edge Cases:
# - k = 0 -> longest existing run of one repeated character
# - all same characters -> answer is s.length
# - all different characters -> answer depends on k
# - single-character string -> answer is 1

def character_replacement_true_brute_force(text, replacements)
  max_length = 0

  (0...text.length).each do |left|
    max_length = [max_length, brute_force_replacement_window(text, left, replacements)].max
  end

  max_length
end

def character_replacement(text, replacements)
  count = Array.new(26, 0)
  left = max_freq = max_length = 0
  window_state = { text: text, count: count }

  text.each_char.with_index do |char, right|
    max_freq = add_uppercase_char(count, char, max_freq)
    left = shrink_replacement_window(window_state, left, right, max_freq, replacements)
    max_length = [max_length, right - left + 1].max
  end

  max_length
end

def brute_force_replacement_window(text, left, replacements)
  count = Array.new(26, 0)
  max_freq = best = 0

  (left...text.length).each do |right|
    max_freq = add_uppercase_char(count, text[right], max_freq)
    length = right - left + 1
    best = [best, length].max if valid_replacement_window?(length, max_freq, replacements)
  end

  best
end

def add_uppercase_char(count, char, max_freq)
  index = uppercase_index(char)
  count[index] += 1
  [max_freq, count[index]].max
end

def shrink_replacement_window(window_state, left, right, max_freq, replacements)
  text = window_state[:text]
  count = window_state[:count]

  until valid_replacement_window?(right - left + 1, max_freq, replacements)
    count[uppercase_index(text[left])] -= 1
    left += 1
  end

  left
end

def valid_replacement_window?(length, max_freq, replacements)
  length - max_freq <= replacements
end

def uppercase_index(char)
  char.ord - 'A'.ord
end

if __FILE__ == $PROGRAM_NAME
  s = 'AABABBA'
  k = 1

  puts "True brute force: #{character_replacement_true_brute_force(s, k)}"
  puts "Optimized:        #{character_replacement(s, k)}"
end
