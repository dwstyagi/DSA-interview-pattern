# frozen_string_literal: true

# LeetCode 227: Basic Calculator II
#
# Problem:
# Evaluate a string expression with +, -, *, / (no parentheses).
# Integers are non-negative. Spaces allowed.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Split by +/- then evaluate multiplication/division within each chunk.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n). Stack approach is clean: handle * and / immediately,
#    defer + and - by pushing signed values.
#
# 3. Optimized Accepted Approach
#    Scan with current number and last operator. On new operator or end:
#    '+'/'-': push ±num to stack. '*': pop, multiply, push. '/': pop, divide, push.
#    Sum the stack at end.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "3+2*2"
# '3' -> num=3; '+' -> push 3, op='+'; '2' -> num=2; '*' -> op='*'; '2' -> num=2
# end: op='*' -> pop 2, push 2*2=4
# stack=[3,4], sum=7
#
# Edge Cases:
# - Single number: return it
# - Division truncation toward zero

def calculate_brute(s)
  eval(s.gsub('/', '.to_f/').gsub(/(\d+\.to_f\/\d+)/) { eval($1).truncate }) # rubocop:disable Security/Eval
rescue StandardError
  s.to_i
end

def calculate(s)
  stack = []
  num = 0
  op = '+'
  s.gsub(' ', '').each_char.with_index do |c, i|
    num = num * 10 + c.to_i if c =~ /\d/
    if (c =~ /[+\-*\/]/ || i == s.gsub(' ', '').length - 1)
      case op
      when '+' then stack << num
      when '-' then stack << -num
      when '*' then stack << stack.pop * num
      when '/' then stack << (stack.pop.to_f / num).truncate
      end
      op = c
      num = 0
    end
  end
  stack.sum
end

if __FILE__ == $PROGRAM_NAME
  puts calculate('3+2*2')       # 7
  puts calculate(' 3/2 ')       # 1
  puts calculate(' 3+5 / 2 ')   # 5
end
