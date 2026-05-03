# frozen_string_literal: true

# LeetCode 678: Valid Parenthesis String
#
# Problem:
# String contains '(', ')', '*'. '*' can be '(', ')' or empty.
# Return true if string can be valid parentheses.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all combinations of replacing '*' with '(', ')' or ''. Check each.
#    Time Complexity: O(3^k * n) where k = number of '*'
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Greedy: track range of possible open bracket counts [lo, hi].
#    '*' can be (, ), or empty -> expands range.
#
# 3. Optimized Accepted Approach
#    Track lo (min possible opens) and hi (max possible opens).
#    '(' -> lo++, hi++. ')' -> lo--, hi--. '*' -> lo--, hi++.
#    If hi < 0: invalid. Clamp lo >= 0. Valid if lo == 0 at end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "(*)"
# '(': lo=1, hi=1
# '*': lo=0, hi=2
# ')': lo=-1->0, hi=1
# lo==0 -> true
#
# Edge Cases:
# - Empty string: true
# - All '*': true (can all be empty)
# - ')' more than available: hi drops below 0 -> false

def check_valid_string_brute?(s)
  check = lambda do |idx, opens|
    return opens == 0 if idx == s.length
    return false if opens < 0
    c = s[idx]
    if c == '('
      check.call(idx + 1, opens + 1)
    elsif c == ')'
      check.call(idx + 1, opens - 1)
    else
      check.call(idx + 1, opens + 1) ||
        check.call(idx + 1, opens - 1) ||
        check.call(idx + 1, opens)
    end
  end
  check.call(0, 0)
end

def check_valid_string?(s)
  lo = 0
  hi = 0
  s.each_char do |c|
    case c
    when '(' then lo += 1; hi += 1
    when ')' then lo -= 1; hi -= 1
    when '*' then lo -= 1; hi += 1
    end
    return false if hi < 0
    lo = 0 if lo < 0
  end
  lo == 0
end

if __FILE__ == $PROGRAM_NAME
  puts check_valid_string_brute?('(*)')   # true
  puts check_valid_string?('(**))')       # true
  puts check_valid_string?('(')           # false
end
