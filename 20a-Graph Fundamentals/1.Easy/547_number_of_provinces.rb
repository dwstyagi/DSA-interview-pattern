# frozen_string_literal: true

# 547. Number of Provinces
#
# 1. Problem Statement
#
# Given an adjacency matrix where is_connected[i][j] indicates a direct
# connection between cities, return the number of connected components.
#
# 2. Brute Force Approach
#
# Intuition:
# Start from every city and recursively follow connections, allowing duplicate
# visits. Keep the distinct reachability groups found from each start.
#
# Algorithm:
# For each city, run DFS and compare its reachable set to previous sets.
#
# Time Complexity: O(n^3)
# Space Complexity: O(n^2)

# 3. Brute Force Code
def find_circle_num_brute(is_connected)
  groups = []

  is_connected.each_index do |start|
    reachable = {}
    explore = lambda do |city|
      next if reachable[city]

      reachable[city] = true
      is_connected[city].each_with_index do |connected, neighbor|
        explore.call(neighbor) if connected == 1
      end
    end
    explore.call(start)

    groups << reachable.keys.sort unless groups.any? { |group| group == reachable.keys.sort }
  end

  groups.length
end

# 4. Bottleneck Analysis
#
# Cities in the same province trigger identical traversals many times. Once one
# traversal finishes, all cities it reached belong to one known component and
# should never start another search.
#
# 5. Optimization Journey
#
# Maintain a visited array. When an unvisited city appears, it starts exactly
# one new province; DFS marks every city in that province visited.
#
# 6. Dry Run
#
# Matrix [[1,1,0],[1,1,0],[0,0,1]]:
# - City 0 is unvisited: DFS reaches 0 and 1, provinces = 1.
# - City 1 is already visited.
# - City 2 is unvisited: DFS reaches 2, provinces = 2.
#
# 7. Optimal Solution
#
# Count DFS starts over unvisited cities.
#
# Time Complexity: O(n^2)
# Space Complexity: O(n)

# 8. Optimal Code
def find_circle_num(is_connected)
  visited = Array.new(is_connected.length, false)
  provinces = 0

  is_connected.each_index do |city|
    next if visited[city]

    provinces += 1
    stack = [city]
    visited[city] = true

    until stack.empty?
      current = stack.pop
      is_connected[current].each_with_index do |connected, neighbor|
        next unless connected == 1 && !visited[neighbor]

        visited[neighbor] = true
        stack << neighbor
      end
    end
  end

  provinces
end

# Examples
if __FILE__ == $PROGRAM_NAME
  cities = [[1, 1, 0], [1, 1, 0], [0, 0, 1]]
  p find_circle_num_brute(cities) # 2
  p find_circle_num(cities) # 2
end
