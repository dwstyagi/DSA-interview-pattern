# frozen_string_literal: true

# LeetCode 207: Course Schedule
#
# Problem:
# n courses (0 to n-1). prerequisites[i]=[a,b] means take b before a.
# Return true if you can finish all courses (no cycle).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS with visited states to detect cycles in directed graph.
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# 2. Bottleneck
#    Already O(V+E). Can also use Kahn's algorithm (topological sort via BFS).
#
# 3. Optimized Accepted Approach
#    DFS with three-color marking: white=0 (unvisited), gray=1 (in progress), black=2 (done).
#    Cycle if we reach a gray node.
#
#    Time Complexity: O(V + E)
#    Space Complexity: O(V + E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# numCourses=2, prerequisites=[[1,0]]
# Graph: 0->1
# DFS from 0: mark gray, visit 1, mark gray (no outgoing), mark black. 0 mark black.
# No cycle -> true
#
# prerequisites=[[1,0],[0,1]]: cycle -> false
#
# Edge Cases:
# - No prerequisites: always true
# - All courses form a cycle: false

def can_finish_brute?(num_courses, prerequisites)
  adj = Array.new(num_courses) { [] }
  prerequisites.each { |a, b| adj[b] << a }
  color = Array.new(num_courses, 0)

  dfs = lambda do |v|
    color[v] = 1
    adj[v].each do |nb|
      return false if color[nb] == 1
      return false if color[nb] == 0 && !dfs.call(nb)
    end
    color[v] = 2
    true
  end

  num_courses.times.all? { |v| color[v] != 0 || dfs.call(v) }
end

def can_finish?(num_courses, prerequisites)
  adj = Array.new(num_courses) { [] }
  in_degree = Array.new(num_courses, 0)
  prerequisites.each { |a, b| adj[b] << a; in_degree[a] += 1 }
  queue = (0...num_courses).select { |v| in_degree[v] == 0 }
  processed = 0
  until queue.empty?
    v = queue.shift
    processed += 1
    adj[v].each do |nb|
      in_degree[nb] -= 1
      queue << nb if in_degree[nb] == 0
    end
  end
  processed == num_courses
end

if __FILE__ == $PROGRAM_NAME
  puts can_finish_brute?(2, [[1, 0]])          # true
  puts can_finish?(2, [[1, 0], [0, 1]])        # false
end
