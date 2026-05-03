# frozen_string_literal: true

# LeetCode 502: IPO
#
# Problem:
# You can complete at most k projects. Project i requires capital[i] to start
# and yields profit[i]. Start with w capital. Maximize capital after k projects.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    At each step, try all affordable projects and pick the max profit one.
#    Time Complexity: O(k * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Scanning all projects each step is O(n). Use a max-heap of profits for
#    affordable projects. Use a sorted list of (capital, profit) pairs.
#
# 3. Optimized Accepted Approach
#    Sort projects by capital. Use a max-heap of profits.
#    For each of k steps: add all newly affordable projects to heap, pick max profit.
#
#    Time Complexity: O(n log n + k log n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# k=2, w=0, profits=[1,2,3], capitals=[0,1,1]
# sorted by capital: [[0,1],[1,2],[1,3]]
# step 1: add [0,1] -> heap=[1]; pick 1 -> w=1
# step 2: add [1,2],[1,3] -> heap=[2,3]; pick 3 -> w=4
# Result: 4
#
# Edge Cases:
# - k=0: return w
# - No affordable projects: return w unchanged

def find_maximized_capital_brute(k, w, profits, capital)
  projects = profits.zip(capital)
  k.times do
    best_idx = nil
    best_profit = -1
    projects.each_with_index do |(p, c), i|
      if c <= w && p > best_profit
        best_profit = p
        best_idx = i
      end
    end
    break if best_idx.nil?
    w += projects[best_idx][0]
    projects.delete_at(best_idx)
  end
  w
end

# optimized: sort + greedy max-heap (using sorted array as heap)
def find_maximized_capital(k, w, profits, capital)
  projects = capital.zip(profits).sort_by(&:first)
  available = []
  idx = 0
  k.times do
    while idx < projects.length && projects[idx][0] <= w
      available << projects[idx][1]
      idx += 1
    end
    break if available.empty?
    best = available.max
    available.delete_at(available.index(best))
    w += best
  end
  w
end

if __FILE__ == $PROGRAM_NAME
  puts find_maximized_capital_brute(2, 0, [1, 2, 3], [0, 1, 1])  # 4
  puts find_maximized_capital(3, 0, [1, 2, 3], [0, 1, 2])         # 6
end
