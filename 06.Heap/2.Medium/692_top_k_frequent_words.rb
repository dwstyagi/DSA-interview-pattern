# frozen_string_literal: true

# LeetCode 692: Top K Frequent Words
#
# Problem:
# Given an array of strings words and an integer k, return the k most frequent
# strings. Return the answer sorted by frequency from highest to lowest.
# Ties are sorted by alphabetical order.
#
# Examples:
#   Input:  words = ["i","love","leetcode","i","love","coding"], k = 2
#   Output: ["i","love"]
#   Why:    "i" appears 2x, "love" 2x — tied by freq, sorted alphabetically.
#
#   Input:  words = ["the","day","is","sunny","the","the","the","sunny","is","is"], k = 4
#   Output: ["the","is","sunny","day"]
#   Why:    Frequencies: the=4, is=3, sunny=2, day=1 — top 4 by freq.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force
#    Count frequencies, sort by (-freq, word) to get deterministic order,
#    return first k.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Sorting all unique words when we only need k.
#
# 3. Optimized Min-Heap Approach
#    Count frequencies, maintain a MinHeap of size k.
#    Heap stores [count, word].
#    If heap grows beyond k, pop the weakest element.
#    Weakest = lowest frequency. If tied, larger word is worse and gets removed first.
#    Time Complexity: O(n log k)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words = ["i","love","leetcode","i","love","coding"], k = 2
# freq = { "i"=>2, "love"=>2, "leetcode"=>1, "coding"=>1 }
#
# Push [count, word]:
#
# "i"        -> [2, "i"]
# "love"     -> [2, "love"]       heap size == k, no eviction
# "leetcode" -> [1, "leetcode"]   heap size 3 > k, pop min
#   [1,"leetcode"] is weakest (lowest count) → evicted
#   heap: [(2,"i"),(2,"love")]
# "coding"   -> [1, "coding"]     heap size 3 > k, pop min
#   [1,"coding"] is weakest → evicted
#   heap: [(2,"i"),(2,"love")]
#
# Extract: pop gives (2,"love") → unshift → ["love"]
#          pop gives (2,"i")    → unshift → ["i","love"]
# Output: ["i","love"] ✓
#
# Edge Cases:
# - All words same frequency → return k alphabetically smallest
# - k = 1 → return most frequent (or alphabetically first if tie)

require 'algorithms'

# -----------------------------
# BRUTE FORCE
# -----------------------------
# Idea:
# - Count frequencies using tally
# - Sort by (-frequency, word) for deterministic order
# - Take first k, return just the words
#
# Time: O(n log n)
# Space: O(n)
def top_k_frequent_brute(words, k)
  freq = words.tally
  freq.sort_by { |word, count| [-count, word] }.first(k).map(&:first)
end

# -----------------------------
# OPTIMIZED MIN-HEAP SOLUTION
# -----------------------------
# Idea:
# - Keep only k strongest words in a MinHeap
# - Heap stores [count, word]
# - The top of MinHeap is the weakest among current k words
# - If heap size becomes greater than k, remove that weakest element
#
# Weakest = lowest count.
# If counts tie, larger word is weaker (we want to keep smaller words).
#
# Time: O(n log k)
# Space: O(n)
def top_k_frequent(words, k)
  freq = words.tally

  # MinHeap: top = weakest = most evictable
  # Compare by frequency first, then reverse alphabetical order for ties
  heap = Containers::MinHeap.new do |a, b|
    if a[0] == b[0]
      b[1] <=> a[1]
    else
      a[0] <=> b[0]
    end
  end

  freq.each do |word, count|
    heap.push([count, word])

    heap.pop if heap.size > k
  end

  # Pop gives weakest → strongest. unshift reverses → freq desc, alpha asc.
  result = []
  result.unshift(heap.pop[1]) while heap.size.positive?
  result
end

if __FILE__ == $PROGRAM_NAME
  words = %w[i love leetcode i love coding]
  k = 2

  puts "Brute: #{top_k_frequent_brute(words, k)}"
  puts "Opt:   #{top_k_frequent(words, k)}"

  words = %w[the day is sunny the the the sunny is is]
  k = 4

  puts "Brute: #{top_k_frequent_brute(words, k)}"
  puts "Opt:   #{top_k_frequent(words, k)}"
end
