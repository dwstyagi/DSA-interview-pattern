# frozen_string_literal: true

# LeetCode 621: Task Scheduler
#
# Problem:
# Given a list of CPU tasks and a cooldown interval n, return the minimum
# number of intervals needed to finish all tasks.
#
# Rule:
# The same task must have at least n intervals between two executions.
#
# Example:
#   Input:  tasks = ["A", "A", "A", "B", "B", "B"], n = 2
#   Output: 8
#
#   One valid schedule:
#   A B idle A B idle A B
#
#   Why:
#   Between two A tasks, there are 2 intervals.
#   Between two B tasks, there are 2 intervals.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. Brute Force Simulation
#    At every time unit, scan all task types and pick the available task with
#    the highest remaining count.
#    If no task is available, the CPU is idle.
#    Time Complexity: O(total_time * m)
#    Space Complexity: O(m)
#
# 2. Bottleneck
#    We scan all task types at every time unit.
#    If there are many idle intervals, total_time can be larger than tasks.length.
#
# 3. Optimized Max-Heap + Cooldown Queue
#    MaxHeap stores available tasks by remaining count.
#    Cooldown queue stores tasks that cannot run yet.
#    At each time unit:
#    - move ready tasks from cooldown queue back to heap
#    - run the most frequent available task
#    - if it still has remaining count, put it into cooldown
#    Time Complexity: O(total_time log m)
#    Space Complexity: O(m)
#
# -----------------------------------------------------------------------------
# Important Cooldown Formula
#
# If task A runs at time = 1 and n = 2:
#
# time 1: A
# time 2: _
# time 3: _
# time 4: A
#
# A can run again at time 4.
#
# Formula:
# ready_time = time + n + 1
#
# Why not time + n?
# If we used time + n:
#
# time 1: A
# time 2: _
# time 3: A
#
# Only one interval is between A and A, which violates n = 2.
#
# -----------------------------------------------------------------------------
# Dry Run
#
# tasks = ["A", "A", "A", "B", "B", "B"]
# n = 2
#
# Initial frequency:
# "A" => 3
# "B" => 3
#
# time 1:
# run A
# remaining A = 2
# A ready at 1 + 2 + 1 = 4
#
# time 2:
# run B
# remaining B = 2
# B ready at 2 + 2 + 1 = 5
#
# time 3:
# no task available
# idle
#
# time 4:
# A is ready
# run A
# remaining A = 1
# A ready at 4 + 2 + 1 = 7
#
# time 5:
# B is ready
# run B
# remaining B = 1
# B ready at 5 + 2 + 1 = 8
#
# time 6:
# no task available
# idle
#
# time 7:
# A is ready
# run A
#
# time 8:
# B is ready
# run B
#
# Final schedule:
# A B idle A B idle A B
#
# Answer:
# 8
#
# Edge Cases:
# - n = 0 means no cooldown, answer is tasks.length
# - all tasks are same
# - all tasks are unique
# - multiple tasks have same frequency

# -----------------------------
# BRUTE FORCE SIMULATION
# -----------------------------
# Idea:
# - Count each task frequency
# - At every time unit, scan all tasks
# - Pick the available task with highest remaining count
# - If no task is available, this interval is idle
#
# Time: O(total_time * m)
# Space: O(m)
#
# total_time = final answer including idle intervals
# m = number of unique task types
def least_interval_brute_force(tasks, n)
  frequency = Hash.new(0)

  tasks.each do |task|
    frequency[task] += 1
  end

  # cooldown_until[task] tells the earliest time this task can run again.
  #
  # If cooldown_until["A"] = 4, then A can run at time 4.
  # It cannot run at time 2 or 3.
  cooldown_until = Hash.new(0)

  time = 0
  remaining_tasks = tasks.length

  while remaining_tasks.positive?
    time += 1

    selected_task = nil
    selected_count = 0

    # Scan every task type and choose the available task with highest count.
    frequency.each do |task, count|
      next if count.zero?

      # If cooldown_until[task] is greater than current time,
      # this task is still cooling down.
      next if cooldown_until[task] > time

      next unless count > selected_count

      selected_task = task
      selected_count = count
    end

    # No available task means CPU stays idle for this interval.
    next if selected_task.nil?

    frequency[selected_task] -= 1

    # If task runs at current time, it can run again after n full intervals.
    #
    # Example:
    # time = 1, n = 2
    # time 1: A
    # time 2: gap
    # time 3: gap
    # time 4: A can run again
    #
    # So ready time = 1 + 2 + 1 = 4.
    cooldown_until[selected_task] = time + n + 1

    remaining_tasks -= 1
  end

  time
end

# -----------------------------
# OPTIMIZED MAX-HEAP + COOLDOWN QUEUE
# -----------------------------
# Idea:
# - MaxHeap stores tasks that are available to run
# - Cooldown queue stores tasks that are waiting
# - At each time:
#   1. Move ready tasks from cooldown queue back into heap
#   2. Run the task with highest remaining count
#   3. If it still has count left, put it into cooldown
#
# Time: O(total_time log m)
# Space: O(m)
# 
require 'algorithms'
def least_interval(tasks, n)
  frequency = Hash.new(0)

  tasks.each do |task|
    frequency[task] += 1
  end

  max_heap = Containers::MaxHeap.new

  # Store [count, task].
  #
  # MaxHeap compares count first, so the task with the highest count is popped.
  frequency.each do |task, count|
    max_heap.push([count, task])
  end

  # Queue entries:
  # [ready_time, count, task]
  #
  # The front of the queue is the task that becomes ready earliest.
  cooldown_queue = []

  time = 0

  until max_heap.empty? && cooldown_queue.empty?
    time += 1

    # Move all tasks whose cooldown is finished back into MaxHeap.
    while !cooldown_queue.empty? && cooldown_queue[0][0] <= time
      _, count, task = cooldown_queue.shift
      max_heap.push([count, task])
    end

    # If heap is empty, no task is available at this time.
    # This interval becomes idle.
    next if max_heap.empty?

    count, task = max_heap.pop

    # Run this task once.
    count -= 1

    # If no more of this task remains, it does not need cooldown.
    next unless count.positive?

    # Same cooldown rule:
    # task can run again only after n full intervals.
    ready_time = time + n + 1
    cooldown_queue << [ready_time, count, task]
  end

  time
end

if __FILE__ == $PROGRAM_NAME
  tasks = %w[A A A B B B]
  n = 2

  puts "Brute: #{least_interval_brute_force(tasks, n)}"
  puts "Opt:   #{least_interval(tasks, n)}"

  tasks = %w[A A A B B B]
  n = 0

  puts "Brute: #{least_interval_brute_force(tasks, n)}"
  puts "Opt:   #{least_interval(tasks, n)}"

  tasks = %w[A A A A B B C D]
  n = 3

  puts "Brute: #{least_interval_brute_force(tasks, n)}"
  puts "Opt:   #{least_interval(tasks, n)}"
end
