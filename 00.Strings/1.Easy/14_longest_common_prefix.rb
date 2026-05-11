# frozen_string_literal: true

# LeetCode 14: Longest Common Prefix
#
# Problem:
# Write a function to find the longest common prefix string amongst an array of strings.
# If there is no common prefix, return an empty string "".
#
# Examples:
#   Input:  strs = ["flower","flow","flight"]
#   Output: "fl"
#   Why:    All three strings start with "fl". The third char differs (o vs i), so "fl" is the answer.
#
#   Input:  strs = ["dog","racecar","car"]
#   Output: ""
#   Why:    "dog" starts with 'd', others start with 'r' and 'c' — no common prefix at all.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each prefix of strs[0], check if all other strings start with that prefix.
#
#    Time Complexity: O(n * m) where n = number of strings, m = length of first string
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    Redundant re-checking of the same prefix characters.
#
# 3. Optimized Accepted Approach
#    Vertical scan: go column by column. For each column index i,
#    check if all strings have the same character at position i.
#    Stop when a mismatch is found or a string ends.
#
#    Time Complexity: O(n * m) — same asymptotically but stops early on mismatch
#    Space Complexity: O(m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# strs = ["flower", "flow", "flight"]
# col 0: f,f,f → match
# col 1: l,l,l → match
# col 2: o,o,i → mismatch → return "fl"
#
# strs = ["dog", "racecar", "car"]
# col 0: d,r,c → mismatch immediately → return ""
#
# Edge Cases:
# - Single string          -> return that string
# - One empty string       -> return ""
# - All identical strings  -> return full string

def longest_common_prefix_brute(strs)
  return '' if strs.empty?

  prefix = strs[0]
  # Gradually shorten the prefix until it's shared by all strings
  strs[1..].each do |s|
    prefix = prefix[0, prefix.length - 1] until s.start_with?(prefix) || prefix.empty?
  end
  prefix
end

def longest_common_prefix(strs)
  return '' if strs.empty?

  # Iterate column by column using the first string as reference
  strs[0].each_char.with_index do |char, i|
    # Check if every other string has the same char at this position
    strs[1..].each do |s|
      # If we've gone past the end of this string or chars differ, stop
      return strs[0][0, i] if i >= s.length || s[i] != char
    end
  end

  strs[0] # all characters matched
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{longest_common_prefix_brute(%w[flower flow flight])}" # "fl"
  puts "Optimized:   #{longest_common_prefix(%w[flower flow flight])}"       # "fl"
  puts "Brute force: #{longest_common_prefix_brute(%w[dog racecar car])}"   # ""
  puts "Optimized:   #{longest_common_prefix(%w[dog racecar car])}"         # ""
end
