# frozen_string_literal: true

# LeetCode 739: Daily Temperatures
#
# Problem:
# Given temperatures array, return an array where result[i] = number of days
# until a warmer temperature. If no future warmer day, result[i] = 0.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each day, scan forward until finding a warmer day.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. Monotonic decreasing stack stores indices of unresolved days.
#    When a warmer day is found, resolve all cooler days in the stack.
#
# 3. Optimized Accepted Approach
#    Monotonic decreasing stack of indices. For each temp, while stack top's temp
#    is less than current, pop and set result[top] = i - top.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# temps = [73,74,75,71,69,72,76,73]
# i=0(73): stack=[0]
# i=1(74): 74>73 -> result[0]=1, pop; push 1 -> stack=[1]
# i=2(75): 75>74 -> result[1]=1, pop; push 2 -> stack=[2]
# i=3(71): push 3 -> [2,3]
# i=4(69): push 4 -> [2,3,4]
# i=5(72): 72>69 -> result[4]=1; 72>71 -> result[3]=2; push 5 -> [2,5]
# i=6(76): 76>72 -> result[5]=1; 76>75 -> result[2]=4; push 6 -> [6]
# i=7(73): push 7 -> [6,7]
# Remaining: result[6]=0, result[7]=0
# Result: [1,1,4,2,1,1,0,0]
#
# Edge Cases:
# - Monotonically decreasing: all zeros
# - Single element: [0]

def daily_temperatures_brute(temperatures)
  n = temperatures.length
  result = Array.new(n, 0)
  n.times do |i|
    (i + 1...n).each do |j|
      if temperatures[j] > temperatures[i]
        result[i] = j - i
        break
      end
    end
  end
  result
end

def daily_temperatures(temperatures)
  result = Array.new(temperatures.length, 0)
  stack = []
  temperatures.each_with_index do |temp, i|
    while !stack.empty? && temperatures[stack.last] < temp
      j = stack.pop
      result[j] = i - j
    end
    stack << i
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts daily_temperatures_brute([73, 74, 75, 71, 69, 72, 76, 73]).inspect
  # [1,1,4,2,1,1,0,0]
  puts daily_temperatures([30, 40, 50, 60]).inspect
  # [1,1,1,0]
end
