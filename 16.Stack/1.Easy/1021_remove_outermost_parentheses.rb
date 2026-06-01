# frozen_string_literal: true

# LeetCode 1021: Remove Outermost Parentheses
#
# Problem:
# A valid parentheses string is primitive if it cannot be split into non-empty valid parts.
# Remove the outermost parentheses of each primitive part and return the result.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Find all primitive components by scanning balance. Strip first and last char of each.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n). Count depth: chars at depth > 1 are kept (not outermost).
#
# 3. Optimized Accepted Approach
#    Track depth. Opening bracket: if depth > 0, keep; increment depth.
#    Closing bracket: decrement depth; if depth > 0, keep.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s = "(()())(())"
# '(': depth=0 -> skip, depth=1
# '(': depth=1 -> keep, depth=2
# ')': depth=2->1 -> keep
# '(': depth=1 -> keep, depth=2
# ')': depth=2->1 -> keep
# ')': depth=1->0 -> skip (outermost)
# '(': depth=0 -> skip, depth=1
# '(': depth=1 -> keep, depth=2
# ')': depth=2->1 -> keep
# ')': depth=1->0 -> skip
# Result: "()()()"
#
# Edge Cases:
# - Single primitive "()" -> ""
# - Deeply nested "((()))" -> "(())"

def remove_outer_parentheses_brute(s)
  result = []
  depth = 0
  s.each_char do |c|
    if c == '('
      result << c if depth > 0
      depth += 1
    else
      depth -= 1
      result << c if depth > 0
    end
  end
  result.join
end

# optimized: same depth-tracking approach (already O(n))
def remove_outer_parentheses(s)
  result = []
  opened = 0
  s.each_char do |c|
    if c == '('
      result << c if opened.positive?
      opened += 1
    else
      opened -= 1
      result << c if opened.positive?
    end
  end
  result.join
end

if __FILE__ == $PROGRAM_NAME
  puts remove_outer_parentheses_brute('(()())(())')  # "()()()"
  puts remove_outer_parentheses('(()())(())(()(()))')  # "()()()()(())"
end
