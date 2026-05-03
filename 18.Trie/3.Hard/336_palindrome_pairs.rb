# frozen_string_literal: true

# LeetCode 336: Palindrome Pairs
#
# Problem:
# Given words array, find all pairs [i, j] where words[i] + words[j] is a palindrome.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all pairs (i, j), check if concatenation is palindrome.
#    Time Complexity: O(n^2 * m)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    For each word w, we need either: reverse(w) in dict, or some prefix of reverse(w)
#    is in dict and suffix of w is palindrome, or vice versa.
#
# 3. Optimized Accepted Approach
#    Build hash of word -> index. For each word:
#    1. If reverse(word) is in dict (not same index): add pair.
#    2. For each split of word into [left, right]: if left is palindrome and
#       reverse(right) in dict: pair [idx(reverse(right)), i].
#    3. If right is palindrome and reverse(left) in dict: pair [i, idx(reverse(left))].
#
#    Time Complexity: O(n * m^2)
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words = ["abcd","dcba","lls","s","sssll"]
# "abcd": reverse="dcba" in dict at 1 -> [0,1]; [1,0]
# "lls": reverse="sll"; split: "","lls"->rev="sll"? no. "l","ls"->pal? no. "ll","s"->"s" in dict
#        "ll" is palindrome -> pair [i=2, idx("s")=3]=[2,3]
#        also reverse split: "s" in dict and "ll" palindrome -> [3,2]
# ... Result: [[0,1],[1,0],[3,2],[2,4],[4,0]]
#
# Edge Cases:
# - Empty string: pairs with any palindrome word

def palindrome_pairs_brute(words)
  result = []
  n = words.length
  palindrome = ->(s) { s == s.reverse }
  n.times do |i|
    n.times do |j|
      next if i == j
      result << [i, j] if palindrome.call(words[i] + words[j])
    end
  end
  result
end

def palindrome_pairs(words)
  word_map = {}
  words.each_with_index { |w, i| word_map[w] = i }
  result = []
  palindrome = ->(s) { s == s.reverse }

  words.each_with_index do |word, i|
    rev = word.reverse
    if word_map.key?(rev) && word_map[rev] != i
      result << [i, word_map[rev]]
    end
    (1...word.length).each do |k|
      left = word[0...k]
      right = word[k..]
      if palindrome.call(left)
        rev_right = right.reverse
        result << [word_map[rev_right], i] if word_map.key?(rev_right) && word_map[rev_right] != i
      end
      if palindrome.call(right)
        rev_left = left.reverse
        result << [i, word_map[rev_left]] if word_map.key?(rev_left) && word_map[rev_left] != i
      end
    end
  end
  result.uniq.sort
end

if __FILE__ == $PROGRAM_NAME
  puts palindrome_pairs_brute(%w[abcd dcba lls s sssll]).sort.inspect
  puts palindrome_pairs(%w[a '']).inspect
end
