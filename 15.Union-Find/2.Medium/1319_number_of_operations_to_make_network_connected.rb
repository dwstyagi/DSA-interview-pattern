# frozen_string_literal: true

# LeetCode 1319: Number of Operations to Make Network Connected
#
# Problem:
# n computers connected by cables (edges). In one operation, remove a cable and
# place it between any two unconnected computers. Return minimum operations, or -1.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Count connected components via BFS/DFS. Need (components-1) cables.
#    Also need enough spare cables (cables - (n-1) base cables per component).
#    Time Complexity: O(V + E)
#    Space Complexity: O(V)
#
# 2. Bottleneck
#    If edges < n-1, impossible. Otherwise: answer = components - 1.
#    Union-Find efficiently counts components and detects redundant edges.
#
# 3. Optimized Accepted Approach
#    Union-Find: count redundant edges (same component). If redundant >= components-1,
#    return components-1. Else -1.
#
#    Time Complexity: O(E * alpha(V))
#    Space Complexity: O(V)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=4, connections=[[0,1],[0,2],[1,2]]
# union(0,1): ok; union(0,2): ok; union(1,2): redundant=1
# components=2 (0-1-2 and 3), need 1 operation, redundant=1 >= 1 -> return 1
#
# Edge Cases:
# - connections.length < n-1: impossible, return -1
# - Already connected: return 0

def make_connected_brute(n, connections)
  return -1 if connections.length < n - 1
  parent = Array.new(n) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  components = n
  connections.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    unless pu == pv
      parent[pu] = pv
      components -= 1
    end
  end
  components - 1
end

# optimized: same union-find, explicit variable
def make_connected(n, connections)
  return -1 if connections.length < n - 1
  parent = Array.new(n) { |i| i }
  rank = Array.new(n, 0)
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  components = n

  connections.each do |u, v|
    pu, pv = find.call(u), find.call(v)
    next if pu == pv
    components -= 1
    if rank[pu] < rank[pv] then parent[pu] = pv
    elsif rank[pu] > rank[pv] then parent[pv] = pu
    else parent[pv] = pu; rank[pu] += 1
    end
  end
  components - 1
end

if __FILE__ == $PROGRAM_NAME
  puts make_connected_brute(4, [[0, 1], [0, 2], [1, 2]])  # 1
  puts make_connected(6, [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3]])  # 2
end
