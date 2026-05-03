# frozen_string_literal: true

# LeetCode 127: Word Ladder
#
# Problem:
# Given beginWord, endWord, and a wordList. Return the number of words in the
# shortest transformation sequence from beginWord to endWord (change one letter
# at a time, each intermediate word must be in wordList). Return 0 if no path.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS from beginWord, try all possible one-character changes and check if in
#    word set. This is actually the optimal approach.
#    Time Complexity: O(m^2 * n) — m=word length, n=wordList size
#    Space Complexity: O(m^2 * n)
#
# 2. Bottleneck
#    Checking all n words per BFS node is O(n*m) — use wildcard patterns to
#    preprocess adjacency (groups words by pattern).
#
# 3. Optimized Accepted Approach
#    Preprocess: for each word, generate all wildcard patterns (e.g., "hot" →
#    "*ot","h*t","ho*"). Group words by pattern. BFS expands via pattern lookup.
#    Time Complexity: O(m^2 * n)
#    Space Complexity: O(m^2 * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# begin="hit", end="cog", list=["hot","dot","dog","lot","log","cog"]
# BFS: "hit"(1) → "hot"(2) → "dot","lot"(3) → "dog","log"(4) → "cog"(5)
# return 5 ✓
#
# Edge Cases:
# - endWord not in wordList -> 0
# - beginWord == endWord -> 1

require 'set'

def ladder_length_brute(begin_word, end_word, word_list)
  word_set = Set.new(word_list)
  return 0 unless word_set.include?(end_word)

  queue   = [[begin_word, 1]]
  visited = Set.new([begin_word])

  until queue.empty?
    word, len = queue.shift
    return len if word == end_word

    word.length.times do |i|
      ('a'..'z').each do |ch|
        next if ch == word[i]
        new_word = word.dup
        new_word[i] = ch
        next unless word_set.include?(new_word) && !visited.include?(new_word)
        visited << new_word
        queue << [new_word, len + 1]
      end
    end
  end

  0
end

def ladder_length(begin_word, end_word, word_list)
  word_set = Set.new(word_list)
  return 0 unless word_set.include?(end_word)

  # Build pattern → [words] adjacency map
  pattern_map = Hash.new { |h, k| h[k] = [] }
  (word_list + [begin_word]).each do |word|
    word.length.times do |i|
      pattern = word.dup
      pattern[i] = '*'
      pattern_map[pattern] << word
    end
  end

  queue   = [[begin_word, 1]]
  visited = Set.new([begin_word])

  until queue.empty?
    word, len = queue.shift
    return len if word == end_word

    word.length.times do |i|
      pattern = word.dup
      pattern[i] = '*'
      pattern_map[pattern].each do |neighbor|
        next if visited.include?(neighbor)
        visited << neighbor
        queue << [neighbor, len + 1]
      end
    end
  end

  0
end

if __FILE__ == $PROGRAM_NAME
  list = ["hot","dot","dog","lot","log","cog"]
  puts "Brute: #{ladder_length_brute('hit', 'cog', list)}"  # 5
  puts "Opt:   #{ladder_length('hit', 'cog', list)}"         # 5
  puts "Brute: #{ladder_length_brute('hit', 'cog', ['hot','dot','dog','lot','log'])}"  # 0
  puts "Opt:   #{ladder_length('hit', 'cog', ['hot','dot','dog','lot','log'])}"         # 0
end
