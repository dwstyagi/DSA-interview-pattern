# frozen_string_literal: true

# LeetCode 134: Gas Station
#
# Problem:
# There are n gas stations in a circle. gas[i] is the gas you get at station i;
# cost[i] is the gas to travel from i to i+1. Find the starting station index
# to complete a full circle, or -1 if impossible.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Try every station as a starting point and simulate the circuit.
#    Time Complexity: O(n^2)
#    Space Complexity: O(1)
#
# 2. Bottleneck
#    We repeat work across starting points. Observation: if total gas < total cost
#    there's no solution. If a solution exists it's unique. If we fail at station k
#    starting from i, no station between i and k can be the start.
#
# 3. Optimized Accepted Approach
#    Single pass: track tank (running surplus). If tank < 0, reset start to i+1
#    and reset tank to 0. Track total to confirm solution exists.
#
#    Time Complexity: O(n)
#    Space Complexity: O(1)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# gas=[1,2,3,4,5], cost=[3,4,5,1,2]
# total_gas=15, total_cost=15 -> solution exists
# i=0: tank=1-3=-2<0 -> start=1, tank=0
# i=1: tank=2-4=-2<0 -> start=2, tank=0
# i=2: tank=3-5=-2<0 -> start=3, tank=0
# i=3: tank=4-1=3
# i=4: tank=3+5-2=6 -> done, start=3
#
# Edge Cases:
# - All gas == cost: any starting point works, return 0
# - Total gas < total cost: return -1

def can_complete_circuit_brute(gas, cost)
  n = gas.length
  n.times do |start|
    tank = 0
    success = true
    n.times do |j|
      i = (start + j) % n
      tank += gas[i] - cost[i]
      if tank < 0
        success = false
        break
      end
    end
    return start if success
  end
  -1
end

# optimized: single pass greedy
def can_complete_circuit(gas, cost)
  total = 0
  tank = 0
  start = 0
  gas.length.times do |i|
    diff = gas[i] - cost[i]
    total += diff
    tank += diff
    if tank < 0
      start = i + 1
      tank = 0
    end
  end
  total >= 0 ? start : -1
end

if __FILE__ == $PROGRAM_NAME
  puts can_complete_circuit_brute([1, 2, 3, 4, 5], [3, 4, 5, 1, 2])  # 3
  puts can_complete_circuit([2, 3, 4], [3, 4, 3])                     # -1
end
