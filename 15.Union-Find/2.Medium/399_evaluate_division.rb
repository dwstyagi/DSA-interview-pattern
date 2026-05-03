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
#    BFS for each query: find a path from numerator to denominator multiplying weights.
#    Time Complexity: O(Q * (V + E))
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    BFS repeated for each query. Union-Find with weighted edges can answer
#    each query in near O(1) after O(E) build.
#
# 3. Optimized Accepted Approach
#    BFS per query is already good. Build adjacency graph with reciprocal edges.
#    For each query BFS/DFS from src to dst multiplying weights.
#
#    Time Complexity: O((E + Q) * V)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# equations=[["a","b"],["b","c"]], values=[2.0,3.0]
# graph: a->b(2), b->a(0.5), b->c(3), c->b(1/3)
# query a/c: BFS a->b(2)->c(6) -> return 6.0
# query x/x: x not in graph -> return -1
#
# Edge Cases:
# - Same numerator and denominator: return 1.0 if variable known, else -1
# - Variable not in graph: return -1

def calc_equation_brute(equations, values, queries)
  graph = Hash.new { |h, k| h[k] = {} }
  equations.each_with_index do |(a, b), i|
    graph[a][b] = values[i]
    graph[b][a] = 1.0 / values[i]
  end

  bfs = lambda do |src, dst|
    return -1.0 unless graph.key?(src) && graph.key?(dst)
    return 1.0 if src == dst
    visited = Set.new
    queue = [[src, 1.0]]
    until queue.empty?
      node, prod = queue.shift
      return prod if node == dst
      next if visited.include?(node)
      visited.add(node)
      graph[node].each { |nb, w| queue << [nb, prod * w] unless visited.include?(nb) }
    end
    -1.0
  end

  queries.map { |src, dst| bfs.call(src, dst) }
end

# optimized: same BFS per query (standard accepted approach)
def calc_equation(equations, values, queries)
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

if __FILE__ == $PROGRAM_NAME
  eq = [%w[a b], %w[b c]]
  vals = [2.0, 3.0]
  queries = [%w[a c], %w[b a], %w[a e], %w[a a], %w[x x]]
  puts calc_equation_brute(eq, vals, queries).inspect
  puts calc_equation(eq, vals, queries).inspect
end
