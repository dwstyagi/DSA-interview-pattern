# frozen_string_literal: true

# LeetCode 17: Letter Combinations of a Phone Number
#
# Problem:
# Given a string containing digits 2-9, return all possible letter combinations
# that the number could represent (phone keypad mapping).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS: start with [""], for each digit append all its letters to each current string.
#    Time Complexity: O(4^n * n) — some digits map to 4 letters
#    Space Complexity: O(4^n * n)
#
# 2. Bottleneck
#    BFS builds up to 4^n strings — backtracking is equivalent but uses O(n) stack.
#
# 3. Optimized Accepted Approach
#    Backtracking: at each position, try each letter for the current digit.
#    When path.length == digits.length, record.
#    Time Complexity: O(4^n * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# digits="23"
# digit '2' → letters "abc"; digit '3' → letters "def"
# branch 'a': branch 'd'→"ad" ✓, 'e'→"ae" ✓, 'f'→"af" ✓
# branch 'b': "bd","be","bf"
# branch 'c': "cd","ce","cf"
# result=["ad","ae","af","bd","be","bf","cd","ce","cf"] ✓
#
# Edge Cases:
# - Empty string -> []
# - Single digit -> its letters as individual strings

PHONE_MAP = {
  '2' => 'abc', '3' => 'def', '4' => 'ghi',
  '5' => 'jkl', '6' => 'mno', '7' => 'pqrs',
  '8' => 'tuv', '9' => 'wxyz'
}.freeze

def letter_combinations_brute(digits)
  return [] if digits.empty?
  result = [""]
  digits.each_char { |d| result = result.flat_map { |s| PHONE_MAP[d].chars.map { |c| s + c } } }
  result
end

def letter_combinations(digits)
  return [] if digits.empty?
  result = []

  backtrack = lambda do |idx, path|
    if idx == digits.length
      result << path.join   # complete combination
      return
    end

    PHONE_MAP[digits[idx]].each_char do |ch|
      path << ch
      backtrack.call(idx + 1, path)
      path.pop
    end
  end

  backtrack.call(0, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{letter_combinations_brute('23').sort.inspect}"
  puts "Opt:   #{letter_combinations('23').sort.inspect}"
  # ["ad","ae","af","bd","be","bf","cd","ce","cf"]
  puts "Opt empty: #{letter_combinations('').inspect}"  # []
end
