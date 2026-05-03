# frozen_string_literal: true

# LeetCode 547: Number of Provinces
#
# Problem:
# isConnected[i][j]=1 if cities i and j are directly connected. Return number of provinces.
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
#    Already O(n^2) due to matrix. BFS or Union-Find equally efficient.
#
# 3. Optimized Accepted Approach
#    DFS: from each unvisited city, mark all reachable cities visited.
#    Count DFS starts = number of provinces.
#
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# isConnected=[[1,1,0],[1,1,0],[0,0,1]]
# city 0: DFS -> visits 0,1; city 2: DFS -> visits 2
# Result: 2 provinces
#
# Edge Cases:
# - All isolated: n provinces
# - All connected: 1 province

def find_circle_num_brute(is_connected)
  n = is_connected.length
  visited = Array.new(n, false)
  count = 0
  dfs = lambda do |v|
    visited[v] = true
    n.times { |w| dfs.call(w) if is_connected[v][w] == 1 && !visited[w] }
  end
  n.times do |i|
    next if visited[i]
    count += 1
    dfs.call(i)
  end
  count
end

# optimized: same DFS (already optimal for adjacency matrix)
def find_circle_num(is_connected)
  n = is_connected.length
  visited = Array.new(n, false)
  count = 0
  n.times do |i|
    next if visited[i]
    count += 1
    stack = [i]
    while stack.any?
      v = stack.pop
      next if visited[v]
      visited[v] = true
      n.times { |w| stack << w if is_connected[v][w] == 1 && !visited[w] }
    end
  end
  count
end

if __FILE__ == $PROGRAM_NAME
  puts find_circle_num_brute([[1, 1, 0], [1, 1, 0], [0, 0, 1]])  # 2
  puts find_circle_num([[1, 0, 0], [0, 1, 0], [0, 0, 1]])         # 3
end
