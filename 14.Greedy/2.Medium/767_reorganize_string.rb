# frozen_string_literal: true

# LeetCode 767: Reorganize String
#
# Problem:
# Given string s, rearrange so no two adjacent characters are the same.
# Return any valid arrangement, or "" if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations of s, return first with no adjacent duplicates.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    If max_freq > (n+1)/2, impossible. Otherwise greedily place most
#    frequent available character that is not the same as previous.
#
# 3. Optimized Accepted Approach
#    Use a max-heap. Always pick the most frequent character that differs
#    from the last placed character. If the last was most frequent, swap with second.
#
#    Time Complexity: O(n log k) where k = distinct chars
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "aab" -> freq: a=2, b=1 -> max_freq=2 <= (3+1)/2=2 -> possible
# heap: [[-2,'a'],[-1,'b']]
# pick 'a' (freq 2), result="a", push back [-1,'a']
# pick 'b' (freq 1), result="ab", push back (0, done)
# pick 'a' (freq 1), result="aba"
#
# Edge Cases:
# - Single char: return it
# - All same char with length > 1: return ""

require 'set'

def reorganize_string_brute(s)
  freq = Hash.new(0)
  s.chars.each { |c| freq[c] += 1 }
  max_f = freq.values.max
  return '' if max_f > (s.length + 1) / 2

  chars = freq.flat_map { |c, f| [c] * f }.sort_by { |c| -freq[c] }
  result = Array.new(s.length)
  idx = 0
  chars.each do |c|
    result[idx] = c
    idx += 2
    idx = 1 if idx >= s.length
  end
  result.join
end

# optimized: greedy with max-heap simulation
def reorganize_string(s)
  freq = Hash.new(0)
  s.chars.each { |c| freq[c] += 1 }
  max_f = freq.values.max
  return '' if max_f > (s.length + 1) / 2

  # sort by frequency desc; use same interleaving trick
  sorted = freq.sort_by { |_, f| -f }.map(&:first)
  result = Array.new(s.length)
  idx = 0
  sorted.each do |c|
    freq[c].times do
      result[idx] = c
      idx += 2
      idx = 1 if idx >= s.length
    end
  end
  result.join
end

if __FILE__ == $PROGRAM_NAME
  puts reorganize_string_brute('aab')   # "aba"
  puts reorganize_string('aaab')        # ""
end
