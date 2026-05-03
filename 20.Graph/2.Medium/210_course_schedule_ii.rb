# frozen_string_literal: true

# LeetCode 210: Course Schedule II
#
# Problem:
# Return order to finish all courses (topological sort). Return [] if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS with cycle detection, post-order gives reverse topological order.
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    Already O(V+E). Kahn's BFS algorithm also gives order directly.
#
# 3. Optimized Accepted Approach
#    Kahn's: process nodes with in-degree 0, add to result, decrement neighbors.
#    If all processed, return result. Else cycle exists.
#
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# numCourses=4, prerequisites=[[1,0],[2,0],[3,1],[3,2]]
# in_degree: 0=0, 1=1, 2=1, 3=2
# queue=[0]; process 0 -> result=[0], decrement 1,2 -> queue=[1,2]
# process 1 -> result=[0,1], decrement 3 -> in_degree[3]=1
# process 2 -> result=[0,1,2], decrement 3 -> queue=[3]
# process 3 -> result=[0,1,2,3]
#
# Edge Cases:
# - No prerequisites: any order works
# - Cycle: return []

def find_order_brute(num_courses, prerequisites)
  adj = Array.new(num_courses) { [] }
  prerequisites.each { |a, b| adj[b] << a }
  color = Array.new(num_courses, 0)
  result = []
  cycle = false

  dfs = lambda do |v|
    color[v] = 1
    adj[v].each do |nb|
      if color[nb] == 1
        cycle = true; return
      end
      dfs.call(nb) if color[nb] == 0
    end
    color[v] = 2
    result << v
  end

  num_courses.times { |v| dfs.call(v) if color[v] == 0 }
  cycle ? [] : result.reverse
end

def find_order(num_courses, prerequisites)
  adj = Array.new(num_courses) { [] }
  in_degree = Array.new(num_courses, 0)
  prerequisites.each { |a, b| adj[b] << a; in_degree[a] += 1 }
  queue = (0...num_courses).select { |v| in_degree[v] == 0 }
  result = []
  until queue.empty?
    v = queue.shift
    result << v
    adj[v].each do |nb|
      in_degree[nb] -= 1
      queue << nb if in_degree[nb] == 0
    end
  end
  result.length == num_courses ? result : []
end

if __FILE__ == $PROGRAM_NAME
  puts find_order_brute(4, [[1, 0], [2, 0], [3, 1], [3, 2]]).inspect  # [0,1,2,3] or similar
  puts find_order(2, [[1, 0], [0, 1]]).inspect                         # []
end
