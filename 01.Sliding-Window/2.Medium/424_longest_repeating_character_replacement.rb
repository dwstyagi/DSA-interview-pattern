# frozen_string_literal: true

# LeetCode 424: Longest Repeating Character Replacement
#
# Problem:
# Given a string text and an integer replacements, return the length of the
# longest substring that can be turned into all the same character after
# changing at most replacements characters.
#
# Examples:
#   Input:  s = "AABABBA", k = 1
#   Output: 4
#   Why:    Replace one 'B' in "AABA" or "BABB" to get "AAAA" or "BBBB" -> length 4.
#
#   Input:  s = "ABAB", k = 2
#   Output: 4
#   Why:    Replace 2 'A's to get "BBBB", or 2 'B's to get "AAAA" -> entire string length 4.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every substring.
#    For each substring, count character frequencies and track the highest
#    frequency. The substring is valid if:
#      substring_length - max_frequency <= replacements
#    If valid, update the best length.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Consecutive substrings overlap heavily, but brute force restarts the count
#    work from scratch for each left index.
#    We only need the longest valid window, not every valid substring.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window.
#    Track character counts in the current window and maintain max_frequency,
#    the highest single-character frequency seen in the current window logic.
#
#    A window is valid if:
#      window_length - max_frequency <= replacements
#
#    If the window becomes invalid, shrink from the left until it is valid
#    again.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "AABABBA"
# replacements = 1
#
# right = 0, window = "A"
# counts: A:1, max_frequency = 1
# replacements needed = 1 - 1 = 0, valid
# best = 1
#
# right = 1, window = "AA"
# counts: A:2, max_frequency = 2
# replacements needed = 2 - 2 = 0, valid
# best = 2
#
# right = 2, window = "AAB"
# counts: A:2, B:1, max_frequency = 2
# replacements needed = 3 - 2 = 1, valid
# best = 3
#
# right = 3, window = "AABA"
# counts: A:3, B:1, max_frequency = 3
# replacements needed = 4 - 3 = 1, valid
# best = 4
#
# right = 4, window = "AABAB"
# counts: A:3, B:2, max_frequency = 3
# replacements needed = 5 - 3 = 2, invalid
# shrink from the left until valid again
#
# Final answer = 4
#
# Edge Cases:
# - replacements = 0 -> longest existing run of one repeated character
# - all same characters -> answer is text.length
# - all different characters -> answer depends on replacements
# - single-character string -> answer is 1

def character_replacement_true_brute_force(text, replacements)
  max_length = 0

  (0...text.length).each do |left|
    count = Array.new(26, 0)
    max_frequency = 0

    (left...text.length).each do |right|
      index = uppercase_index(text[right])
      count[index] += 1
      max_frequency = [max_frequency, count[index]].max

      window_length = right - left + 1
      next if window_length - max_frequency > replacements

      max_length = [max_length, window_length].max
    end
  end

  max_length
end

def character_replacement(text, replacements)
  count = Array.new(26, 0)
  left = 0
  max_frequency = 0
  max_length = 0

  text.each_char.with_index do |char, right|
    index = uppercase_index(char)
    count[index] += 1
    max_frequency = [max_frequency, count[index]].max

    while (right - left + 1) - max_frequency > replacements
      count[uppercase_index(text[left])] -= 1
      left += 1
    end

    max_length = [max_length, right - left + 1].max
  end

  max_length
end

def uppercase_index(char)
  char.ord - 'A'.ord
end

if __FILE__ == $PROGRAM_NAME
  text = 'AABABBA'
  replacements = 1

  puts "True brute force: #{character_replacement_true_brute_force(text, replacements)}"
  puts "Optimized:        #{character_replacement(text, replacements)}"
end
