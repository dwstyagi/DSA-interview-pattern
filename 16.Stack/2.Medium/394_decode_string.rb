# frozen_string_literal: true

# LeetCode 394: Decode String
#
# Problem:
# Given encoded string like "3[a]2[bc]", return decoded "aaabcbc".
# Encoding is k[encoded_string] where k is a positive integer.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Repeatedly find innermost k[...] pattern and expand it.
#    Time Complexity: O(n * max_k) worst case
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Regex replacement is repeated. Stack handles nested brackets naturally.
#
# 3. Optimized Accepted Approach
#    Stack-based: push chars onto stack. On ']', pop until '[', get string,
#    pop the number, push repeated string back.
#
#    Time Complexity: O(n * max_k)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "3[a2[c]]"
# push 3, [, a, 2, [, c
# ']': pop until '[' -> "c", pop '2' -> repeat "cc", push back
# stack: [3, [, a, c, c]
# ']': pop until '[' -> "acc", pop '3' -> repeat "accaccacc"
# Result: "accaccacc"
#
# Edge Cases:
# - No brackets: return s as-is
# - Nested brackets: handled by stack LIFO

def decode_string_brute(s)
  str = s.dup
  while str.include?('[')
    str.gsub!(/(\d+)\[([a-z]*)\]/) { $2 * $1.to_i }
  end
  str
end

def decode_string(s)
  stack = []
  s.each_char do |c|
    if c == ']'
      letters = []
      letters.unshift(stack.pop) while stack.last != '['
      stack.pop # remove '['
      num = []
      num.unshift(stack.pop) while !stack.empty? && stack.last.match?(/\d/)
      stack << (letters.join * num.join.to_i)
    else
      stack << c
    end
  end
  stack.join
end

if __FILE__ == $PROGRAM_NAME
  puts decode_string_brute('3[a]2[bc]')   # "aaabcbc"
  puts decode_string('3[a2[c]]')           # "accaccacc"
end
