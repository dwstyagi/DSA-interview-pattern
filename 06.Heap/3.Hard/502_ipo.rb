# frozen_string_literal: true

# LeetCode 502: IPO
#
# Problem:
# Given k projects you can do, each with a profit and capital requirement,
# starting with w capital, maximize your final capital by doing at most k
# projects. You can only start a project if current capital >= its requirement.
#
# Examples:
#   Input:  k=2, w=0, profits=[1,2,3], capital=[0,1,1]
#   Output: 4
#   Why:    Start w=0: take project 0 (profit=1)->w=1. Now take project 2 (profit=3)->w=4.
#
#   Input:  k=3, w=0, profits=[1,2,3], capital=[0,1,2]
#   Output: 6
#   Why:    Take all 3 projects sequentially: 0->1->3->6.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each of k turns, find all affordable projects, pick max profit one.
#    Time Complexity: O(k * n)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    Scanning all projects every turn is O(k*n).
#
# 3. Optimized Accepted Approach
#    Two heaps: min-heap on capital (unlock projects as capital grows),
#    max-heap on profit (pick the best available each turn).
#    Sort projects by capital, sweep affordable ones into profit max-heap,
#    pick max profit, add to capital. Repeat k times.
#    Time Complexity: O(n log n + k log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# k=2, w=0, profits=[1,2,3], capital=[0,1,1]
# Projects sorted by capital: [(0,1),(1,2),(1,3)]
# Turn 1: unlock capital<=0 → project(0,1) → profit_heap=[1]
#          pick profit 1, w = 0+1 = 1
# Turn 2: unlock capital<=1 → projects(1,2),(1,3) → profit_heap=[2,3]
#          pick profit 3, w = 1+3 = 4
# Return 4
#
# Edge Cases:
# - k=0 → return w unchanged
# - All capital requirements > w and no profitable projects unlock → unchanged

require 'algorithms'

def find_maximized_capital_brute(k, w, profits, capital)
  available = profits.zip(capital)   # [[profit, cap], ...]

  k.times do
    best_idx = nil
    best_profit = -1
    available.each_with_index do |(profit, cap), idx|
      next unless cap <= w && profit > best_profit

      best_profit = profit
      best_idx = idx
    end
    break if best_idx.nil?

    w += best_profit
    available.delete_at(best_idx)
  end

  w
end

def find_maximized_capital(k, w, profits, capital)
  min_heap = Containers::MinHeap.new  # keyed by [cap, profit] — unlocks projects as capital grows
  max_heap = Containers::MaxHeap.new  # keyed by profit — picks best available each turn

  profits.zip(capital).each { |profit, cap| min_heap.push([cap, profit]) }

  k.times do
    while !min_heap.empty? && min_heap.next[0] <= w
      _, profit = min_heap.pop
      max_heap.push(profit)
    end

    break if max_heap.empty?

    w += max_heap.pop
  end

  w
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_maximized_capital_brute(2, 0, [1, 2, 3], [0, 1, 1])}"  # 4
  puts "Opt:   #{find_maximized_capital(2, 0, [1, 2, 3], [0, 1, 1])}"        # 4
  puts "Brute: #{find_maximized_capital_brute(3, 0, [1, 2, 3], [0, 1, 2])}"  # 6
  puts "Opt:   #{find_maximized_capital(3, 0, [1, 2, 3], [0, 1, 2])}"        # 6
end
