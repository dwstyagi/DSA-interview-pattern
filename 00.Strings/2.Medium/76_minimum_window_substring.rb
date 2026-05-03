# frozen_string_literal: true

# LeetCode 76: Minimum Window Substring
#
# Problem:
# Given strings s and t, return the minimum window substring of s such that every
# character in t (including duplicates) is included in the window.
# If no such window exists, return "".
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Check every substring of s and verify it contains all chars of t.
#
#    Time Complexity: O(n^2 * m)
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    Redundant re-scanning of substrings. We need to maintain a live count.
#
# 3. Optimized Accepted Approach
#    Sliding window with two frequency maps.
#    Expand right to include needed chars; shrink left once all are covered.
#    Track "have" count vs "need" count to avoid re-scanning the map.
#
#    Time Complexity: O(n + m)
#    Space Complexity: O(m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "ADOBECODEBANC", t = "ABC"
# need = {A:1, B:1, C:1}, have=0, need_count=3
# Expand right until have==3: window "ADOBEC" (left=0,right=5)
# Shrink: remove 'A' → have drops → expand again
# Best window tracks minimum length throughout
# Answer: "BANC"
#
# Edge Cases:
# - t not in s    -> ""
# - s == t        -> s
# - t has dupes   -> window must have at least that many

def min_window_brute(s, t)
  return '' if s.empty? || t.empty?

  best = ''
  t_count = t.chars.tally

  (0...s.length).each do |i|
    (i...s.length).each do |j|
      window = s[i..j]
      # Check if this window contains all chars of t
      if t_count.all? { |c, cnt| window.count(c) >= cnt }
        best = window if best.empty? || window.length < best.length
      end
    end
  end

  best
end

def min_window(s, t)
  return '' if t.empty?

  need  = t.chars.tally     # required char frequencies
  have  = Hash.new(0)       # current window frequencies
  formed = 0                # how many unique chars are fully satisfied
  required = need.size      # number of unique chars we need to satisfy

  best_len = Float::INFINITY
  best_start = 0
  left = 0

  s.each_char.with_index do |char, right|
    have[char] += 1

    # Check if this char's frequency now meets the requirement
    formed += 1 if need[char] && have[char] == need[char]

    # Shrink window from left while all conditions are satisfied
    while formed == required
      # Update best window if current is smaller
      if right - left + 1 < best_len
        best_len   = right - left + 1
        best_start = left
      end

      # Remove leftmost character from window
      left_char = s[left]
      have[left_char] -= 1
      formed -= 1 if need[left_char] && have[left_char] < need[left_char]
      left += 1
    end
  end

  best_len == Float::INFINITY ? '' : s[best_start, best_len]
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute force: #{min_window_brute('ADOBECODEBANC', 'ABC')}" # "BANC"
  puts "Optimized:   #{min_window('ADOBECODEBANC', 'ABC')}"       # "BANC"
  puts "Brute force: #{min_window_brute('a', 'aa')}"              # ""
  puts "Optimized:   #{min_window('a', 'aa')}"                    # ""
end
