# frozen_string_literal: true

# LeetCode 767: Reorganize String
#
# Problem:
# Given a string s, rearrange the characters so that any two adjacent
# characters are not the same. Return any possible rearrangement, or ""
# if it is impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations, return the first one with no adjacent duplicates.
#    Time Complexity: O(n! * n) — impractical
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Permutation enumeration is exponential.
#
# 3. Optimized Accepted Approach
#    Greedy with max-heap: always place the most frequent unused character.
#    If that character is the same as the last placed, use the second most
#    frequent instead. Impossible if any char's frequency > (n+1)/2.
#    Time Complexity: O(n log k) where k = unique chars
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "aab"
# freq = {a: 2, b: 1}
# max-heap (by count): [(2,a), (1,b)]
# Step 1: pick a (freq 2), result = "a", re-push (1,a)
# Step 2: last = 'a'; pick a again? no same → pick b (freq 1), result = "ab"
# Step 3: pick a (freq 1), result = "aba"
# Return "aba"
#
# Edge Cases:
# - Any single character → return it
# - Impossible: "aaa" → return ""
# - All same chars → impossible if length > 1

def reorganize_string_brute(s)
  freq = s.chars.tally
  return "" if freq.values.max > (s.length + 1) / 2

  chars = freq.flat_map { |c, cnt| [c] * cnt }.sort
  result = Array.new(s.length)
  # place all chars at even positions then odd positions
  idx = 0
  chars.each_with_index do |c, i|
    result[idx] = c
    idx += 2
    idx = 1 if idx >= s.length  # wrap around to odd positions
  end
  result.join
end

def reorganize_string(s)
  freq = s.chars.tally
  return "" if freq.values.max > (s.length + 1) / 2

  # max-heap simulated as array sorted ascending by count (last = max)
  heap = freq.map { |char, count| [count, char] }.sort

  result = +""
  while heap.size >= 2
    # pop two most frequent characters
    c2_count, c2 = heap.pop
    c1_count, c1 = heap.pop

    result << c2   # place most frequent
    result << c1   # alternate with second most frequent

    # reinsert with decremented counts if still remaining
    if c2_count - 1 > 0
      idx = heap.bsearch_index { |v| v[0] >= c2_count - 1 } || heap.size
      heap.insert(idx, [c2_count - 1, c2])
    end
    if c1_count - 1 > 0
      idx = heap.bsearch_index { |v| v[0] >= c1_count - 1 } || heap.size
      heap.insert(idx, [c1_count - 1, c1])
    end
  end

  # one element might remain (the most frequent if odd total)
  result << heap[0][1] if heap.size == 1

  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{reorganize_string_brute("aab")}"   # "aba"
  puts "Opt:   #{reorganize_string("aab")}"          # "aba"
  puts "Brute: #{reorganize_string_brute("aaab")}"  # ""
  puts "Opt:   #{reorganize_string("aaab")}"         # ""
end
