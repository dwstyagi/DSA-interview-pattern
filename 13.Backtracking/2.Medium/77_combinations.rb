# frozen_string_literal: true

# LeetCode 77: Combinations
#
# Problem:
# Given two integers n and k, return all possible combinations of k numbers
# chosen from the range [1, n].
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    (1..n).to_a.combination(k).to_a
#    Time Complexity: O(C(n,k) * k)
#    Space Complexity: O(C(n,k) * k)
#
# 2. Bottleneck
#    Same complexity — explicit backtracking allows early pruning (remaining elements).
#
# 3. Optimized Accepted Approach
#    Backtracking with start index. Pruning: if remaining slots > remaining numbers,
#    skip (hi = n - (k - path.size) + 1 as upper bound for i).
#    Time Complexity: O(C(n,k) * k)
#    Space Complexity: O(k) recursion depth
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4, k=2: (1..4).combination(2) = [1,2],[1,3],[1,4],[2,3],[2,4],[3,4] ✓
# Backtrack: start=1,path=[]; i=1→path=[1],start=2; i=2→[1,2] record; pop; i=3→[1,3]...
#
# Edge Cases:
# - k=1 -> [[1],[2],...,[n]]
# - k=n -> [[1,2,...,n]]

def combine_brute(n, k)
  (1..n).to_a.combination(k).to_a
end

def combine(n, k)
  result = []

  backtrack = lambda do |start, path|
    result << path.dup and return if path.length == k

    # Pruning: only iterate up to n - (k - path.size) + 1
    upper = n - (k - path.length) + 1
    (start..upper).each do |i|
      path << i
      backtrack.call(i + 1, path)
      path.pop
    end
  end

  backtrack.call(1, [])
  result
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{combine_brute(4, 2).length}"   # 6
  puts "Opt:   #{combine(4, 2).sort.inspect}"    # [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
end
