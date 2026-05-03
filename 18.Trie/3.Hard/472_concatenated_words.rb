# frozen_string_literal: true

# LeetCode 472: Concatenated Words
#
# Problem:
# Given words array, return all words that can be formed by concatenating at least
# 2 shorter words from the array.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each word, try all ways to split it into parts. Check each part is in set.
#    Time Complexity: O(n * 2^m) where m = max word length
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    Exponential splits. DP with word set: can we form the word using dict words (>=2)?
#
# 3. Optimized Accepted Approach
#    Sort by length. For each word, check if it can be formed by concatenating
#    shorter words (already processed) using DP/trie. Only add non-empty words
#    to the set.
#
#    Time Complexity: O(n * m^2)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words=["cat","cats","catsdogcats","dog","catsdog"]
# sorted: cat, dog, cats, catsdog, catsdogcats
# "cat": no split possible with shorter words
# "dog": same
# "cats": "cat"+"s"? "s" not in set. "c"+"ats"? no. not concatenated
# "catsdog": "cats"+"dog"? both in set -> YES
# "catsdogcats": "cats"+"dog"+"cats" -> YES
#
# Edge Cases:
# - No concatenated words: return []
# - Single char words: can combine to form multi-char words

def find_all_concatenated_words_brute(words)
  word_set = words.to_set
  words.select do |word|
    next false if word.empty?
    dp = Array.new(word.length + 1, false)
    dp[0] = true
    (1..word.length).each do |i|
      (0...i).each do |j|
        next unless dp[j]
        sub = word[j...i]
        if word_set.include?(sub) && (j > 0 || sub != word)
          dp[i] = true
          break
        end
      end
    end
    dp[word.length]
  end
end

def find_all_concatenated_words(words)
  word_set = Set.new
  result = []
  words.sort_by(&:length).each do |word|
    next if word.empty?
    dp = Array.new(word.length + 1, false)
    dp[0] = true
    (1..word.length).each do |i|
      (0...i).each do |j|
        next unless dp[j]
        if word_set.include?(word[j...i])
          dp[i] = true
          break
        end
      end
    end
    result << word if dp[word.length]
    word_set.add(word)
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts find_all_concatenated_words_brute(%w[cat cats catsdogcats dog catsdog]).inspect
  puts find_all_concatenated_words(%w[cat cats catsdogcats dog catsdog]).inspect
end
