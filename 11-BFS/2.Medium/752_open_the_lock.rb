# frozen_string_literal: true

# LeetCode 752: Open the Lock
#
# Problem:
# You have a lock with 4 circular dials (0-9). Given deadends (states that lock
# the wheel) and a target, return the minimum turns to reach target from "0000".
# Return -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    BFS state-space search from "0000". Each state has 8 neighbors (4 dials x
#    2 directions). This is already optimal.
#    Time Complexity: O(10^4 * 8) = O(10^4)
#    Space Complexity: O(10^4)
#
# 2. Bottleneck
#    State space is small (10^4). Can do bidirectional BFS for slight speedup.
#
# 3. Optimized Accepted Approach
#    Standard BFS from "0000". For each state generate 8 neighbors by turning
#    each dial +1 or -1 (mod 10). Skip deadends and visited states.
#    Time Complexity: O(10^4)
#    Space Complexity: O(10^4)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# deadends=["0201","0101","0102","1212","2002"], target="0202"
# BFS from "0000" → level 1: "1000","9000","0100",... avoiding deadends
# ... eventually reaches "0202" in 6 turns ✓
#
# Edge Cases:
# - "0000" is a deadend -> -1
# - target == "0000" -> 0

require 'set'

def open_lock_brute(deadends, target)
  dead    = Set.new(deadends)
  return -1 if dead.include?("0000")
  return 0  if target == "0000"

  visited = Set.new(["0000"])
  queue   = [["0000", 0]]

  until queue.empty?
    state, turns = queue.shift
    4.times do |i|
      [1, -1].each do |d|
        new_state    = state.dup
        new_state[i] = ((new_state[i].to_i + d + 10) % 10).to_s
        next if dead.include?(new_state) || visited.include?(new_state)
        return turns + 1 if new_state == target
        visited << new_state
        queue << [new_state, turns + 1]
      end
    end
  end

  -1
end

def open_lock(deadends, target)
  dead    = Set.new(deadends)
  return -1 if dead.include?("0000")
  return 0  if target == "0000"

  visited = Set.new(["0000"])
  queue   = ["0000"]
  turns   = 0

  until queue.empty?
    queue.size.times do
      state = queue.shift
      4.times do |i|
        [1, -1].each do |d|
          new_state    = state.dup
          new_state[i] = ((new_state[i].to_i + d + 10) % 10).to_s
          next if dead.include?(new_state) || visited.include?(new_state)
          return turns + 1 if new_state == target
          visited << new_state
          queue << new_state
        end
      end
    end
    turns += 1
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{open_lock_brute(['0201','0101','0102','1212','2002'], '0202')}"  # 6
  puts "Opt:   #{open_lock(['0201','0101','0102','1212','2002'], '0202')}"         # 6
  puts "Brute: #{open_lock_brute(['8888'], '0009')}"                               # 1
  puts "Opt:   #{open_lock(['8888'], '0009')}"                                     # 1
end
