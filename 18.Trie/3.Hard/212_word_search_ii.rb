# frozen_string_literal: true

# LeetCode 212: Word Search II
#
# Problem:
# Given an m×n board of characters and a list of words, find all words
# that can be formed by tracing adjacent cells (no reuse).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each word, run DFS on the board to check if it exists.
#    Time Complexity: O(w * m * n * 4^L) where w = words, L = max word length
#    Space Complexity: O(L)
#
# 2. Bottleneck
#    Searching one word at a time repeats board traversal. Build a trie of all words,
#    then DFS the board once, pruning branches not in the trie.
#
# 3. Optimized Accepted Approach
#    Trie of words. DFS from each cell: traverse trie simultaneously.
#    When end_of_word reached, record word. Remove found words from trie (pruning).
#
#    Time Complexity: O(m * n * 4 * 3^(L-1)) where L = max word length
#    Space Complexity: O(total chars in words)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# board=[["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]]
# words=["oath","pea","eat","rain"]
# DFS from (0,0)='o': o->a->t->h? -> find [0,0][0,1][1,1][2,1]? check trie
# Eventually finds "oath" and "eat"
#
# Edge Cases:
# - Word longer than board: never found
# - Same word multiple times in words: return once

class WS2Node
  attr_accessor :children, :word

  def initialize
    @children = {}
    @word = nil
  end
end

def find_words_brute(board, words)
  found = []
  words.each do |word|
    rows = board.length
    cols = board[0].length
    visited = Array.new(rows) { Array.new(cols, false) }

    dfs = lambda do |r, c, idx|
      return true if idx == word.length
      return false if r < 0 || r >= rows || c < 0 || c >= cols
      return false if visited[r][c] || board[r][c] != word[idx]
      visited[r][c] = true
      found_path = [[1, 0], [-1, 0], [0, 1], [0, -1]].any? { |dr, dc| dfs.call(r + dr, c + dc, idx + 1) }
      visited[r][c] = false
      found_path
    end

    rows.times { |r| cols.times { |c| found << word if dfs.call(r, c, 0) && !found.include?(word) } }
  end
  found
end

def find_words(board, words)
  root = WS2Node.new
  words.each do |word|
    node = root
    word.each_char do |c|
      node.children[c] ||= WS2Node.new
      node = node.children[c]
    end
    node.word = word
  end

  rows = board.length
  cols = board[0].length
  result = []

  dfs = lambda do |node, r, c|
    return if r < 0 || r >= rows || c < 0 || c >= cols
    ch = board[r][c]
    return unless node.children.key?(ch)
    next_node = node.children[ch]
    if next_node.word
      result << next_node.word
      next_node.word = nil
    end
    board[r][c] = '#'
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |dr, dc| dfs.call(next_node, r + dr, c + dc) }
    board[r][c] = ch
    node.children.delete(ch) if next_node.children.empty? && next_node.word.nil?
  end

  rows.times { |r| cols.times { |c| dfs.call(root, r, c) } }
  result
end

if __FILE__ == $PROGRAM_NAME
  board = [%w[o a a n], %w[e t a e], %w[i h k r], %w[i f l v]]
  puts find_words_brute(board.map(&:dup), %w[oath pea eat rain]).sort.inspect
  puts find_words(board, %w[oath pea eat rain]).sort.inspect
end
