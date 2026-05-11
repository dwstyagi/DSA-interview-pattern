# frozen_string_literal: true

# LeetCode 3: Longest Substring Without Repeating Characters
#
# Problem:
# Given a string s, find the length of the longest substring without repeating characters.
#
# Examples:
#   Input:  s = "abcabcbb"
#   Output: 3
#   Why:    "abc" is the longest substring with all unique chars (length 3).
#           When we hit the second 'a', the window shrinks.
#
#   Input:  s = "pwwkew"
#   Output: 3
#   Why:    "wke" is the longest unique substring (length 3). "pw" then hits duplicate 'w'.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every substring for uniqueness. O(n^3) with set check per substring.
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(min(n, m)) — m = alphabet size
#
# 2. Bottleneck
#    Rechecking the same characters when the window slides is wasteful.
#
# 3. Optimized Accepted Approach
#    Sliding window with a hash map tracking the last-seen index of each character.
#    When a duplicate is found, jump left pointer past the previous occurrence.
#
#    Time Complexity: O(n)
#    Space Complexity: O(min(n, m))
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "abcabcbb"
# left=0, map={}
# right=0('a'): map={a:0}, len=1
# right=1('b'): map={a:0,b:1}, len=2
# right=2('c'): map={a:0,b:1,c:2}, len=3
# right=3('a'): a seen at 0, left=max(0,0+1)=1, map={a:3,b:1,c:2}, len=3
# right=4('b'): b seen at 1, left=max(1,1+1)=2, map={a:3,b:4,c:2}, len=3
# ...
# max = 3
#
# Edge Cases:
# - Empty string   -> 0
# - All unique     -> n
# - All same char  -> 1

def length_of_longest_substring_brute(s)
  max_len = 0

  (0...s.length).each do |i|
    seen = {}
    (i...s.length).each do |j|
      break if seen[s[j]]

      seen[s[j]] = true
      max_len = [max_len, j - i + 1].max
    end
  end

  max_len
end

def length_of_longest_substring(s)
  last_seen = {} # char → last seen index
  max_len = 0
  left = 0

  s.each_char.with_index do |char, right|
    # If char was seen inside the current window, shrink window from left
    if last_seen[char] && last_seen[char] >= left
      left = last_seen[char] + 1
    end

    # Record the latest index of this character
    last_seen[char] = right
    max_len = [max_len, right - left + 1].max
  end

  max_len
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{length_of_longest_substring_brute('abcabcbb')}" # 3
  puts "Optimized:   #{length_of_longest_substring('abcabcbb')}"       # 3
  puts "Brute force: #{length_of_longest_substring_brute('bbbbb')}"    # 1
  puts "Optimized:   #{length_of_longest_substring('bbbbb')}"          # 1
end
