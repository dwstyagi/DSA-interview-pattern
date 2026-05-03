# frozen_string_literal: true

# LeetCode 509: Fibonacci Number
#
# Problem:
# Given n, return F(n) where F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2) for n>=2.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive: fib(n) = fib(n-1) + fib(n-2).
#    Time Complexity: O(2^n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Recomputes same values. Memoize or bottom-up DP. Can do O(1) space.
#
# 3. Optimized Accepted Approach
#    Iterative: track prev2 and prev1. Update: prev2, prev1 = prev1, prev1+prev2.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=5: prev2=0, prev1=1
# step: 1,1 -> 1,2 -> 2,3 -> 3,5
# result: 5
#
# Edge Cases:
# - n=0: 0
# - n=1: 1

def fib_brute(n)
  return n if n <= 1
  fib_brute(n - 1) + fib_brute(n - 2)
end

def fib(n)
  return n if n <= 1
  prev2 = 0
  prev1 = 1
  (2..n).each { prev2, prev1 = prev1, prev1 + prev2 }
  prev1
end

if __FILE__ == $PROGRAM_NAME
  puts fib_brute(10)  # 55
  puts fib(30)        # 832040
end
