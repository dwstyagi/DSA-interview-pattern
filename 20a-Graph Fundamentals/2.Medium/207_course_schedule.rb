# frozen_string_literal: true

# 207. Course Schedule
#
# 1. Problem Statement
#
# Given prerequisite pairs [course, prerequisite], return whether all courses
# can be completed.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every possible ordering of the courses and test whether it respects every
# prerequisite.
#
# Algorithm:
# Generate permutations and validate each pair against position indices.
#
# Time Complexity: O(n! * (n + p))
# Space Complexity: O(n)

# 3. Brute Force Code
def can_finish_brute(num_courses, prerequisites)
  (0...num_courses).to_a.permutation.any? do |order|
    position = {}
    order.each_with_index { |course, index| position[course] = index }
    prerequisites.all? { |course, prerequisite| position[prerequisite] < position[course] }
  end
end

# 4. Bottleneck Analysis
#
# Permutations explore every possible schedule even though prerequisites only
# constrain a few edges. A cycle is the sole reason no topological ordering can
# exist, so we should detect cycles directly.
#
# 5. Optimization Journey
#
# Track how many prerequisites each course still has (indegree):
# - Courses with indegree 0 can be taken now.
# - Taking one removes its outgoing prerequisite edges.
# - Those removals may create new indegree-0 courses.
#
# If a cycle exists, its courses always retain at least one incoming edge, so
# the process stops before all courses are taken.
#
# 6. Dry Run
#
# num_courses = 2, prerequisites = [[1,0]]:
# - indegree = [0,1], queue = [0].
# - Take 0, decrement indegree[1] to 0, enqueue 1.
# - Take 1. Taken count is 2, so completion is possible.
#
# 7. Optimal Solution
#
# Apply Kahn's topological-sort algorithm and check whether it processes every
# course.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def can_finish(num_courses, prerequisites)
  graph = Array.new(num_courses) { [] }
  indegree = Array.new(num_courses, 0)

  prerequisites.each do |course, prerequisite|
    graph[prerequisite] << course
    indegree[course] += 1
  end

  queue = (0...num_courses).select { |course| indegree[course].zero? }
  head = 0

  while head < queue.length
    course = queue[head]
    head += 1
    graph[course].each do |next_course|
      indegree[next_course] -= 1
      queue << next_course if indegree[next_course].zero?
    end
  end

  queue.length == num_courses
end

# Examples
if __FILE__ == $PROGRAM_NAME
  prerequisites = [[1, 0]]
  p can_finish_brute(2, prerequisites) # true
  p can_finish(2, prerequisites) # true
  p can_finish(2, [[1, 0], [0, 1]]) # false
end
