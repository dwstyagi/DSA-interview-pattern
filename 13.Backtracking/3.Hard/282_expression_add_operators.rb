# frozen_string_literal: true

# LeetCode 282: Expression Add Operators
#
# Problem:
# Given a string num of digits and an integer target, return all possibilities
# to insert +, -, or * between digits so the expression evaluates to target.
# No leading zeros are allowed in any number operand.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all possible expressions by inserting operators between every
#    pair of digits. Evaluate each expression string using eval.
#    Time Complexity: O(4^n * n) — 3 operators or no-op (multi-digit) per gap
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    String eval is slow. Carry the running total and the last operand to
#    handle multiplication (undo last addition/subtraction then multiply).
#
# 3. Optimized Accepted Approach
#    Backtracking with running eval. Track:
#    - pos: current index in num
#    - expr: expression string built so far
#    - eval_val: current evaluated value
#    - mult: last operand (to undo for *)
#
#    Time Complexity: O(4^n * n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# num = "123", target = 6
# pos=0, take "1"
#   pos=1, eval=1, mult=1, take "2"
#     pos=2, "1+2", eval=3, mult=2, take "3"
#       pos=3 == end: eval=3+3=6 == target -> add "1+2+3"
#     "1+2*3": eval=1+2*3-2+2*3=... undo 2, add 2*3=6, eval=7 -> no
#     "1+2-3": eval=0 -> no
#     take "23": pos=3, "1+23" eval=24 -> no
#   "1-2", "1*2", "123" similarly explored
#
# Edge Cases:
# - Leading zeros: "05" invalid, but "0" alone is ok
# - Single digit: no operators, just check digit == target

def add_operators_brute(num, target)
  results = []

  explore = lambda do |pos, expr|
    if pos == num.length
      results << expr if eval(expr) == target # rubocop:disable Security/Eval
      return
    end
    (pos...num.length).each do |end_pos|
      token = num[pos..end_pos]
      next if token.length > 1 && token[0] == '0' # leading zero
      if expr.empty?
        explore.call(end_pos + 1, token)
      else
        ['+', '-', '*'].each do |op|
          explore.call(end_pos + 1, expr + op + token)
        end
      end
    end
  end

  explore.call(0, '')
  results
end

# optimized: backtracking carrying running eval and last multiplicand
def add_operators(num, target)
  results = []

  backtrack = lambda do |pos, expr, eval_val, mult|
    if pos == num.length
      results << expr if eval_val == target
      return
    end
    (pos...num.length).each do |fin|
      token = num[pos..fin]
      next if token.length > 1 && token[0] == '0'
      cur = token.to_i
      if pos == 0
        backtrack.call(fin + 1, token, cur, cur)
      else
        # addition
        backtrack.call(fin + 1, "#{expr}+#{token}", eval_val + cur, cur)
        # subtraction
        backtrack.call(fin + 1, "#{expr}-#{token}", eval_val - cur, -cur)
        # multiplication: undo last operand, apply mult
        backtrack.call(fin + 1, "#{expr}*#{token}", eval_val - mult + mult * cur, mult * cur)
      end
    end
  end

  backtrack.call(0, '', 0, 0)
  results
end

if __FILE__ == $PROGRAM_NAME
  num = '123'
  target = 6
  puts "Brute force: #{add_operators_brute(num, target)}"
  puts "Optimized:   #{add_operators(num, target)}"
end
