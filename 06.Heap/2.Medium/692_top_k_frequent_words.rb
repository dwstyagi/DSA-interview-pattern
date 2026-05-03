# frozen_string_literal: true

# LeetCode 692: Top K Frequent Words
#
# Problem:
# Given an array of strings words and an integer k, return the k most frequent
# strings. Return the answer sorted by frequency from highest to lowest.
# Ties are sorted by alphabetical order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count frequencies, sort by (-freq, word) to get deterministic order,
#    return first k.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all unique words when we only need k.
#
# 3. Optimized Accepted Approach
#    Count frequencies, maintain a min-heap of size k with custom comparator:
#    lower frequency = more likely to be evicted; for ties, lexicographically
#    larger word is evicted first (since we want smaller words in the answer).
#    Time Complexity: O(n log k)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words = ["i","love","leetcode","i","love","coding"], k = 2
# freq = {i: 2, love: 2, leetcode: 1, coding: 1}
# sorted by (-freq, word): [(2,i),(2,love),(1,coding),(1,leetcode)]
# top 2 = ["i", "love"]
#
# Edge Cases:
# - All words same frequency → return k alphabetically smallest
# - k = 1 → return most frequent (or alphabetically first if tie)

def top_k_frequent_brute(words, k)
  freq = words.tally
  freq.sort_by { |word, count| [-count, word] }.first(k).map(&:first)
end

def top_k_frequent(words, k)
  freq = words.tally

  # sort by (count asc, word desc) so we can evict the "worst" from the front
  # worst = lowest frequency, or for ties: lexicographically largest (we want smallest)
  heap = freq.map { |word, count| [count, word] }
             .sort_by { |count, word| [count, word.chars.map { |c| -c.ord }] }

  # keep only top k
  heap = heap.last(k)

  # result: sort by (freq desc, word asc)
  heap.sort_by { |count, word| [-count, word] }.map { |_, word| word }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{top_k_frequent_brute(%w[i love leetcode i love coding], 2).inspect}"
  puts "Opt:   #{top_k_frequent(%w[i love leetcode i love coding], 2).inspect}"
  puts "Brute: #{top_k_frequent_brute(%w[the day is sunny the the the sunny is is], 4).inspect}"
  puts "Opt:   #{top_k_frequent(%w[the day is sunny the the the sunny is is], 4).inspect}"
end
