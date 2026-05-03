# frozen_string_literal: true

# LeetCode 502: IPO
#
# Problem:
# Given k projects you can do, each with a profit and capital requirement,
# starting with w capital, maximize your final capital by doing at most k
# projects. You can only start a project if current capital >= its requirement.
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
  # sort projects by capital requirement ascending
  projects = profits.zip(capital).sort_by { |_, cap| cap }

  # max-heap on profit (simulate descending sorted array, last = max)
  profit_heap = []
  idx = 0

  k.times do
    # unlock all affordable projects into profit max-heap
    while idx < projects.size && projects[idx][1] <= w
      profit = projects[idx][0]
      # insert into ascending array (last = max)
      pos = profit_heap.bsearch_index { |v| v >= profit } || profit_heap.size
      profit_heap.insert(pos, profit)
      idx += 1
    end

    break if profit_heap.empty?   # no affordable projects

    w += profit_heap.pop          # pick max profit (last in ascending array)
  end

  w
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{find_maximized_capital_brute(2, 0, [1, 2, 3], [0, 1, 1])}"  # 4
  puts "Opt:   #{find_maximized_capital(2, 0, [1, 2, 3], [0, 1, 1])}"        # 4
  puts "Brute: #{find_maximized_capital_brute(3, 0, [1, 2, 3], [0, 1, 2])}"  # 6
  puts "Opt:   #{find_maximized_capital(3, 0, [1, 2, 3], [0, 1, 2])}"        # 6
end
