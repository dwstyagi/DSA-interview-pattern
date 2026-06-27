# frozen_string_literal: true

# 210. Course Schedule II
#
# 1. Problem Statement
#
# Return one valid order for finishing all courses given prerequisite pairs
# [course, prerequisite]. Return [] if no order exists.
#
# 2. Brute Force Approach
#
# Intuition:
# Try every possible course order until one satisfies all prerequisites.
#
# Algorithm:
# Generate permutations, map each course to its position, and validate every
# prerequisite edge.
#
# Time Complexity: O(n! * (n + p))
# Space Complexity: O(n)

# 3. Brute Force Code
def find_order_brute(num_courses, prerequisites)
  (0...num_courses).to_a.permutation do |order|
    position = {}
    order.each_with_index { |course, index| position[course] = index }
    return order if prerequisites.all? { |course, prerequisite| position[prerequisite] < position[course] }
  end

  []
end

# 4. Bottleneck Analysis
#
# Permutations ignore the graph's structure and grow factorially. We only need
# to repeatedly choose courses whose prerequisites are already satisfied.
#
# 5. Optimization Journey
#
# A zero-indegree course has no remaining prerequisite, so it can be appended
# to the answer. Removing its outgoing edges may unlock more courses. This is
# Kahn's algorithm; a complete result exists exactly when all courses are
# removed.
#
# 6. Dry Run
#
# prerequisites = [[1,0],[2,0],[3,1],[3,2]]:
# - Start queue: [0].
# - Remove 0: enqueue 1 and 2, order = [0].
# - Remove 1, then 2: 3 reaches indegree 0.
# - Remove 3: order = [0,1,2,3].
#
# 7. Optimal Solution
#
# Topologically sort the prerequisite graph with an indegree queue.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V + E)

# 8. Optimal Code
def find_order(num_courses, prerequisites)
  graph = Array.new(num_courses) { [] }
  indegree = Array.new(num_courses, 0)

  prerequisites.each do |course, prerequisite|
    graph[prerequisite] << course
    indegree[course] += 1
  end

  queue = (0...num_courses).select { |course| indegree[course].zero? }
  order = []
  head = 0

  while head < queue.length
    course = queue[head]
    head += 1
    order << course

    graph[course].each do |next_course|
      indegree[next_course] -= 1
      queue << next_course if indegree[next_course].zero?
    end
  end

  order.length == num_courses ? order : []
end

# Examples
if __FILE__ == $PROGRAM_NAME
  prerequisites = [[1, 0], [2, 0], [3, 1], [3, 2]]
  p find_order_brute(4, prerequisites) # [0, 1, 2, 3]
  p find_order(4, prerequisites) # [0, 1, 2, 3]
end
