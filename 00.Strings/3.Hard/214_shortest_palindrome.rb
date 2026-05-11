# frozen_string_literal: true

# LeetCode 214: Shortest Palindrome
#
# Problem:
# You are given a string s. You can convert s to a palindrome by adding characters
# in front of it. Return the shortest palindrome you can find.
#
# Examples:
#   Input:  s = "aacecaaa"
#   Output: "aaacecaaa"
#   Why:    The longest palindromic prefix is "aacecaa". Prepend the reverse of
#           the remaining suffix "a" -> prepend "a" -> "aaacecaaa".
#
#   Input:  s = "abcd"
#   Output: "dcbabcd"
#   Why:    Longest palindromic prefix is just "a". Reverse of "bcd" is "dcb",
#           prepend it -> "dcbabcd".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try prepending reverse of each suffix of s and check if the result is a palindrome.
#    Start with shortest prefix that is already a palindrome.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Checking palindrome for each prefix is O(n) per check = O(n^2) total.
#
# 3. Optimized Accepted Approach
#    Build the string: s + '#' + reverse(s)
#    Compute KMP failure function on it.
#    The failure value at the last position gives the length of the longest
#    prefix of s that is also a palindrome (= longest palindromic prefix).
#    Prepend the reverse of the remaining suffix.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "aacecaaa"
# rev = "aaacecaa"
# combined = "aacecaaa#aaacecaa"
# KMP failure on combined → last value = 7
# longest palindromic prefix = s[0..6] = "aacecaa"
# need to prepend reverse of s[7..] = "a" → result = "a" + "aacecaaa" = "aaacecaaa"
#
# Edge Cases:
# - Already a palindrome -> return s
# - Single char          -> return s
# - All same chars       -> return s

def shortest_palindrome_brute(s)
  return s if s.empty?

  # Find the longest palindromic prefix
  n = s.length
  rev = s.reverse

  # Try each prefix length from longest to shortest
  n.downto(0) do |len|
    prefix = s[0, len]
    # If prefix is a palindrome, prepend the reverse of the remaining part
    return rev[0, n - len] + s if prefix == prefix.reverse
  end

  rev + s
end

def shortest_palindrome(s)
  return s if s.empty?

  rev = s.reverse
  # Use KMP to find longest palindromic prefix
  # Build the concatenation with a sentinel to prevent cross-matching
  combined = s + '#' + rev
  n = combined.length

  # Build KMP failure function
  fail_table = Array.new(n, 0)
  j = 0
  (1...n).each do |i|
    j -= 1 while j > 0 && combined[j] != combined[i]
    j += 1 if combined[j] == combined[i]
    fail_table[i] = j
  end

  # fail_table[-1] = length of longest palindromic prefix of s
  longest_palindromic_prefix = fail_table[-1]

  # Prepend the reverse of the non-palindromic suffix
  rev[0, s.length - longest_palindromic_prefix] + s
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{shortest_palindrome_brute('aacecaaa')}" # "aaacecaaa"
  puts "Optimized:   #{shortest_palindrome('aacecaaa')}"       # "aaacecaaa"
  puts "Brute force: #{shortest_palindrome_brute('abcd')}"     # "dcbabcd"
  puts "Optimized:   #{shortest_palindrome('abcd')}"           # "dcbabcd"
end
