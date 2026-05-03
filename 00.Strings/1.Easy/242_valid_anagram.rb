# frozen_string_literal: true

# LeetCode 242: Valid Anagram
#
# Problem:
# Given two strings s and t, return true if t is an anagram of s, and false otherwise.
# An anagram is a word formed by rearranging the letters of another.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Sort both strings and compare them character by character.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting is O(n log n) but we only need frequency counts — no ordering needed.
#
# 3. Optimized Accepted Approach
#    Build a frequency tally for each string; compare the two tallies.
#    Ruby's Hash#tally gives char -> count in O(n).
#
#    Time Complexity: O(n)
#    Space Complexity: O(1) — at most 26 characters in alphabet
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "anagram", t = "nagaram"
# tally(s) = {a:3, n:1, g:1, r:1, m:1}
# tally(t) = {n:1, a:3, g:1, r:1, m:1}
# Equal → true
#
# s = "rat", t = "car"
# tally(s) = {r:1, a:1, t:1}
# tally(t) = {c:1, a:1, r:1}  — 't' vs 'c' differ → false
#
# Edge Cases:
# - Different lengths              -> false immediately
# - Single character same         -> true
# - Unicode chars (extended case) -> tally still works

def valid_anagram_brute?(s, t)
  # Sort both strings; anagrams produce identical sorted strings
  s.chars.sort == t.chars.sort
end

def valid_anagram?(s, t)
  # Early exit if lengths differ — cannot be anagram
  return false if s.length != t.length

  # Build character frequency maps and compare
  s.chars.tally == t.chars.tally
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{valid_anagram_brute?('anagram', 'nagaram')}" # true
  puts "Optimized:   #{valid_anagram?('anagram', 'nagaram')}"       # true
  puts "Brute force: #{valid_anagram_brute?('rat', 'car')}"         # false
  puts "Optimized:   #{valid_anagram?('rat', 'car')}"               # false
end
