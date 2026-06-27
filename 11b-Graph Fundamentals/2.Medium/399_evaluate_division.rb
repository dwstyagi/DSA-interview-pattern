# frozen_string_literal: true

# 399. Evaluate Division
#
# 1. Problem Statement
#
# Given equations such as a / b = 2.0, answer division queries. Return -1.0
# when a query cannot be determined.
#
# 2. Brute Force Approach
#
# Intuition:
# Repeatedly substitute known equations until a query's variables become
# directly related.
#
# Algorithm:
# For each query, scan all equations again and again while trying to build a
# chain from numerator to denominator.
#
# Time Complexity: O(q * e^2) in the worst case.
# Space Complexity: O(e)

# 3. Brute Force Code
def calc_equation_brute(equations, values, queries)
  graph = division_graph(equations, values)
  queries.map { |from, to| brute_division_search(graph, from, to) }
end

# 4. Bottleneck Analysis
#
# The brute-force approach repeatedly scans equations looking for the next
# usable substitution. Equations naturally form a weighted graph, where each
# edge already contains the multiplication needed to extend a chain.
#
# 5. Optimization Journey
#
# For equation a / b = value:
# - Add a -> b with weight value.
# - Add b -> a with weight 1 / value.
#
# A DFS from query source carries a product. When it reaches the target, that
# product is the answer. Each query now visits only connected variables.
#
# 6. Dry Run
#
# a / b = 2, b / c = 3; query a / c:
# - Start at a with product 1.
# - Move a -> b: product 1 * 2 = 2.
# - Move b -> c: product 2 * 3 = 6.
# - Answer is 6.
#
# 7. Optimal Solution
#
# Build a weighted adjacency list once, then DFS for each query.
#
# Time Complexity: O(E + Q * (V + E))
# Space Complexity: O(E)

# 8. Optimal Code
def calc_equation(equations, values, queries)
  graph = division_graph(equations, values)
  queries.map { |from, to| weighted_dfs(graph, from, to) }
end

def division_graph(equations, values)
  graph = Hash.new { |hash, key| hash[key] = [] }
  equations.each_with_index do |(from, to), index|
    value = values[index]
    graph[from] << [to, value]
    graph[to] << [from, 1.0 / value]
  end
  graph
end

def brute_division_search(graph, from, to)
  return -1.0 unless graph.key?(from) && graph.key?(to)
  return 1.0 if from == to

  frontier = [[from, 1.0]]
  visited = { from => true }
  until frontier.empty?
    node, product = frontier.shift
    return product if node == to

    graph[node].each do |neighbor, weight|
      next if visited[neighbor]

      visited[neighbor] = true
      frontier << [neighbor, product * weight]
    end
  end
  -1.0
end

def weighted_dfs(graph, from, to)
  return -1.0 unless graph.key?(from) && graph.key?(to)
  return 1.0 if from == to

  stack = [[from, 1.0]]
  visited = { from => true }
  until stack.empty?
    node, product = stack.pop
    return product if node == to

    graph[node].each do |neighbor, weight|
      next if visited[neighbor]

      visited[neighbor] = true
      stack << [neighbor, product * weight]
    end
  end
  -1.0
end

# Examples
if __FILE__ == $PROGRAM_NAME
  equations = [['a', 'b'], ['b', 'c']]
  values = [2.0, 3.0]
  queries = [['a', 'c'], ['b', 'a'], ['a', 'e']]
  p calc_equation_brute(equations, values, queries) # [6.0, 0.5, -1.0]
  p calc_equation(equations, values, queries) # [6.0, 0.5, -1.0]
end
