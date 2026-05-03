# frozen_string_literal: true

# LeetCode 318: Maximum Product of Word Lengths
#
# Problem:
# Given a string array words, return the maximum value of length(word[i]) *
# length(word[j]) where the two words do not share any common letters.
# If no such pair exists, return 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each pair (i, j), check if any character appears in both words.
#    Time Complexity: O(n² * L) where L = average word length
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Character intersection check for each pair.
#
# 3. Optimized Accepted Approach
#    Encode each word as a 26-bit integer bitmask (bit i set if char 'a'+i present).
#    Two words share no letters iff masks[i] & masks[j] == 0.
#    Time Complexity: O(n² + n*L) for precompute + check all pairs
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# words = ["abcw", "baz", "foo", "bar", "xtfn", "abcdef"]
# masks: abcw=00000000000000000000001000000111, etc.
# "abcw" & "xtfn" = 0 → disjoint; product = 4 * 4 = 16
# "abcdef" & "xtfn" = 0? No, 'f' in abcdef, no 'f' in xtfn... check carefully
# max = 16
#
# Edge Cases:
# - All words share a common letter → return 0
# - Single word → return 0

def max_product_brute(words)
  max_prod = 0
  n = words.length
  (0...n).each do |i|
    (i + 1...n).each do |j|
      if (words[i].chars & words[j].chars).empty?   # intersection empty?
        prod = words[i].length * words[j].length
        max_prod = [max_prod, prod].max
      end
    end
  end
  max_prod
end

def max_product(words)
  # encode each word as bitmask
  masks = words.map do |word|
    word.each_char.reduce(0) { |mask, c| mask | (1 << (c.ord - 'a'.ord)) }
  end

  max_prod = 0
  n = words.length

  (0...n).each do |i|
    (i + 1...n).each do |j|
      if masks[i] & masks[j] == 0   # no common letters
        prod = words[i].length * words[j].length
        max_prod = [max_prod, prod].max
      end
    end
  end

  max_prod
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_product_brute(%w[abcw baz foo bar xtfn abcdef])}"  # 16
  puts "Opt:   #{max_product(%w[abcw baz foo bar xtfn abcdef])}"        # 16
  puts "Brute: #{max_product_brute(%w[a ab abc d cd bcd abcd])}"        # 4
  puts "Opt:   #{max_product(%w[a ab abc d cd bcd abcd])}"              # 4
end
