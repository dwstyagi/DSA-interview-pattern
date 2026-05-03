# frozen_string_literal: true

# LeetCode 1202: Smallest String with Swaps
#
# Problem:
# Given string s and pairs of indices, you can swap characters at paired indices
# any number of times. Return the lexicographically smallest string possible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS: generate all reachable strings via swaps.
#    Time Complexity: O(n! * n)
#    Space Complexity: O(n!)
#
# 2. Bottleneck
#    Connected indices can be rearranged freely. Find connected components via
#    Union-Find, sort each component's characters.
#
# 3. Optimized Accepted Approach
#    Union-Find to group indices. For each component, collect characters,
#    sort them, place back in sorted order at those (sorted) indices.
#
#    Time Complexity: O(n log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# s="dcab", pairs=[[0,3],[1,2]]
# union(0,3), union(1,2)
# component {0,3}: chars ['d','b'] -> sorted ['b','d'] at indices [0,3]
# component {1,2}: chars ['c','a'] -> sorted ['a','c'] at indices [1,2]
# result: "bacd"
#
# Edge Cases:
# - No pairs: return s unchanged
# - All connected: return sorted(s)

def smallest_string_with_swaps_brute(s, pairs)
  n = s.length
  parent = Array.new(n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  pairs.each { |u, v| pu, pv = find.call(u), find.call(v); parent[pu] = pv unless pu == pv }

  groups = Hash.new { |h, k| h[k] = [] }
  n.times { |i| groups[find.call(i)] << i }

  result = s.chars
  groups.each do |_, indices|
    chars = indices.map { |i| result[i] }.sort
    indices.sort.each_with_index { |idx, i| result[idx] = chars[i] }
  end
  result.join
end

# optimized: same union-find approach
def smallest_string_with_swaps(s, pairs)
  n = s.length
  parent = Array.new(n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  pairs.each { |u, v| pu, pv = find.call(u), find.call(v); parent[pu] = pv unless pu == pv }

  groups = Hash.new { |h, k| h[k] = [] }
  n.times { |i| groups[find.call(i)] << i }

  result = s.chars
  groups.values.each do |indices|
    chars = indices.sort.map { |i| result[i] }.sort
    indices.sort.each_with_index { |idx, i| result[idx] = chars[i] }
  end
  result.join
end

if __FILE__ == $PROGRAM_NAME
  puts smallest_string_with_swaps_brute('dcab', [[0, 3], [1, 2]])  # "bacd"
  puts smallest_string_with_swaps('cba', [[0, 1], [1, 2]])          # "abc"
end
