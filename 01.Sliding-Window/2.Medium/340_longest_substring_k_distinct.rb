# frozen_string_literal: true

# LeetCode 340: Longest Substring with At Most K Distinct Characters
#
# Problem:
# Given a string text and an integer max_distinct, return the length of the
# longest substring that contains at most max_distinct distinct characters.
#
# Examples:
#   Input:  s = "eceba", k = 2
#   Output: 3
#   Why:    "ece" has 2 distinct chars (e,c) and length 3 — longest valid substring.
#
#   Input:  s = "aa", k = 1
#   Output: 2
#   Why:    Whole string "aa" has only 1 distinct char <= k=1 -> length 2.
#
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every possible substring.
#    Track character counts using a hash.
#    If the number of distinct characters stays at most max_distinct, update
#    the best length.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Brute force rebuilds the hash from scratch for each starting index.
#    Consecutive windows overlap heavily, so that repeated work is unnecessary.
#
# 3. Optimized Accepted Approach
#    Use a variable-size sliding window with a frequency hash.
#    Expand right one step at a time.
#    If the number of distinct characters becomes greater than max_distinct,
#    shrink from the left until the window becomes valid again.
#
#    Window invariant:
#    - count.length <= max_distinct
#
#    Time Complexity: O(n)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# text = "eceba"
# max_distinct = 2
#
# right = 0 -> window "e", distinct = 1, best = 1
# right = 1 -> window "ec", distinct = 2, best = 2
# right = 2 -> window "ece", distinct = 2, best = 3
# right = 3 -> window "eceb", distinct = 3, invalid
# shrink from left until window becomes "eb"
# best stays 3
#
# right = 4 -> window "eba", distinct = 3, invalid
# shrink until window becomes "ba"
#
# Final answer = 3
#
# Edge Cases:
# - max_distinct = 0 -> return 0
# - empty string -> return 0
# - max_distinct >= text.length -> return text.length

def length_of_longest_substring_k_distinct_true_brute_force(text, max_distinct)
  return 0 if max_distinct.zero?

  best_length = 0

  (0...text.length).each do |left|
    count = Hash.new(0)

    (left...text.length).each do |right|
      count[text[right]] += 1
      break if count.length > max_distinct

      best_length = [best_length, right - left + 1].max
    end
  end

  best_length
end

def length_of_longest_substring_k_distinct(text, max_distinct)
  return 0 if max_distinct.zero?

  count = Hash.new(0)
  left = 0
  best_length = 0

  text.each_char.with_index do |char, right|
    count[char] += 1

    while count.length > max_distinct
      left_char = text[left]
      count[left_char] -= 1
      count.delete(left_char) if count[left_char].zero?
      left += 1
    end

    best_length = [best_length, right - left + 1].max
  end

  best_length
end

if __FILE__ == $PROGRAM_NAME
  text = 'eceba'
  max_distinct = 2

  puts "True brute force: #{length_of_longest_substring_k_distinct_true_brute_force(text, max_distinct)}"
  puts "Optimized:        #{length_of_longest_substring_k_distinct(text, max_distinct)}"
end
