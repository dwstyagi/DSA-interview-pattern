# frozen_string_literal: true

# LeetCode 5: Longest Palindromic Substring
#
# Problem:
# Given a string s, return the longest palindromic substring in s.
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

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{longest_palindrome_brute('babad')}" # "bab" or "aba"
  puts "Optimized:   #{longest_palindrome('babad')}"       # "bab" or "aba"
  puts "Brute force: #{longest_palindrome_brute('cbbd')}"  # "bb"
  puts "Optimized:   #{longest_palindrome('cbbd')}"        # "bb"
end
