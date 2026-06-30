# frozen_string_literal: true

# 841. Keys and Rooms
#
# 1. Problem Statement
#
# You begin in room 0. Each room contains keys to other rooms. Return whether
# every room can be visited.
#
# 2. Brute Force Approach
#
# Intuition:
# Try all possible sequences of keys to decide whether every room can be
# unlocked.
#
# Algorithm:
# Recursively choose unused keys from currently opened rooms and test whether a
# sequence eventually opens all rooms.
#
# Time Complexity: Exponential in the number of keys.
# Space Complexity: O(n)

# 3. Brute Force Code
def can_visit_all_rooms_brute(rooms)
  explore = lambda do |opened, used_keys|
    return true if opened.length == rooms.length

    opened.any? do |room|
      rooms[room].any? do |key|
        next false if opened.include?(key) || used_keys.include?([room, key])

        explore.call(opened + [key], used_keys + [[room, key]])
      end
    end
  end

  explore.call([0], [])
end

# 4. Bottleneck Analysis
#
# The brute force treats the order of collecting keys as important. It is not:
# once a room becomes reachable, all its keys are permanently available. Each
# room only needs to be visited once.
#
# 5. Optimization Journey
#
# Model rooms as directed graph nodes and keys as edges. Starting at room 0,
# DFS or BFS discovers every reachable room. All rooms are visitable exactly
# when the visited count equals the number of rooms.
#
# 6. Dry Run
#
# rooms = [[1],[2],[3],[]]:
# - Start with room 0.
# - Key 1 opens room 1, then key 2 opens room 2, then key 3 opens room 3.
# - Four rooms are visited, so return true.
#
# 7. Optimal Solution
#
# Traverse the directed graph from room 0 using a visited set.
#
# Time Complexity: O(V + E)
# Space Complexity: O(V)

# 8. Optimal Code
def can_visit_all_rooms(rooms)
  visited = { 0 => true }
  stack = [0]

  until stack.empty?
    room = stack.pop
    rooms[room].each do |key|
      next if visited[key]

      visited[key] = true
      stack << key
    end
  end

  visited.length == rooms.length
end

# Examples
if __FILE__ == $PROGRAM_NAME
  rooms = [[1], [2], [3], []]
  p can_visit_all_rooms_brute(rooms) # true
  p can_visit_all_rooms(rooms) # true
end
