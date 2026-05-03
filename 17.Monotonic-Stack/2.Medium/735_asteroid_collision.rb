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
#    Simulate: repeatedly find first collision (positive followed by negative) and resolve.
#    Time Complexity: O(n^2)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Repeated scanning. Monotonic stack: push positive asteroids. On negative, resolve
#    collisions with stack top until no more collision.
#
# 3. Optimized Accepted Approach
#    Stack: push if positive or stack empty/top negative. If negative:
#    pop top while top > 0 and |top| < |current| (current wins).
#    Equal: pop top, current destroyed. Top > |current|: current destroyed.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# asteroids = [10, 2, -5]
# push 10, push 2
# -5: 2 < 5 -> pop 2; 10 > 5 -> -5 destroyed
# Result: [10]
#
# Edge Cases:
# - All positive: no collisions
# - All negative: no collisions (all moving left)

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
