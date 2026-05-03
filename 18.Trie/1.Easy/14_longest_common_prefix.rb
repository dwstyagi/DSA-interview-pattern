# frozen_string_literal: true

# LeetCode 14: Longest Common Prefix
#
# Problem:
# Find the longest common prefix string among an array of strings.
# Return "" if none exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Compare all strings character by character until mismatch.
#    Time Complexity: O(S) where S = sum of all characters
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Already O(S). Can use first string as reference and compare each other string.
#
# 3. Optimized Accepted Approach
#    Use first string as candidate prefix. For each subsequent string, shorten
#    prefix until it matches the start of that string.
#
#    Time Complexity: O(S)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# strs = ["flower","flow","flight"]
# prefix="flower"
# "flow": not prefix of "flower" -> no wait, check "flower".start_with?("flower") = no
# Actually: while "flow".start_with?(prefix) is false -> shrink prefix
# prefix="flowe" -> "flow".start_with?("flowe")? no -> "flow" -> yes!
# "flight": prefix="flow" -> "flight".start_with?("flow")? no -> "flo" -> no -> "fl" -> yes!
# Result: "fl"
#
# Edge Cases:
# - Empty array: ""
# - All identical: return the string itself

def longest_common_prefix_brute(strs)
  return '' if strs.empty?
  (0...strs[0].length).each do |i|
    char = strs[0][i]
    strs[1..].each do |s|
      return strs[0][0...i] if i >= s.length || s[i] != char
    end
  end
  strs[0]
end

def longest_common_prefix(strs)
  return '' if strs.empty?
  prefix = strs[0]
  strs[1..].each do |s|
    prefix = prefix[0...-1] until s.start_with?(prefix) || prefix.empty?
  end
  prefix
end

if __FILE__ == $PROGRAM_NAME
  puts longest_common_prefix_brute(%w[flower flow flight])  # "fl"
  puts longest_common_prefix(%w[dog racecar car])            # ""
end
