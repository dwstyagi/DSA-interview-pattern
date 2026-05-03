# frozen_string_literal: true

# LeetCode 279: Perfect Squares
#
# Problem:
# Given an integer n, return the least number of perfect square numbers that
# sum to n.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Recursive: try subtracting each square < n, recurse. Exponential.
#    Time Complexity: O(n^(n/2)) exponential without memoization
#    Space Complexity: O(n) recursion depth
#
# 2. Bottleneck
#    Exponential recursion — DP or BFS on number graph.
#
# 3. Optimized Accepted Approach
#    BFS: each level represents adding one more perfect square. Start at 0,
#    find target n. Level count = minimum squares needed.
#    (Alternatively, DP dp[i] = min(dp[i-j*j]+1 for all j^2 <= i).)
#    Time Complexity: O(n * sqrt(n))
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=12: squares=[1,4,9]
# BFS level 0: {0}
# level 1: {1,4,9}
# level 2: {2,5,8,13?,3,6,10,8...} → {2,3,5,6,8,10,13,...}
# level 3: {12 found via 4+4+4} → return 3 ✓
#
# Edge Cases:
# - n=1 -> 1
# - n=4 -> 1 (4 is a perfect square)
# - n=13 -> 2 (4+9)

def num_squares_brute(n)
  dp = Array.new(n + 1, Float::INFINITY)
  dp[0] = 0
  squares = (1..Math.sqrt(n).to_i).map { |i| i * i }

  (1..n).each do |i|
    squares.each do |sq|
      break if sq > i
      dp[i] = [dp[i], dp[i - sq] + 1].min
    end
  end

  dp[n]
end

def num_squares(n)
  squares = (1..Math.sqrt(n).to_i).map { |i| i * i }
  visited = Array.new(n + 1, false)
  queue   = [0]
  visited[0] = true
  level   = 0

  until queue.empty?
    queue.size.times do
      curr = queue.shift
      squares.each do |sq|
        next_val = curr + sq
        return level + 1 if next_val == n
        next if next_val > n || visited[next_val]
        visited[next_val] = true
        queue << next_val
      end
    end
    level += 1
  end

  level
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{num_squares_brute(12)}"   # 3
  puts "Opt:   #{num_squares(12)}"          # 3
  puts "Brute: #{num_squares_brute(13)}"   # 2
  puts "Opt:   #{num_squares(13)}"          # 2
end
