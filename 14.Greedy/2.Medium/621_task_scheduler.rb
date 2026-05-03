# frozen_string_literal: true

# LeetCode 621: Task Scheduler
#
# Problem:
# Given tasks array and cooling interval n, find the minimum number of CPU
# intervals needed to execute all tasks. Same task must be at least n intervals apart.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate the scheduler: always pick the most frequent available task.
#    Time Complexity: O(total_time * k) where k = distinct tasks
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Simulation with sorting each step is slow. The answer depends only on the
#    most frequent task count and number of tasks with that max frequency.
#
# 3. Optimized Accepted Approach
#    Math formula: find max_freq (highest count) and count of tasks with max_freq.
#    result = max((max_freq - 1) * (n + 1) + count_max, tasks.length)
#    The idle slots are filled; if tasks exceed frame slots, no idle needed.
#
#    Time Complexity: O(k) where k = number of distinct tasks
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# tasks = [A,A,A,B,B,B], n=2
# freq: A=3, B=3 -> max_freq=3, count_max=2
# (3-1)*(2+1)+2 = 2*3+2 = 8
# vs tasks.length=6 -> max(8,6)=8
# Layout: AB_AB_AB -> 8 intervals
#
# Edge Cases:
# - n=0: no cooling, answer = tasks.length
# - Single task type: (max_freq-1)*(n+1)+1

def least_interval_brute(tasks, n)
  freq = Hash.new(0)
  tasks.each { |t| freq[t] += 1 }
  counts = freq.values.sort.reverse
  time = 0
  until counts.all?(&:zero?)
    (0..n).each do |i|
      time += 1
      counts[i] -= 1 if i < counts.length && counts[i] > 0
    end
    counts.sort!.reverse!
    counts.pop while counts.last == 0
  end
  time
end

# optimized: formula-based
def least_interval(tasks, n)
  freq = Hash.new(0)
  tasks.each { |t| freq[t] += 1 }
  max_freq = freq.values.max
  count_max = freq.values.count { |v| v == max_freq }
  [(max_freq - 1) * (n + 1) + count_max, tasks.length].max
end

if __FILE__ == $PROGRAM_NAME
  puts least_interval_brute(%w[A A A B B B], 2)  # 8
  puts least_interval(%w[A A A B B B], 0)         # 6
end
