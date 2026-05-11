# frozen_string_literal: true

# LeetCode 5: Longest Palindromic Substring
#
# Problem:
# Given a string s, return the longest palindromic substring in s.
#
# Examples:
#   Input:  s = "babad"
#   Output: "bab"
#   Why:    "bab" is a palindrome (reads same forwards and backwards).
#           "aba" is also valid — both have length 3, either is accepted.
#
#   Input:  s = "cbbd"
#   Output: "bb"
#   Why:    Substrings: "c","b","b","d","cb","bb","bd","cbb","bbd","cbbd"
#           Only "bb" is a palindrome with length > 1, so that's the answer.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every substring s[i..j] for palindrome property. O(n^3).
#
#    Time Complexity: O(n^3)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Repeating palindrome checks. Key insight: palindromes grow from a center.
#
# 3. Optimized Accepted Approach
#    Expand Around Center: for each index, expand outward checking both
#    odd-length (center at i) and even-length (center between i and i+1).
#    Track the longest palindrome found.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "babad"
# i=0: odd expand(0,0)="b", even expand(0,1)=''
# i=1: odd expand(1,1)="aba", even expand(1,2)=''
# i=2: odd expand(2,2)="bab", even expand(2,3)=''
# ...
# Longest = "bab" (or "aba", both valid)
#
# Edge Cases:
# - Single char    -> return that char
# - All same chars -> return whole string
# - No palindrome longer than 1 -> return first char

def longest_palindrome_brute(s)
  best = s[0]

  # Check every possible substring
  (0...s.length).each do |i|
    (i...s.length).each do |j|
      sub = s[i..j]
      best = sub if sub == sub.reverse && sub.length > best.length
    end
  end

  best
end

def longest_palindrome(s)
  best = s[0]

  (0...s.length).each do |i|
    # Odd-length palindrome centered at i
    odd  = expand_around_center(s, i, i)
    # Even-length palindrome centered between i and i+1
    even = expand_around_center(s, i, i + 1)

    # Update best if a longer palindrome was found
    best = odd  if odd.length  > best.length
    best = even if even.length > best.length
  end

  best
end

def expand_around_center(s, left, right)
  # Expand outward while characters match
  left -= 1 while left >= 0 && right < s.length && s[left] == s[right]
  right += 1

  # left+1 and right-1 are the final palindrome boundaries
  s[(left + 1)...right]
end

# dp solution: dp[i][j] = true if s[i..j] is a palindrome
# base: single chars and adjacent equal pairs; fill diagonally by length
# Time: O(n^2), Space: O(n^2)
def longest_palindrome_dp(s)
  n = s.length
  dp = Array.new(n) { Array.new(n, false) }
  best_start = 0
  best_len = 1

  # all single chars are palindromes
  n.times { |i| dp[i][i] = true }

  # check length-2 substrings
  (0...n - 1).each do |i|
    next unless s[i] == s[i + 1]

    dp[i][i + 1] = true
    best_start = i
    best_len = 2
  end

  # check lengths 3..n
  (3..n).each do |len|
    (0..n - len).each do |i|
      j = i + len - 1
      next unless s[i] == s[j] && dp[i + 1][j - 1]

      dp[i][j] = true
      if len > best_len
        best_start = i
        best_len = len
      end
    end
  end

  s[best_start, best_len]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{longest_palindrome_brute('babad')}" # "bab" or "aba"
  puts "DP:          #{longest_palindrome_dp('babad')}"    # "bab" or "aba"
  puts "Optimized:   #{longest_palindrome('babad')}"       # "bab" or "aba"
  puts "Brute force: #{longest_palindrome_brute('cbbd')}"  # "bb"
  puts "DP:          #{longest_palindrome_dp('cbbd')}"     # "bb"
  puts "Optimized:   #{longest_palindrome('cbbd')}"        # "bb"
end
