# frozen_string_literal: true

# LeetCode 3: Longest Substring Without Repeating Characters
#
# Problem:
# Given a string s, find the length of the longest substring that contains
# no repeating characters.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every possible substring (left, right).
#    For each, verify all characters are unique using uniq.
#    Track the maximum length seen.
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(n)
#
#    Why O(n^3)?
#    - O(n^2) substrings
#    - O(n) to check uniqueness per substring
#
# 2. Bottleneck
#    We recheck characters from scratch for every substring.
#    When we hit a duplicate at right, we don't need to restart from left + 1.
#    We only need to shrink the window until the duplicate is gone.
#
# 3. Optimized Accepted Approach
#    Use a sliding window with a hash tracking character counts.
#    Expand right one step at a time.
#    When s[right] has count > 1, shrink from left until count drops back to 1.
#    Track the max window size throughout.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "abcab"
#
# j=0, hash={a:1}, i=0, result=1
# j=1, hash={a:1,b:1}, i=0, result=2
# j=2, hash={a:1,b:1,c:1}, i=0, result=3
# j=3, hash={a:2,b:1,c:1} -> shrink: hash={b:1,c:1,a:1}, i=1, result=3
# j=4, hash={b:2,c:1,a:1} -> shrink: hash={c:1,a:1,b:1}, i=2, result=3
#
# Final answer = 3
#
# Edge Cases:
# - Empty string -> return 0
# - All unique characters -> return s.length
# - All same characters -> return 1

def length_of_longest_substring_brute(text)
  max_length = 0

  (0...text.length).each do |left|
    (left...text.length).each do |right|
      window = text[left..right].chars
      max_length = [max_length, right - left + 1].max if window.uniq.length == window.length
    end
  end

  max_length
end

def length_of_longest_substring(text)
  counts = Hash.new(0)
  left = 0
  best_length = 0

  text.each_char.with_index do |char, right|
    counts[char] += 1
    left = shrink_duplicate_window(text, counts, left, char)
    best_length = [best_length, right - left + 1].max
  end

  best_length
end

def shrink_duplicate_window(text, counts, left, char)
  while counts[char] > 1
    counts[text[left]] -= 1
    left += 1
  end
  left
end

if __FILE__ == $PROGRAM_NAME
  s = 'abcab'

  puts "Brute force: #{length_of_longest_substring_brute(s)}"
  puts "Optimized:   #{length_of_longest_substring(s)}"
end
