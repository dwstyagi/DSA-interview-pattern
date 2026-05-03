# frozen_string_literal: true

# LeetCode 773: Sliding Puzzle
#
# Problem:
# Given a 2x3 board with tiles 1-5 and one blank (0), return the least number
# of moves to reach the solved state [[1,2,3],[4,5,0]], or -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    DFS all states with visited set — finds a solution but not guaranteed min.
#    Time Complexity: O(6!) = O(720) state space
#    Space Complexity: O(6!)
#
# 2. Bottleneck
#    DFS doesn't guarantee shortest — BFS on serialized board state does.
#
# 3. Optimized Accepted Approach
#    Serialize board as a string (e.g., "123450"). BFS on state strings.
#    Precompute neighbors of each position in flattened 2x3 grid.
#    BFS levels = number of moves.
#    Time Complexity: O(6!) = O(720)
#    Space Complexity: O(6!)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# board=[[4,1,2],[5,0,3]]  → "412503"
# Target = "123450"
# BFS swaps 0 with neighbors at each step; tracked by visited set.
# Returns minimum moves (5 in this case).
#
# Edge Cases:
# - Already solved -> 0
# - Unsolvable configuration -> -1

require 'set'

# Precomputed neighbors for each index in flattened 2x3 grid
NEIGHBORS = {
  0 => [1, 3],
  1 => [0, 2, 4],
  2 => [1, 5],
  3 => [0, 4],
  4 => [1, 3, 5],
  5 => [2, 4]
}.freeze
TARGET = "123450"

def sliding_puzzle_brute(board)
  start = board.flatten.join
  return 0 if start == TARGET

  visited = Set.new([start])
  stack   = [[start, 0]]
  min_moves = Float::INFINITY

  until stack.empty?
    state, moves = stack.pop
    next if moves >= min_moves
    zero_idx = state.index('0')

    NEIGHBORS[zero_idx].each do |ni|
      new_state = state.dup
      new_state[zero_idx], new_state[ni] = new_state[ni], new_state[zero_idx]
      if new_state == TARGET
        min_moves = [min_moves, moves + 1].min
      elsif !visited.include?(new_state)
        visited << new_state
        stack << [new_state, moves + 1]
      end
    end
  end

  min_moves == Float::INFINITY ? -1 : min_moves
end

def sliding_puzzle(board)
  start = board.flatten.join
  return 0 if start == TARGET

  visited = Set.new([start])
  queue   = [start]
  moves   = 0

  until queue.empty?
    moves += 1
    queue.size.times do
      state    = queue.shift
      zero_idx = state.index('0')

      NEIGHBORS[zero_idx].each do |ni|
        new_state = state.dup
        new_state[zero_idx], new_state[ni] = new_state[ni], new_state[zero_idx]
        return moves if new_state == TARGET
        next if visited.include?(new_state)
        visited << new_state
        queue << new_state
      end
    end
  end

  -1
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{sliding_puzzle_brute([[4,1,2],[5,0,3]])}"  # 5
  puts "Opt:   #{sliding_puzzle([[4,1,2],[5,0,3]])}"         # 5
  puts "Brute: #{sliding_puzzle_brute([[1,2,3],[4,0,5]])}"  # 1
  puts "Opt:   #{sliding_puzzle([[1,2,3],[4,0,5]])}"         # 1
  puts "Brute: #{sliding_puzzle_brute([[1,2,3],[5,4,0]])}"  # -1
  puts "Opt:   #{sliding_puzzle([[1,2,3],[5,4,0]])}"         # -1
end
