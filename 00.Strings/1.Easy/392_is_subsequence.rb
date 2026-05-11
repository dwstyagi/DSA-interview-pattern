# frozen_string_literal: true

# LeetCode 392: Is Subsequence
#
# Problem:
# Given two strings s and t, return true if s is a subsequence of t,
# or false otherwise. A subsequence is formed by deleting some characters
# (can be zero) from t without changing the relative order.
#
# Examples:
#   Input:  s = "abc", t = "ahbgdc"
#   Output: true
#   Why:    a..b..c can be found in order in "ahbgdc" (skip h, g, d) -> true.
#
#   Input:  s = "axc", t = "ahbgdc"
#   Output: false
#   Why:    After matching 'a', we need 'x' next but only h,b,g,d,c remain — 'x' not found.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all subsequences of t and check if any equals s.
#
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential blowup is completely unnecessary; we just need a pointer check.
#
# 3. Optimized Accepted Approach
#    Two pointers: one for s, one for t.
#    Advance the s pointer only when characters match.
#    If the s pointer reaches the end, s is a subsequence.
#
#    Time Complexity: O(n) where n = length of t
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "ace", t = "abcde"
# si=0('a'), ti=0('a') → match → si=1
# si=1('c'), ti=1('b') → no match → ti=2
# si=1('c'), ti=2('c') → match → si=2
# si=2('e'), ti=3('d') → no match → ti=4
# si=2('e'), ti=4('e') → match → si=3
# si == s.length → true
#
# Edge Cases:
# - Empty s              -> true (empty is subsequence of anything)
# - s longer than t      -> false
# - All chars the same   -> depends on counts

def subsequence_brute?(s, t)
  # Recursively check: if first chars match, advance both; else advance t only
  return true if s.empty?
  return false if t.empty?

  if s[0] == t[0]
    subsequence_brute?(s[1..], t[1..])
  else
    subsequence_brute?(s, t[1..])
  end
end

def subsequence?(s, t)
  si = 0 # pointer into s
  ti = 0 # pointer into t

  while si < s.length && ti < t.length
    # Advance s pointer only on a match
    si += 1 if s[si] == t[ti]
    ti += 1
  end

  # If we consumed all of s, it's a valid subsequence
  si == s.length
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{subsequence_brute?('ace', 'abcde')}" # true
  puts "Optimized:   #{subsequence?('ace', 'abcde')}"       # true
  puts "Brute force: #{subsequence_brute?('axc', 'ahbgdc')}" # false
  puts "Optimized:   #{subsequence?('axc', 'ahbgdc')}"       # false
end
