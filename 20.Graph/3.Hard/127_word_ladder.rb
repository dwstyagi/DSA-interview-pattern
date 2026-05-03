# frozen_string_literal: true

# LeetCode 127: Word Ladder
#
# Problem:
# Given beginWord, endWord, and a wordList, return the number of words in the
# shortest transformation sequence from beginWord to endWord. Each step changes
# exactly one letter, and every intermediate word must be in wordList.
# Return 0 if no such sequence exists.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS from beginWord, trying all one-letter neighbors.
#    Track visited. Return shortest path length.
#
#    Time Complexity: O(n * m^2) where n = wordList size, m = word length
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    DFS doesn't guarantee shortest path. BFS does — each level = one transformation.
#    Finding neighbors is the slow part — check all words or use wildcard patterns.
#
# 3. Optimized Accepted Approach
#    BFS with wildcard pattern adjacency:
#    - Build adjacency map: pattern like "h*t" -> ["hot", "hit"]
#    - BFS from beginWord level by level
#    - For each word, generate all patterns, find neighbors from map
#    - Return level count when endWord is reached
#
#    Time Complexity: O(n * m^2)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# beginWord = "hit", endWord = "cog"
# wordList = ["hot","dot","dog","lot","log","cog"]
#
# BFS:
# Level 1: ["hit"]
# Level 2: hit -> h*t -> ["hot"] => ["hot"]
# Level 3: hot -> *ot -> ["dot","lot"] => ["dot","lot"]
# Level 4: dot -> d*g -> ["dog"], lot -> l*g -> ["log"] => ["dog","log"]
# Level 5: dog -> *og -> ["cog"], log -> *og -> ["cog"] => ["cog"] -> return 5 ✓
#
# Edge Cases:
# - endWord not in wordList -> return 0
# - beginWord == endWord -> return 1
# - No path exists -> return 0

def ladder_length_brute(begin_word, end_word, word_list)
  word_set = word_list.to_set
  return 0 unless word_set.include?(end_word)

  queue = [[begin_word, 1]]
  visited = Set.new([begin_word])

  until queue.empty?
    word, length = queue.shift
    return length if word == end_word

    word.length.times do |i|
      ('a'..'z').each do |char|
        next if char == word[i]

        neighbor = word.dup
        neighbor[i] = char
        next unless word_set.include?(neighbor) && !visited.include?(neighbor)

        visited.add(neighbor)
        queue << [neighbor, length + 1]
      end
    end
  end

  0
end

def ladder_length(begin_word, end_word, word_list)
  word_set = word_list.to_set
  return 0 unless word_set.include?(end_word)

  # build wildcard -> [words] adjacency map
  adj = Hash.new { |h, k| h[k] = [] }
  ([begin_word] + word_list).each do |word|
    word.length.times do |i|
      pattern = "#{word[0, i]}*#{word[i + 1..]}"
      adj[pattern] << word
    end
  end

  queue = [begin_word]
  visited = Set.new([begin_word])
  level = 1

  until queue.empty?
    next_queue = []

    queue.each do |word|
      return level if word == end_word

      word.length.times do |i|
        pattern = "#{word[0, i]}*#{word[i + 1..]}"
        adj[pattern].each do |neighbor|
          next if visited.include?(neighbor)

          visited.add(neighbor)
          next_queue << neighbor
        end
      end
    end

    queue = next_queue
    level += 1
  end

  0
end

if __FILE__ == $PROGRAM_NAME
  begin_word = "hit"
  end_word = "cog"
  word_list = %w[hot dot dog lot log cog]

  puts "Brute:     #{ladder_length_brute(begin_word, end_word, word_list)}"
  puts "Optimized: #{ladder_length(begin_word, end_word, word_list)}"
end
