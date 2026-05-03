# frozen_string_literal: true

# LeetCode 150: Evaluate Reverse Polish Notation
#
# Problem:
# Evaluate an expression in Reverse Polish Notation (postfix). Operators: +, -, *, /.
# Division truncates toward zero.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find innermost operator with two preceding numbers, evaluate, replace, repeat.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Scanning for operators is wasteful. Stack naturally evaluates RPN in one pass.
#
# 3. Optimized Accepted Approach
#    Stack: push numbers. On operator, pop two operands, compute, push result.
#    Division truncates toward zero: use Integer(a/b.to_f) or (a/b).truncate.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# tokens = ["2","1","+","3","*"]
# "2": stack=[2]
# "1": stack=[2,1]
# "+": pop 1,2 -> 3 -> stack=[3]
# "3": stack=[3,3]
# "*": pop 3,3 -> 9 -> stack=[9]
# Result: 9
#
# Edge Cases:
# - Single number: return it
# - Division truncation: 6/-132 = 0 (toward zero)

OPS = %w[+ - * /].freeze

def eval_rpn_brute(tokens)
  toks = tokens.dup
  while toks.length > 1
    i = toks.index { |t| OPS.include?(t) }
    a, b = toks[i - 2].to_i, toks[i - 1].to_i
    result = case toks[i]
             when '+' then a + b
             when '-' then a - b
             when '*' then a * b
             when '/' then (a.to_f / b).truncate
             end
    toks[i - 2..i] = [result.to_s]
  end
  toks[0].to_i
end

def eval_rpn(tokens)
  stack = []
  tokens.each do |t|
    if OPS.include?(t)
      b, a = stack.pop, stack.pop
      stack << case t
               when '+' then a + b
               when '-' then a - b
               when '*' then a * b
               when '/' then (a.to_f / b).truncate
               end
    else
      stack << t.to_i
    end
  end
  stack[0]
end

if __FILE__ == $PROGRAM_NAME
  puts eval_rpn_brute(%w[2 1 + 3 *])                # 9
  puts eval_rpn(%w[4 13 5 / +])                     # 6
  puts eval_rpn(%w[10 6 9 3 + -11 * / * 17 + 5 +]) # 22
end
