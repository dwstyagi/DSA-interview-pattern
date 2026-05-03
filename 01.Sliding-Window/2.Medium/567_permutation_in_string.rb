# frozen_string_literal: true

# LeetCode 567: Permutation in String
#
# Problem:
# Given two strings s1 and s2, return true if s2 contains a substring
# that is a permutation of s1, or false otherwise.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate every substring of s2 with length s1.length.
#    For each substring, rebuild a fresh frequency count and compare it with
#    the frequency count of s1.
#
#    Time Complexity: O(n * m)
#    Space Complexity: O(1)
#
#    Why O(n * m)?
#    - O(n - m + 1) windows in s2
#    - O(m) work to rebuild the count for each window
#
#    Here:
#    - n = s2.length
#    - m = s1.length
#
# 2. Bottleneck
#    Adjacent windows overlap heavily, so rebuilding frequency counts from
#    scratch repeats most of the work.
#    When the window moves by one step:
#    - one character leaves
#    - one character enters
#    All other characters stay the same.
#
# 3. Optimized Accepted Approach
#    Use a fixed-size sliding window of length s1.length.
#    Track:
#    - need: frequency of characters in s1
#    - window: frequency of characters in the current window of s2
#
#    Build the first window once, compare it with need, then slide:
#    - add the incoming character
#    - remove the outgoing character
#    - compare again
#
#    Since the alphabet is lowercase English letters, use arrays of size 26
#    instead of hashes.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s1 = "ab"
# s2 = "eidbaooo"
#
# need = counts of "ab" => a:1, b:1
#
# First window = "ei"
# window = e:1, i:1
# not a match
#
# Slide to "id"
# remove 'e', add 'd'
# not a match
#
# Slide to "db"
# remove 'i', add 'b'
# not a match
#
# Slide to "ba"
# remove 'd', add 'a'
# window = a:1, b:1
# match found
#
# Final answer = true
#
# Edge Cases:
# - s1.length > s2.length -> false
# - repeated characters in s1 must be matched with the same frequency
# - a single-character s1 still works with the same logic

def check_inclusion_true_brute_force?(pattern, text)
  return false if pattern.length > text.length

  needed_counts = lowercase_counts(pattern)
  window_size = pattern.length

  (0..(text.length - window_size)).any? do |left|
    lowercase_counts(text[left, window_size]) == needed_counts
  end
end

def check_inclusion?(pattern, text)
  return false if pattern.length > text.length

  window_size = pattern.length
  needed_counts = lowercase_counts(pattern)
  window_counts = lowercase_counts(text[0, window_size])

  return true if window_counts == needed_counts

  inclusion_window_match?(text, window_size, needed_counts, window_counts)
end

def inclusion_window_match?(text, window_size, needed_counts, window_counts)
  (window_size...text.length).each do |right|
    update_lowercase_window_counts(window_counts, text[right], text[right - window_size])
    return true if window_counts == needed_counts
  end

  false
end

def lowercase_counts(text)
  count = Array.new(26, 0)
  text.each_char { |char| count[lowercase_index(char)] += 1 }
  count
end

def update_lowercase_window_counts(window_counts, incoming_char, outgoing_char)
  window_counts[lowercase_index(incoming_char)] += 1
  window_counts[lowercase_index(outgoing_char)] -= 1
end

def lowercase_index(char)
  char.ord - 'a'.ord
end

if __FILE__ == $PROGRAM_NAME
  s1 = 'ab'
  s2 = 'eidbaooo'

  puts "True brute force: #{check_inclusion_true_brute_force?(s1, s2)}"
  puts "Optimized:        #{check_inclusion?(s1, s2)}"
end
