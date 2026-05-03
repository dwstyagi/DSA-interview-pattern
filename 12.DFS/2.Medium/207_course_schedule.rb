# frozen_string_literal: true

# LeetCode 207: Course Schedule
#
# Problem:
# There are numCourses courses (0 to numCourses-1). Given prerequisites pairs
# [a, b] meaning "to take a you must first take b". Return true if it's possible
# to finish all courses (i.e., no cycle in the prerequisite graph).
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all topological orderings — exponential.
#
# 2. Bottleneck
#    Checking all orderings — DFS cycle detection with 3-color marking.
#
# 3. Optimized Accepted Approach
#    3-color DFS: WHITE=0 (unvisited), GRAY=1 (in current path), BLACK=2 (done).
#    A GRAY→GRAY edge = back edge = cycle = false. No cycle = true.
#    Time Complexity: O(V+E)
#    Space Complexity: O(V+E)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# numCourses=2, prerequisites=[[1,0]]
# Graph: 0→1 (no cycle) → true ✓
#
# numCourses=2, prerequisites=[[1,0],[0,1]]
# Graph: 0→1, 1→0 (cycle) → false ✓
#
# Edge Cases:
# - No prerequisites -> true
# - Self-loop -> false

def can_finish_brute(num_courses, prerequisites)
  # Kahn's algorithm (BFS topological sort)
  in_degree = Array.new(num_courses, 0)
  adj = Array.new(num_courses) { [] }
  prerequisites.each do |a, b|
    adj[b] << a
    in_degree[a] += 1
  end
  queue = (0...num_courses).select { |i| in_degree[i].zero? }
  count = 0
  until queue.empty?
    node = queue.shift
    count += 1
    adj[node].each { |nei| queue << nei if (in_degree[nei] -= 1).zero? }
  end
  count == num_courses
end

def can_finish(num_courses, prerequisites)
  adj   = Array.new(num_courses) { [] }
  color = Array.new(num_courses, 0)  # 0=white, 1=gray, 2=black
  prerequisites.each { |a, b| adj[b] << a }

  has_cycle = lambda do |u|
    color[u] = 1                     # mark gray (in current DFS path)
    adj[u].each do |v|
      return true if color[v] == 1   # back edge = cycle
      return true if color[v] == 0 && has_cycle.call(v)
    end
    color[u] = 2                     # mark black (fully explored)
    false
  end

  (0...num_courses).none? { |u| color[u] == 0 && has_cycle.call(u) }
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{can_finish_brute(2, [[1, 0]])}"          # true
  puts "Opt:   #{can_finish(2, [[1, 0]])}"                  # true
  puts "Brute: #{can_finish_brute(2, [[1, 0], [0, 1]])}"  # false
  puts "Opt:   #{can_finish(2, [[1, 0], [0, 1]])}"          # false
end
