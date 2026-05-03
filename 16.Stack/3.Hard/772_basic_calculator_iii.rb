# frozen_string_literal: true

# LeetCode 772: Basic Calculator III
#
# Problem:
# Evaluate a string with +, -, *, / and parentheses. Integers can be negative.
# Division truncates toward zero.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive descent parser.
#    Time Complexity: O(n)
#    Space Complexity: O(n) recursion depth
#
# 2. Bottleneck
#    Recursive parsing is clean. Iterative stack with operator precedence also works.
#
# 3. Optimized Accepted Approach
#    Recursive descent: parse_expr handles + and -; parse_term handles * and /;
#    parse_factor handles numbers and parenthesized expressions.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "2*(3+4)/2"
# parse_factor: 2
# '*': parse_term -> parse_factor('(') -> parse_expr: 3+4=7 -> ')'=7
# 2*7=14; '/': parse_factor=2; 14/2=7
# Result: 7
#
# Edge Cases:
# - Nested parentheses: recursive calls handle depth
# - Negative results from division: truncate toward zero

def calculate_iii(s)
  i = 0
  s = s.gsub(' ', '')

  parse_factor = lambda do
    if s[i] == '('
      i += 1  # consume '('
      val = parse_expr.call
      i += 1  # consume ')'
      val
    else
      neg = 1
      if s[i] == '-'
        neg = -1
        i += 1
      end
      start = i
      i += 1 while i < s.length && s[i] =~ /\d/
      neg * s[start...i].to_i
    end
  end

  parse_term = lambda do
    val = parse_factor.call
    while i < s.length && (s[i] == '*' || s[i] == '/')
      op = s[i]
      i += 1
      right = parse_factor.call
      val = op == '*' ? val * right : (val.to_f / right).truncate
    end
    val
  end

  parse_expr = lambda do
    val = parse_term.call
    while i < s.length && (s[i] == '+' || s[i] == '-')
      op = s[i]
      i += 1
      right = parse_term.call
      val = op == '+' ? val + right : val - right
    end
    val
  end

  parse_expr.call
end

def calculate_iii_brute(s)
  calculate_iii(s)
end

if __FILE__ == $PROGRAM_NAME
  puts calculate_iii('2*(3+4)/2')     # 7
  puts calculate_iii('1+2*3')         # 7
  puts calculate_iii('(2+6*3+5-(3*14/7+2)*5)+3')  # -12
end
