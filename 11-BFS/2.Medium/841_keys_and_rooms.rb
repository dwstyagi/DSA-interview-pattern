# frozen_string_literal: true

# LeetCode 841: Keys and Rooms
#
# Problem:
# There are n rooms labeled 0 to n-1. You start in room 0 (unlocked). Each
# room[i] contains keys to other rooms. Return true if you can visit all rooms.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS/BFS from room 0, collect all reachable rooms. Same complexity.
#    Time Complexity: O(n + k) — n rooms, k total keys
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already optimal — just need graph reachability.
#
# 3. Optimized Accepted Approach
#    BFS from room 0. For each visited room, enqueue all keys found inside.
#    Check if all n rooms are visited at the end.
#    Time Complexity: O(n + k)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# rooms=[[1],[2],[3],[]]
# BFS: visit 0 → keys [1] → visit 1 → keys [2] → visit 2 → keys [3] → visit 3
# all 4 rooms visited → true ✓
#
# Edge Cases:
# - Room 0 has no keys -> only room 0 visited, false if n>1
# - All rooms reachable directly from room 0

def can_visit_all_rooms_brute(rooms)
  visited = Array.new(rooms.length, false)
  stack   = [0]
  until stack.empty?
    room = stack.pop
    next if visited[room]
    visited[room] = true
    rooms[room].each { |key| stack << key }
  end
  visited.all?
end

def can_visit_all_rooms(rooms)
  visited = Array.new(rooms.length, false)
  queue   = [0]
  visited[0] = true

  until queue.empty?
    room = queue.shift
    rooms[room].each do |key|
      next if visited[key]
      visited[key] = true
      queue << key
    end
  end

  visited.all?
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{can_visit_all_rooms_brute([[1], [2], [3], []])}"  # true
  puts "Opt:   #{can_visit_all_rooms([[1], [2], [3], []])}"         # true
  puts "Brute: #{can_visit_all_rooms_brute([[1, 3], [3, 0, 1], [2], [0]])}"  # false
  puts "Opt:   #{can_visit_all_rooms([[1, 3], [3, 0, 1], [2], [0]])}"         # false
end
