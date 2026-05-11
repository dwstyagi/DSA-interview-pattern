# frozen_string_literal: true

# LeetCode 91: Decode Ways
#
# Problem:
# A message containing letters A-Z can be encoded into numbers where A=1, B=2, ..., Z=26.
# Given a string s of digits, return the number of ways to decode it.
#
# Examples:
#   Input:  s = "12"
#   Output: 2
#   Why:    "12" can be decoded as "AB" (1,2) or "L" (12) -> 2 ways.
#
#   Input:  s = "226"
#   Output: 3
#   Why:    "2,2,6"="BBF", "22,6"="VF", "2,26"="BZ" -> 3 ways.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive: at each position, try decoding 1 or 2 digits; count valid decodings.
#
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated sub-problems at overlapping positions.
#
# 3. Optimized Accepted Approach
#    1D DP: dp[i] = number of ways to decode s[0..i-1].
#    dp[i] += dp[i-1] if s[i-1] is a valid single digit (1-9)
#    dp[i] += dp[i-2] if s[i-2..i-1] forms a valid two-digit number (10-26)
#
#    Time Complexity: O(n)
#    Space Complexity: O(n) → reducible to O(1) with rolling vars
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "226"
# dp = [1, 1, 0, 0]
# i=1: s[0]='2' != '0' → dp[1] += dp[0] = 1
# i=2: s[1]='2' != '0' → dp[2] += dp[1] = 1
#       s[0..1]="22" in 10..26 → dp[2] += dp[0] = 2
# i=3: s[2]='6' != '0' → dp[3] += dp[2] = 2
#       s[1..2]="26" in 10..26 → dp[3] += dp[1] = 3
# Result: dp[3] = 3
#
# Edge Cases:
# - s = "0"    -> 0 (no valid decoding)
# - s = "10"   -> 1 (only "J")
# - Leading zeros like "06" -> 0

def num_decodings_brute(s)
  memo = {}

  decode = ->(i) {
    return memo[i] if memo.key?(i)
    return 1 if i == s.length
    return 0 if s[i] == '0' # leading zero, invalid

    # Try single-digit decode
    result = decode.call(i + 1)

    # Try two-digit decode if valid (10..26)
    if i + 1 < s.length
      two = s[i, 2].to_i
      result += decode.call(i + 2) if two >= 10 && two <= 26
    end

    memo[i] = result
  }

  decode.call(0)
end

def num_decodings(s)
  n = s.length
  # dp[i] = ways to decode the first i characters of s
  dp = Array.new(n + 1, 0)
  dp[0] = 1         # empty string has one decoding
  dp[1] = s[0] == '0' ? 0 : 1  # first char valid iff not '0'

  (2..n).each do |i|
    # Single-digit decode: s[i-1] must not be '0'
    dp[i] += dp[i - 1] if s[i - 1] != '0'

    # Two-digit decode: s[i-2..i-1] must be 10..26
    two = s[i - 2, 2].to_i
    dp[i] += dp[i - 2] if two >= 10 && two <= 26
  end

  dp[n]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{num_decodings_brute('226')}" # 3
  puts "Optimized:   #{num_decodings('226')}"       # 3
  puts "Brute force: #{num_decodings_brute('06')}"  # 0
  puts "Optimized:   #{num_decodings('06')}"        # 0
end
