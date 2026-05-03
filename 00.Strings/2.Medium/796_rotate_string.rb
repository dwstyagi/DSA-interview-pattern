# frozen_string_literal: true

# LeetCode 796: Rotate String
#
# Problem:
# Given two strings s and goal, return true if and only if s can become goal
# after some number of shifts.
# A shift moves the leftmost character to the rightmost position.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all rotations of s (shift 0 to n-1 times) and check if any equals goal.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Trying every rotation is O(n) per rotation * n rotations = O(n^2).
#
# 3. Optimized Accepted Approach
#    Key insight: every rotation of s is a substring of s+s.
#    Check if goal appears in s+s (after verifying equal lengths).
#
#    Time Complexity: O(n) with KMP-based substring search
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "abcde", goal = "cdeab"
# s+s = "abcdeabcde"
# Does "cdeab" appear in "abcdeabcde"? Yes at index 2 → true
#
# s = "abcde", goal = "abced"
# s+s = "abcdeabcde"
# "abced" not in "abcdeabcde" → false
#
# Edge Cases:
# - Empty strings              -> true
# - Different lengths          -> false
# - Same string (0 rotations)  -> true

def rotate_string_brute(s, goal)
  return false if s.length != goal.length

  n = s.length
  # Try every possible rotation
  n.times do |k|
    return true if s[k..] + s[0, k] == goal
  end

  false
end

def rotate_string(s, goal)
  # Lengths must match for any rotation to equal goal
  return false if s.length != goal.length

  # Every rotation of s is a substring of the doubled string s+s
  (s + s).include?(goal)
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{rotate_string_brute('abcde', 'cdeab')}" # true
  puts "Optimized:   #{rotate_string('abcde', 'cdeab')}"       # true
  puts "Brute force: #{rotate_string_brute('abcde', 'abced')}" # false
  puts "Optimized:   #{rotate_string('abcde', 'abced')}"       # false
end
