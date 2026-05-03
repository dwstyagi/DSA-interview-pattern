# frozen_string_literal: true

# LeetCode 332: Reconstruct Itinerary
#
# Problem:
# Given list of airline tickets [from, to], reconstruct the itinerary starting from "JFK".
# Use all tickets exactly once. Return lexicographically smallest itinerary.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all permutations of tickets (Eulerian path). Exponential.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Hierholzer's algorithm for Eulerian path. DFS with backtracking finds
#    the path using all edges.
#
# 3. Optimized Accepted Approach
#    Sort adjacency lists lexicographically. DFS (Hierholzer's): when dead end,
#    prepend to result. This guarantees lexicographic smallest Eulerian path.
#
#    Time Complexity: O(E log E)
#    Space Complexity: O(E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# tickets=[["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
# sorted adj: JFK->[ATL,SFO], SFO->[ATL], ATL->[JFK,SFO]
# DFS JFK->ATL->JFK->SFO->ATL->SFO (dead end, prepend SFO)
# ... backtrack, prepend in reverse -> ["JFK","ATL","JFK","SFO","ATL","SFO"]
#
# Edge Cases:
# - Linear itinerary: only one valid path
# - Lexicographic tie: always pick alphabetically first neighbor

def find_itinerary_brute(tickets)
  adj = Hash.new { |h, k| h[k] = [] }
  tickets.sort.each { |from, to| adj[from] << to }
  result = []

  dfs = lambda do |airport|
    dfs.call(adj[airport].shift) while adj[airport].any?
    result.unshift(airport)
  end

  dfs.call('JFK')
  result
end

# optimized: same Hierholzer's (already optimal)
def find_itinerary(tickets)
  adj = Hash.new { |h, k| h[k] = [] }
  tickets.sort.each { |from, to| adj[from] << to }
  result = []
  stack = ['JFK']
  until stack.empty?
    while adj[stack.last].any?
      stack << adj[stack.last].shift
    end
    result.unshift(stack.pop)
  end
  result
end

if __FILE__ == $PROGRAM_NAME
  puts find_itinerary_brute([%w[MUC LHR], %w[JFK MUC], %w[SFO SJC], %w[LHR SFO]]).inspect
  # ["JFK","MUC","LHR","SFO","SJC"]
  puts find_itinerary([%w[JFK SFO], %w[JFK ATL], %w[SFO ATL], %w[ATL JFK], %w[ATL SFO]]).inspect
  # ["JFK","ATL","JFK","SFO","ATL","SFO"]
end
