# frozen_string_literal: true

# LeetCode 22: Generate Parentheses
#
# Problem:
# Given n pairs of parentheses, generate all combinations of well-formed
# parentheses.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all 2^(2n) strings of '(' and ')'. Filter valid ones.
#    Time Complexity: O(2^(2n) * n)
#    Space Complexity: O(2^(2n) * n)
#
# 2. Bottleneck
#    Generating invalid strings — constrained backtracking prunes early.
#
# 3. Optimized Accepted Approach
#    Backtracking with open/close counters. Add '(' if open < n.
#    Add ')' if close < open. String is complete when both reach n.
#    Time Complexity: O(4^n / sqrt(n)) — Catalan number
#    Space Complexity: O(n) recursion depth
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=2: start with open=0, close=0
# add '(': "(" open=1 → add '(': "((" open=2 → add ')': "(()" close=1
#   → add ')': "(())" close=2 → record ✓
# backtrack to "(": add ')': "()" close=1 → add '(': "()(" open=2
#   → add ')': "()()" → record ✓
# result=["(())","()()"] ✓
#
# Edge Cases:
# - n=0 -> [""] or [] depending on spec; n=1 -> ["()"]

def generate_parenthesis_brute(n)
  result = []
  # generate all 2^(2n) and filter
  (0...(1 << (2 * n))).each do |mask|
    s = (2*n).times.map { |i| mask[i] == 1 ? '(' : ')' }.join
    # validate
    balance = 0
    valid   = true
    s.each_char { |c| c == '(' ? balance += 1 : balance -= 1; valid = false if balance < 0 }
    result << s if valid && balance.zero?
  end
  result
end

def generate_parenthesis(n)
  result = []

  backtrack = lambda do |current, open, close|
    if current.length == 2 * n
      result << current  # complete valid string
      return
    end

    backtrack.call(current + '(', open + 1, close) if open < n        # can add open
    backtrack.call(current + ')', open, close + 1) if close < open    # can add close
  end

  backtrack.call('', 0, 0)
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{generate_parenthesis_brute(3).sort.inspect}"  # ["((()))","(()())","(())()","()(())","()()()"]
  puts "Opt:   #{generate_parenthesis(3).sort.inspect}"          # same
  puts "Opt n=1: #{generate_parenthesis(1).inspect}"             # ["()"]
end
