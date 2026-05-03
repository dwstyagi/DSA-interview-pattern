# frozen_string_literal: true

# LeetCode 1584: Min Cost to Connect All Points
#
# Problem:
# You are given an array of points where points[i] = [xi, yi].
# The cost to connect two points is the Manhattan distance between them.
# Return the minimum cost to make all points connected (minimum spanning tree).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Generate all possible edges (n*(n-1)/2).
#    Sort them by cost.
#    Use Union-Find to add cheapest edges that don't form cycles (Kruskal's).
#
#    Time Complexity: O(n^2 log n)
#    Space Complexity: O(n^2)
#
# 2. Bottleneck
#    Storing all n^2 edges uses too much memory for large n.
#    Prim's algorithm avoids materializing all edges — expand MST greedily.
#
# 3. Optimized Accepted Approach
#    Prim's algorithm with O(n^2) dense-graph optimization:
#    - Keep min_dist[] = min cost to add each unvisited node to MST
#    - At each step, pick the unvisited node with smallest min_dist
#    - Update neighbors' min_dist with Manhattan distance to picked node
#    - Total cost accumulates
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# points = [[0,0],[2,2],[3,10],[5,2],[7,0]]
#
# Start at 0: min_dist = [0, 4, 13, 7, 7]
# Pick node 1 (cost 4): min_dist = [-, -, 11, 5, 9]  total=4
# Pick node 3 (cost 5): min_dist = [-, -, 9, -, 4]   total=9
# Pick node 4 (cost 4): min_dist = [-, -, 7, -, -]   total=13
# Pick node 2 (cost 7): total=20 ✓
#
# Edge Cases:
# - n=1 -> return 0 (no connections needed)
# - All points same -> all distances 0

def min_cost_connect_points_brute(points)
  n = points.length
  return 0 if n <= 1

  # generate all edges
  edges = []
  (0...n).each do |i|
    ((i + 1)...n).each do |j|
      dist = (points[i][0] - points[j][0]).abs + (points[i][1] - points[j][1]).abs
      edges << [dist, i, j]
    end
  end

  edges.sort_by!(&:first)

  # Kruskal's with Union-Find
  parent = Array.new(n) { |i| i }
  rank = Array.new(n, 0)

  find = lambda do |x|
    parent[x] = find.call(parent[x]) if parent[x] != x
    parent[x]
  end

  union = lambda do |x, y|
    px, py = find.call(x), find.call(y)
    return false if px == py

    if rank[px] < rank[py]
      parent[px] = py
    elsif rank[px] > rank[py]
      parent[py] = px
    else
      parent[py] = px
      rank[px] += 1
    end
    true
  end

  total = 0
  edges_used = 0

  edges.each do |cost, u, v|
    next unless union.call(u, v)

    total += cost
    edges_used += 1
    break if edges_used == n - 1
  end

  total
end

def min_cost_connect_points(points)
  n = points.length
  return 0 if n <= 1

  min_dist = Array.new(n, Float::INFINITY)
  in_mst = Array.new(n, false)
  min_dist[0] = 0
  total = 0

  n.times do
    # pick unvisited node with smallest min_dist
    u = -1
    (0...n).each do |i|
      u = i if !in_mst[i] && (u == -1 || min_dist[i] < min_dist[u])
    end

    in_mst[u] = true
    total += min_dist[u]

    # update neighbors
    (0...n).each do |v|
      next if in_mst[v]

      dist = (points[u][0] - points[v][0]).abs + (points[u][1] - points[v][1]).abs
      min_dist[v] = dist if dist < min_dist[v]
    end
  end

  total
end

if __FILE__ == $PROGRAM_NAME
  points = [[0, 0], [2, 2], [3, 10], [5, 2], [7, 0]]

  puts "Brute:     #{min_cost_connect_points_brute(points)}"
  puts "Optimized: #{min_cost_connect_points(points)}"
end
