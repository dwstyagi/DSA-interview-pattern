# frozen_string_literal: true

# LeetCode 636: Exclusive Time of Functions
#
# Problem:
# Given n functions and logs [id:start/end:timestamp], return exclusive time for each function.
# Exclusive time excludes time spent in nested calls.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each function, sum time intervals not overlapped by other function calls.
#    Time Complexity: O(n * m) where m = log entries
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Stack naturally tracks the currently executing function. On new start,
#    credit elapsed time to current top, then push new. On end, pop and credit.
#
# 3. Optimized Accepted Approach
#    Stack of function ids. Track prev_time. On start: add (cur_time - prev_time)
#    to stack top, push new id, set prev_time. On end: add (cur_time - prev_time + 1),
#    pop, set prev_time = cur_time + 1.
#
#    Time Complexity: O(m)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=2, logs=["0:start:0","1:start:2","1:end:5","0:end:6"]
# "0:start:0": stack=[0], prev=0
# "1:start:2": result[0]+=2-0=2, stack=[0,1], prev=2
# "1:end:5":   result[1]+=5-2+1=4, pop -> stack=[0], prev=6
# "0:end:6":   result[0]+=6-6+1=1, pop -> stack=[], prev=7
# result=[3,4]
#
# Edge Cases:
# - Single function: result = its total time
# - Deeply nested: each inner function's time subtracted from outer

def exclusive_time_brute(n, logs)
  result = Array.new(n, 0)
  stack = []
  prev = 0
  logs.each do |log|
    id, type, time = log.split(':')
    id = id.to_i; time = time.to_i
    if type == 'start'
      result[stack.last] += time - prev unless stack.empty?
      stack << id
      prev = time
    else
      result[stack.pop] += time - prev + 1
      prev = time + 1
    end
  end
  result
end

# optimized: same stack simulation (already O(m))
def exclusive_time(n, logs)
  result = Array.new(n, 0)
  stack = []
  prev = 0
  logs.each do |log|
    parts = log.split(':')
    id = parts[0].to_i
    type = parts[1]
    time = parts[2].to_i
    if type == 'start'
      result[stack.last] += time - prev unless stack.empty?
      stack << id
      prev = time
    else
      result[stack.pop] += time - prev + 1
      prev = time + 1
    end
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  logs = ['0:start:0', '1:start:2', '1:end:5', '0:end:6']
  puts exclusive_time_brute(2, logs).inspect  # [3,4]
  puts exclusive_time(2, logs).inspect        # [3,4]
end
