# frozen_string_literal: true

# LeetCode 399: Evaluate Division
#
# Problem:
# Given equations a/b = k, evaluate queries c/d. Return -1 if unknown.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS for each query from numerator to denominator, multiply edge weights.
#    Time Complexity: O(Q * (V + E))
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    BFS per query is adequate. Build weighted adjacency graph once.
#
# 3. Optimized Accepted Approach
#    Build bidirectional graph. For each query BFS/DFS from src to dst.
#    Multiply weights along path. Return -1 if disconnected.
#
#    Time Complexity: O(E + Q * V)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# equations=[["a","b"],["b","c"]], values=[2.0,3.0], queries=[["a","c"],["b","a"]]
# graph: a->b(2), b->a(0.5), b->c(3), c->b(1/3)
# BFS a->c: a-b(2.0) -> b-c(3.0) -> return 6.0
# BFS b->a: b-a(0.5) -> return 0.5
#
# Edge Cases:
# - Query same var: return 1.0 if in graph, -1 if not
# - Disconnected vars: -1

def calc_equation_brute(equations, values, queries)
  graph = Hash.new { |h, k| h[k] = {} }
  equations.each_with_index do |(a, b), i|
    graph[a][b] = values[i]
    graph[b][a] = 1.0 / values[i]
  end
  queries.map do |src, dst|
    next -1.0 unless graph.key?(src) && graph.key?(dst)
    next 1.0 if src == dst
    visited = Set.new
    queue = [[src, 1.0]]
    result = -1.0
    until queue.empty?
      node, prod = queue.shift
      if node == dst
        result = prod
        break
      end
      next if visited.include?(node)
      visited.add(node)
      graph[node].each { |nb, w| queue << [nb, prod * w] unless visited.include?(nb) }
    end
    result
  end
end

# optimized: same BFS per query
def calc_equation(equations, values, queries)
  calc_equation_brute(equations, values, queries)
end

if __FILE__ == $PROGRAM_NAME
  eq = [%w[a b], %w[b c]]
  vals = [2.0, 3.0]
  queries = [%w[a c], %w[b a], %w[a e], %w[a a], %w[x x]]
  puts calc_equation(eq, vals, queries).inspect
end
