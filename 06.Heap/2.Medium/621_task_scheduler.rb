# frozen_string_literal: true

# LeetCode 621: Task Scheduler
#
# Problem:
# Given a list of CPU tasks and a cooldown interval n, find the minimum number
# of intervals needed to execute all tasks. The same task must be separated by
# at least n intervals. CPU can be idle during cooldown.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate cycle by cycle: each cycle pick the most frequent available task
#    respecting cooldown, or idle.
#    Time Complexity: O(total_time * k) where k = unique tasks
#    Space Complexity: O(k)
#
# 2. Bottleneck
#    Simulation works but can be slow for large inputs.
#
# 3. Optimized Accepted Approach
#    Math formula: max_freq = frequency of most frequent task.
#    Frames = (max_freq - 1) slots of (n+1) width, plus count of tasks with
#    max_freq. Answer = max(tasks.length, (max_freq-1)*(n+1) + max_count).
#    Time Complexity: O(n) to count frequencies
#    Space Complexity: O(1) (26 char slots)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# tasks = ["A","A","A","B","B","B"], n = 2
# freq = {A: 3, B: 3}, max_freq = 3, max_count = 2 (both A and B have freq 3)
# Frames = (3-1) * (2+1) = 6, + max_count = 2 → 8
# tasks.length = 6 → max(6, 8) = 8
# Schedule: A B _ A B _ A B → 8 intervals ✓
#
# Edge Cases:
# - n = 0 → no cooldown, answer = tasks.length
# - All same task → (freq-1)*(n+1)+1

def least_interval_brute(tasks, n)
  freq = tasks.tally.values.sort.reverse   # frequencies descending
  time = 0
  cooldown = {}   # char => next_available_time

  freq_map = tasks.tally.transform_values { |v| v }
  until freq_map.values.all?(&:zero?)
    # find available tasks (cooldown expired)
    available = freq_map.select { |_, cnt| cnt > 0 }
                        .reject { |c, _| (cooldown[c] || 0) > time }
    if available.empty?
      time += 1   # idle
    else
      # pick most frequent available
      best = available.max_by { |_, cnt| cnt }[0]
      freq_map[best] -= 1
      cooldown[best] = time + n + 1
      time += 1
    end
  end
  time
end

def least_interval(tasks, n)
  freq = tasks.tally.values             # all frequencies
  max_freq = freq.max                   # highest frequency
  max_count = freq.count(max_freq)      # how many tasks share that max

  # formula: either fill all frame slots or just tasks.length if tightly packed
  [(max_freq - 1) * (n + 1) + max_count, tasks.length].max
end

if __FILE__ == $PROGRAM_NAME
  puts "Brute: #{least_interval_brute(%w[A A A B B B], 2)}"  # 8
  puts "Opt:   #{least_interval(%w[A A A B B B], 2)}"        # 8
  puts "Brute: #{least_interval_brute(%w[A A A B B B], 0)}"  # 6
  puts "Opt:   #{least_interval(%w[A A A B B B], 0)}"        # 6
  puts "Brute: #{least_interval_brute(%w[A A A A B B C D], 3)}"  # 10
  puts "Opt:   #{least_interval(%w[A A A A B B C D], 3)}"        # 10
end
