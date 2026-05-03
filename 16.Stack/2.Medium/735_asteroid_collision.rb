# frozen_string_literal: true

# LeetCode 735: Asteroid Collision
#
# Problem:
# Asteroids move in a row; positive = right, negative = left. Same direction never collide.
# On collision, smaller explodes; equal-size both explode. Return final state.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Simulate step-by-step: repeatedly find collision (pos followed by neg) and resolve.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. Stack: push asteroids; on negative asteroid, check top.
#    Resolve collisions in place.
#
# 3. Optimized Accepted Approach
#    Stack: if top > 0 and current < 0, collision. Resolve: pop if current dominates.
#    Continue until no collision or current destroyed.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# asteroids = [5, 10, -5]
# push 5: stack=[5]
# push 10: stack=[5,10]
# -5: top=10 > 5 -> -5 destroyed
# Result: [5, 10]
#
# asteroids = [8, -8]
# push 8: stack=[8]
# -8: |8|==|-8| -> both explode, stack=[]
# Result: []
#
# Edge Cases:
# - All positive: no collisions
# - All negative: no collisions (moving left, none collide with each other)

def asteroid_collision_brute(asteroids)
  arr = asteroids.dup
  changed = true
  while changed
    changed = false
    i = 0
    while i < arr.length - 1
      if arr[i] > 0 && arr[i + 1] < 0
        changed = true
        if arr[i].abs > arr[i + 1].abs
          arr.delete_at(i + 1)
        elsif arr[i].abs < arr[i + 1].abs
          arr.delete_at(i)
        else
          arr.delete_at(i + 1)
          arr.delete_at(i)
        end
      else
        i += 1
      end
    end
  end
  arr
end

def asteroid_collision(asteroids)
  stack = []
  asteroids.each do |a|
    alive = true
    while alive && a < 0 && !stack.empty? && stack.last > 0
      if stack.last < -a
        stack.pop
      elsif stack.last == -a
        stack.pop
        alive = false
      else
        alive = false
      end
    end
    stack << a if alive
  end
  stack
end

if __FILE__ == $PROGRAM_NAME
  puts asteroid_collision_brute([5, 10, -5]).inspect   # [5,10]
  puts asteroid_collision([8, -8]).inspect              # []
  puts asteroid_collision([10, 2, -5]).inspect          # [10]
end
