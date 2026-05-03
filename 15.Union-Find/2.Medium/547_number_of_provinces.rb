# frozen_string_literal: true

# LeetCode 547: Number of Provinces
#
# Problem:
# Given isConnected adjacency matrix, return the number of provinces
# (groups of directly or indirectly connected cities).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS from each unvisited city, count traversals.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n^2) due to matrix. Union-Find gives same complexity, cleaner.
#
# 3. Optimized Accepted Approach
#    Union-Find: for each connected pair (i,j), union them. Count distinct roots.
#
#    Time Complexity: O(n^2 * alpha(n))
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# isConnected=[[1,1,0],[1,1,0],[0,0,1]]
# union(0,1); (2 stays alone)
# roots: find(0)=find(1)=one root, find(2)=2 -> 2 provinces
#
# Edge Cases:
# - All isolated: n provinces
# - All connected: 1 province

def find_circle_num_brute(is_connected)
  n = is_connected.length
  visited = Array.new(n, false)
  count = 0
  n.times do |i|
    next if visited[i]
    count += 1
    stack = [i]
    while stack.any?
      node = stack.pop
      next if visited[node]
      visited[node] = true
      n.times { |j| stack << j if is_connected[node][j] == 1 && !visited[j] }
    end
  end
  count
end

def find_circle_num(is_connected)
  n = is_connected.length
  parent = Array.new(n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  n.times do |i|
    n.times do |j|
      next if is_connected[i][j] == 0
      pi, pj = find.call(i), find.call(j)
      parent[pi] = pj unless pi == pj
    end
  end
  (0...n).count { |i| find.call(i) == i }
end

if __FILE__ == $PROGRAM_NAME
  puts find_circle_num_brute([[1, 1, 0], [1, 1, 0], [0, 0, 1]])  # 2
  puts find_circle_num([[1, 0, 0], [0, 1, 0], [0, 0, 1]])         # 3
end
