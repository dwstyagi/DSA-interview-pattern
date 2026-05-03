# frozen_string_literal: true

# LeetCode 1383: Maximum Performance of a Team
#
# Problem:
# You have n engineers with speed[] and efficiency[]. Pick at most k engineers
# to maximize performance = sum(speeds) * min(efficiency). Return the result
# mod 10^9 + 7.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try all subsets of size 1 to k, compute performance for each.
#    Time Complexity: O(2^n * n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Exponential subset enumeration.
#
# 3. Optimized Accepted Approach
#    Sort engineers by efficiency descending. For each engineer, they define
#    the minimum efficiency. We want the k engineers with highest speed among
#    those with efficiency >= current. Use a min-heap of size k on speeds.
#    Track running speed sum; update max performance at each step.
#    Time Complexity: O(n log k)
#    Space Complexity: O(k)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# n=6, speed=[2,10,3,1,5,8], efficiency=[5,4,3,9,7,2], k=2
# Sort by eff desc: [(9,1),(7,5),(5,2),(4,10),(3,3),(2,8)]
# Process (9,1): heap=[1], sum=1, perf=1*9=9
# Process (7,5): heap=[1,5], sum=6, perf=6*7=42
# Process (5,2): heap=[2,5] (size=2,k=2 → evict min 1), sum=7, perf=7*5=35
# ...max so far = 56 (when processing (4,10))
#
# Edge Cases:
# - k=1 → max(speed[i] * efficiency[i]) for all i
# - k=n → all engineers in team

MOD = 10**9 + 7

def max_performance_brute(n, speed, efficiency, k)
  engineers = speed.zip(efficiency)
  best = 0

  (1..k).each do |size|
    engineers.combination(size).each do |team|
      speeds_sum = team.sum { |s, _| s }
      min_eff = team.min_by { |_, e| e }[1]
      perf = speeds_sum * min_eff
      best = perf if perf > best
    end
  end

  best % MOD
end

def max_performance(n, speed, efficiency, k)
  # pair and sort by efficiency descending
  engineers = speed.zip(efficiency).sort_by { |_, e| -e }

  # min-heap of speeds (ascending sorted array)
  heap = []
  speed_sum = 0
  best = 0

  engineers.each do |spd, eff|
    # add this engineer
    idx = heap.bsearch_index { |v| v >= spd } || heap.size
    heap.insert(idx, spd)
    speed_sum += spd

    # if team exceeds k, remove slowest (min of heap = first element)
    if heap.size > k
      speed_sum -= heap.shift
    end

    # current engineer defines min efficiency; compute performance
    perf = speed_sum * eff
    best = perf if perf > best
  end

  best % MOD
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{max_performance_brute(6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 2)}"  # 56
  puts "Opt:   #{max_performance(6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 2)}"        # 56
  puts "Brute: #{max_performance_brute(6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 3)}"  # 68
  puts "Opt:   #{max_performance(6, [2, 10, 3, 1, 5, 8], [5, 4, 3, 9, 7, 2], 3)}"        # 68
end
