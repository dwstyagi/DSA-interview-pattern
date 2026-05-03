# frozen_string_literal: true

# LeetCode 392: Is Subsequence
#
# Problem:
# Given strings s and t, return true if s is a subsequence of t.
# A subsequence maintains relative order but characters need not be adjacent.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsequences of t of length s.length; check if any equals s.
#    Time Complexity: O(C(n,m) * m)
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    Two-pointer: match characters of s in t greedily.
#
# 3. Optimized Accepted Approach
#    Two pointers: i for s, j for t. When s[i]==t[j], advance i. Always advance j.
#    Return i == s.length.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="ace", t="abcde"
# j=0(a)==s[0](a): i=1; j=1(b): no match; j=2(c)==s[1](c): i=2; j=3(d): no; j=4(e)==s[2](e): i=3
# i==s.length=3 -> true
#
# Edge Cases:
# - Empty s: true (empty string is subsequence of anything)
# - s longer than t: false

def is_subsequence_brute?(s, t)
  i = 0
  t.each_char do |c|
    i += 1 if i < s.length && c == s[i]
  end
  i == s.length
end

# optimized: same two-pointer (already optimal)
def is_subsequence?(s, t)
  si = 0
  ti = 0
  while si < s.length && ti < t.length
    si += 1 if s[si] == t[ti]
    ti += 1
  end
  si == s.length
end

if __FILE__ == $PROGRAM_NAME
  puts is_subsequence_brute?('ace', 'abcde')  # true
  puts is_subsequence?('axc', 'ahbgdc')       # false
end
