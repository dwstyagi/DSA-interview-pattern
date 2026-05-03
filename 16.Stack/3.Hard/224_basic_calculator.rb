# frozen_string_literal: true

# LeetCode 224: Basic Calculator
#
# Problem:
# Evaluate a string expression with +, -, (, ) and non-negative integers.
# No * or / operators.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursively evaluate innermost parentheses first.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Stack-based: when '(' encountered, push current result and sign, reset.
#    On ')' pop and combine.
#
# 3. Optimized Accepted Approach
#    Track result, sign (+1/-1), and stack. On '(': push result and sign, reset.
#    On ')': pop sign and prev_result, combine. Digits accumulate as num.
#    On '+'/'-': add sign*num to result.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "1 + (2 - (3 + 4))"
# result=0, sign=1
# '1': num=1
# '+': result+=1*1=1, sign=1
# '(': push 1, push 1 -> stack=[1,1], result=0, sign=1
# '2': num=2
# '-': result+=1*2=2, sign=-1
# '(': push 2, push -1 -> stack=[1,1,2,-1], result=0, sign=1
# '3': num=3; '+': result=3, sign=1; '4': num=4
# ')': result+=1*4=7; pop sign=-1, pop prev=2 -> result=-1*7+2=-5
# ')': pop sign=1, pop prev=1 -> result=1*(-5)+1=-4
# Result: -4
#
# Edge Cases:
# - No parentheses: simple left-to-right
# - Nested parentheses: stack handles arbitrary depth

def calculate_brute(s)
  eval(s) # rubocop:disable Security/Eval
end

def calculate(s)
  stack = []
  result = 0
  sign = 1
  num = 0
  s.each_char do |c|
    if c =~ /\d/
      num = num * 10 + c.to_i
    elsif c == '+'
      result += sign * num
      num = 0
      sign = 1
    elsif c == '-'
      result += sign * num
      num = 0
      sign = -1
    elsif c == '('
      stack << result
      stack << sign
      result = 0
      sign = 1
    elsif c == ')'
      result += sign * num
      num = 0
      result *= stack.pop  # sign before '('
      result += stack.pop  # result before '('
    end
  end
  result + sign * num
end

if __FILE__ == $PROGRAM_NAME
  puts calculate('1 + 1')           # 2
  puts calculate(' 2-1 + 2 ')       # 3
  puts calculate('(1+(4+5+2)-3)+(6+8)')  # 23
end
