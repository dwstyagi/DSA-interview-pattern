# frozen_string_literal: true

# LeetCode 684: Redundant Connection
#
# Problem:
# Graph that was a tree with one extra edge added. Return the redundant edge.
# If multiple answers, return the last one.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Remove each edge, check if graph stays connected. Return last edge whose
#    removal still leaves a tree.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Union-Find: process edges in order; return first edge where both nodes
#    already have the same root (cycle-creating edge).
#
# 3. Optimized Accepted Approach
#    Union-Find with path compression and union by rank.
#
#    Time Complexity: O(n * alpha(n))
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# edges=[[1,2],[1,3],[2,3]]
# union(1,2): ok; union(1,3): ok; union(2,3): find(2)=root=find(3) -> return [2,3]
#
# Edge Cases:
# - Minimum 3 nodes: one cycle edge

def find_redundant_connection_brute(edges)
  n = edges.length
  edges.reverse.each do |skip|
    parent = Array.new(n + 1) { |i| i }
    find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
    connected = 0
    edges.each do |e|
      next if e == skip
      pu, pv = find.call(e[0]), find.call(e[1])
      unless pu == pv
        parent[pu] = pv
        connected += 1
      end
    end
    return skip if connected == n - 1
  end
  []
end

def find_redundant_connection(edges)
  n = edges.length
  parent = Array.new(n + 1) { |i| i }
  rank = Array.new(n + 1, 0)
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  edges.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    return [u, v] if pu == pv
    if rank[pu] < rank[pv] then parent[pu] = pv
    elsif rank[pu] > rank[pv] then parent[pv] = pu
    else parent[pv] = pu; rank[pu] += 1
    end
  end
  []
end

if __FILE__ == $PROGRAM_NAME
  puts find_redundant_connection_brute([[1, 2], [1, 3], [2, 3]]).inspect  # [2,3]
  puts find_redundant_connection([[1, 2], [2, 3], [3, 4], [1, 4], [1, 5]]).inspect  # [1,4]
end
