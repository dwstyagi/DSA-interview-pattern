# frozen_string_literal: true

# LeetCode 682: Baseball Game
#
# Problem:
# Simulate a baseball game with operations: integer (record score), '+' (sum of last two),
# 'D' (double last), 'C' (remove last). Return sum of all recorded scores.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Use an array and simulate each operation directly.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already optimal. Stack naturally models the record.
#
# 3. Optimized Accepted Approach
#    Use a stack. Process each operation: integer -> push, '+' -> push sum of last 2,
#    'D' -> push double of last, 'C' -> pop last.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# ops = ["5","2","C","D","+"]
# "5": stack=[5]
# "2": stack=[5,2]
# "C": stack=[5]
# "D": stack=[5,10]
# "+": stack=[5,10,15]
# sum = 30
#
# Edge Cases:
# - Only integers: sum all
# - 'C' after 'D': removes the doubled value

def cal_points_brute(operations)
  stack = []
  operations.each do |op|
    case op
    when 'C' then stack.pop
    when 'D' then stack << stack.last * 2
    when '+' then stack << stack[-1] + stack[-2]
    else stack << op.to_i
    end
  end
  stack.sum
end

# optimized: same stack approach (already O(n))
def cal_points(operations)
  record = []
  operations.each do |op|
    case op
    when 'C' then record.pop
    when 'D' then record << record.last * 2
    when '+' then record << record[-1] + record[-2]
    else record << op.to_i
    end
  end
  record.sum
end

if __FILE__ == $PROGRAM_NAME
  puts cal_points_brute(%w[5 2 C D +])          # 30
  puts cal_points(%w[5 -2 4 C D 9 + +])         # 27
end
