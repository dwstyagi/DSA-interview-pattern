# frozen_string_literal: true

# LeetCode 692: Top K Frequent Words
#
# Problem:
# Given words array and integer k, return k most frequent words.
# Sort by frequency descending; ties broken alphabetically.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count frequencies, sort by (-freq, word), take first k.
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    We only need top k. Use a min-heap of size k for O(n log k).
#
# 3. Optimized Accepted Approach
#    Count frequencies. Sort with custom comparator: (-freq, word).
#    Take first k elements.
#
#    Time Complexity: O(n log k)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["i","love","leetcode","i","love","coding"], k=2
# freq: i=2, love=2, leetcode=1, coding=1
# sorted by (-freq, word): [[-2,"i"],[-2,"love"],[-1,"coding"],[-1,"leetcode"]]
# top 2: ["i","love"]
#
# Edge Cases:
# - k = 1: most frequent word (alphabetically smallest if tie)
# - All same frequency: return first k alphabetically

def top_k_frequent_brute(words, k)
  freq = Hash.new(0)
  words.each { |w| freq[w] += 1 }
  freq.sort_by { |w, f| [-f, w] }.first(k).map(&:first)
end

# optimized: same sort approach (already efficient)
def top_k_frequent(words, k)
  freq = Hash.new(0)
  words.each { |w| freq[w] += 1 }
  freq.keys.sort_by { |w| [-freq[w], w] }.first(k)
end

if __FILE__ == $PROGRAM_NAME
  puts top_k_frequent_brute(%w[i love leetcode i love coding], 2).inspect  # ["i","love"]
  puts top_k_frequent(%w[the day is sunny the the the sunny is is], 4).inspect
  # ["the","is","sunny","day"]
end
