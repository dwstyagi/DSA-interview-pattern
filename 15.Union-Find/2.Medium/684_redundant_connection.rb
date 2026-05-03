# frozen_string_literal: true

# LeetCode 684: Redundant Connection
#
# Problem:
# Given a graph that started as a tree with n nodes and one extra edge added,
# return the redundant edge. If multiple answers, return the last one.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Remove each edge one at a time, check if graph remains connected.
#    Return the last edge where removal still leaves a connected tree.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Re-checking connectivity each time is wasteful. Union-Find detects
#    when adding an edge creates a cycle (both nodes already connected).
#
# 3. Optimized Accepted Approach
#    Process edges in order. Union-Find: if both endpoints have same root,
#    this edge is redundant.
#
#    Time Complexity: O(n * alpha(n))
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# edges = [[1,2],[1,3],[2,3]]
# union(1,2): ok, components 2
# union(1,3): ok, components 1
# union(2,3): find(2)=1, find(3)=1 -> same root -> return [2,3]
#
# Edge Cases:
# - Minimum tree: 3 nodes, return the cycle-creating edge

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

  find = lambda do |x|
    parent[x] = find.call(parent[x]) unless parent[x] == x
    parent[x]
  end

  edges.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    return [u, v] if pu == pv
    if rank[pu] < rank[pv]
      parent[pu] = pv
    elsif rank[pu] > rank[pv]
      parent[pv] = pu
    else
      parent[pv] = pu
      rank[pu] += 1
    end
  end
  []
end

if __FILE__ == $PROGRAM_NAME
  puts find_redundant_connection_brute([[1, 2], [1, 3], [2, 3]]).inspect  # [2,3]
  puts find_redundant_connection([[1, 2], [2, 3], [3, 4], [1, 4], [1, 5]]).inspect  # [1,4]
end
