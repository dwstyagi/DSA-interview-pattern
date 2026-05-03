# frozen_string_literal: true

# LeetCode 126: Word Ladder II
#
# Problem:
# Given beginWord, endWord, and wordList. Return all shortest transformation
# sequences from beginWord to endWord. Each word must differ by exactly one
# letter and be in the wordList.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS all paths to endWord, keep only those with minimum length.
#    Time Complexity: Exponential in worst case
#    Space Complexity: O(n * L) — all paths
#
# 2. Bottleneck
#    DFS explores too many long paths. BFS finds the shortest level, then
#    reconstruct all paths at that level using a parent map.
#
# 3. Optimized Accepted Approach
#    BFS to build a parent map (word → set of parents at previous level).
#    Stop BFS when endWord is reached. Backtrack from endWord using parent map
#    to reconstruct all shortest paths.
#    Time Complexity: O(m^2 * n) BFS + O(paths * path_length) backtrack
#    Space Complexity: O(m^2 * n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# begin="hit", end="cog", list=["hot","dot","dog","lot","log","cog"]
# BFS builds parents: hot←{hit}, dot←{hot}, lot←{hot}, dog←{dot}, log←{lot},
#                     cog←{dog,log}
# Backtrack from "cog": hit→hot→dot→dog→cog and hit→hot→lot→log→cog ✓
#
# Edge Cases:
# - No path -> []
# - Multiple equal-length paths all returned

require 'set'

def find_ladders_brute(begin_word, end_word, word_list)
  word_set = Set.new(word_list)
  return [] unless word_set.include?(end_word)

  result  = []
  min_len = Float::INFINITY

  dfs = lambda do |word, path, visited|
    if word == end_word
      if path.length < min_len
        min_len = path.length
        result  = [path.dup]
      elsif path.length == min_len
        result << path.dup
      end
      return
    end
    return if path.length >= min_len

    word.length.times do |i|
      ('a'..'z').each do |ch|
        next if ch == word[i]
        new_word = word.dup; new_word[i] = ch
        next unless word_set.include?(new_word) && !visited.include?(new_word)
        visited << new_word
        path << new_word
        dfs.call(new_word, path, visited)
        path.pop
        visited.delete(new_word)
      end
    end
  end

  dfs.call(begin_word, [begin_word], Set.new([begin_word]))
  result
end

def find_ladders(begin_word, end_word, word_list)
  word_set = Set.new(word_list)
  return [] unless word_set.include?(end_word)

  parents  = Hash.new { |h, k| h[k] = Set.new }
  current  = Set.new([begin_word])
  found    = false

  until current.empty? || found
    word_set -= current                        # remove current level from set
    next_level = Set.new

    current.each do |word|
      word.length.times do |i|
        ('a'..'z').each do |ch|
          next if ch == word[i]
          new_word = word.dup; new_word[i] = ch
          next unless word_set.include?(new_word)
          next_level << new_word
          parents[new_word] << word
          found = true if new_word == end_word
        end
      end
    end
    current = next_level
  end

  return [] unless found

  # Backtrack from endWord using parent map
  result = []
  backtrack = lambda do |word, path|
    if word == begin_word
      result << ([begin_word] + path).reverse
      return
    end
    parents[word].each { |p| backtrack.call(p, path + [word]) }
  end
  backtrack.call(end_word, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  list = ["hot","dot","dog","lot","log","cog"]
  puts "Opt: #{find_ladders('hit', 'cog', list).inspect}"
  # [["hit","hot","dot","dog","cog"],["hit","hot","lot","log","cog"]]
end
