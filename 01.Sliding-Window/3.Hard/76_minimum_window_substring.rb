# frozen_string_literal: true

# LeetCode 76: Minimum Window Substring
#
# Problem:
# Given two strings text and pattern, return the minimum window substring of
# text such that every character in pattern, including duplicates, is covered
# by the window. If no such window exists, return an empty string.
#
# Examples:
#   Input:  s = "ADOBECODEBANC", t = "ABC"
#   Output: "BANC"
#   Why:    "BANC" (length 4) is the smallest window containing A, B, C.
#           "ADOBEC" also works but is longer (6 chars).
#
#   Input:  s = "a", t = "b"
#   Output: ""
#   Why:    'b' never appears in s, so no valid window exists -> return "".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every starting index and expand every ending index.
#    For each window, maintain a frequency map and check whether the window
#    covers all required frequencies from pattern.
#    If valid, compare it with the best answer seen so far.
#
#    Time Complexity: O(n^2 * m) in a straightforward implementation
#    Space Complexity: O(m)
#
#    Why expensive?
#    - O(n^2) possible substrings
#    - validating a window may require checking all characters needed from
#      pattern
#
# 2. Bottleneck
#    We examine far too many overlapping substrings and repeatedly recheck
#    whether they satisfy the requirement.
#    We do not need every valid window. We only need the smallest one.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window with need/have counting.
#    Build:
#    - need: frequency map of pattern
#    - window: frequency map of the current window in text
#
#    Track:
#    - required = number of distinct characters needed
#    - formed = number of distinct characters currently satisfied
#
#    A window is valid when:
#      formed == required
#
#    Expand right until the window becomes valid.
#    Then shrink left as much as possible while keeping it valid.
#    Record the smallest valid window seen.
#
#    Time Complexity: O(n)
#    Space Complexity: O(m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "ADOBECODEBANC"
# pattern = "ABC"
#
# need = {A:1, B:1, C:1}
#
# expand until window "ADOBEC"
# window satisfies A, B, C
# formed == required, so try shrinking
#
# keep expanding and shrinking
# eventually reach window "BANC"
# it still satisfies all requirements and is smaller than previous answers
#
# Final answer = "BANC"
#
# Edge Cases:
# - pattern longer than text -> return ""
# - duplicates in pattern must be matched by frequency
# - if no valid window exists -> return ""

def min_window_true_brute_force(text, pattern)
  best = ''
  target_count = Hash.new(0)
  pattern.each_char { |char| target_count[char] += 1 }

  (0...text.length).each do |left|
    window_count = Hash.new(0)

    (left...text.length).each do |right|
      window_count[text[right]] += 1

      valid = target_count.all? do |char, needed_frequency|
        window_count[char] >= needed_frequency
      end

      next unless valid

      candidate = text[left..right]
      best = candidate if best.empty? || candidate.length < best.length
    end
  end

  best
end

def min_window(text, pattern)
  return '' if pattern.length > text.length

  need = Hash.new(0)
  pattern.each_char { |char| need[char] += 1 }

  window = Hash.new(0)
  required = need.length
  formed = 0
  left = 0
  best_start = 0
  best_length = Float::INFINITY

  text.each_char.with_index do |char, right|
    window[char] += 1
    formed += 1 if need.key?(char) && window[char] == need[char]

    while formed == required
      window_length = right - left + 1
      if window_length < best_length
        best_start = left
        best_length = window_length
      end

      left_char = text[left]
      window[left_char] -= 1
      formed -= 1 if need.key?(left_char) && window[left_char] < need[left_char]
      left += 1
    end
  end

  best_length == Float::INFINITY ? '' : text[best_start, best_length]
end

if __FILE__ == $PROGRAM_NAME
  text = 'ADOBECODEBANC'
  pattern = 'ABC'

  puts "True brute force: #{min_window_true_brute_force(text, pattern)}"
  puts "Optimized:        #{min_window(text, pattern)}"
end
