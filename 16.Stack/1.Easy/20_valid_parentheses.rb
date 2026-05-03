# frozen_string_literal: true

# LeetCode 20: Valid Parentheses
#
# Problem:
# Given a string of brackets '(', ')', '{', '}', '[', ']', return true if valid.
# Valid means every open bracket closed in correct order.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Repeatedly remove matched pairs "()", "[]", "{}" until no change. Valid if empty.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. A stack naturally matches opening/closing brackets in O(n).
#
# 3. Optimized Accepted Approach
#    Push opening brackets. On closing bracket, check top of stack matches. Pop if so.
#    Valid if stack empty at end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "()[]{}"
# '(' -> push; ')' -> top='(' -> pop -> stack=[]
# '[' -> push; ']' -> top='[' -> pop -> stack=[]
# '{' -> push; '}' -> top='{' -> pop -> stack=[]
# Result: true
#
# s = "([)]"
# '(' push, '[' push, ')' -> top='[' != '(' -> false
#
# Edge Cases:
# - Empty string: true
# - Single bracket: false
# - All opening: false

def is_valid_brute?(s)
  str = s.dup
  prev = nil
  while str != prev
    prev = str
    str = str.gsub('()', '').gsub('[]', '').gsub('{}', '')
  end
  str.empty?
end

def is_valid?(s)
  stack = []
  match = { ')' => '(', ']' => '[', '}' => '{' }
  s.each_char do |c|
    if match.key?(c)
      return false if stack.empty? || stack.last != match[c]
      stack.pop
    else
      stack << c
    end
  end
  stack.empty?
end

if __FILE__ == $PROGRAM_NAME
  puts is_valid_brute?('()[]{}'.dup)  # true
  puts is_valid?('([)]')              # false
end
