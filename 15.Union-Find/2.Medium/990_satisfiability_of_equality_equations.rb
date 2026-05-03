# frozen_string_literal: true

# LeetCode 990: Satisfiability of Equality Equations
#
# Problem:
# Given equations like "a==b" or "a!=b", return true if all can be satisfied.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Build equivalence classes from == equations, then check != equations
#    against those classes.
#    Time Complexity: O(n^2) naive equivalence checking
#    Space Complexity: O(26)
#
# 2. Bottleneck
#    Union-Find handles equivalence classes in near O(1) per operation.
#
# 3. Optimized Accepted Approach
#    Pass 1: union all '==' pairs.
#    Pass 2: for each '!=' check, if find(a) == find(b), contradiction.
#
#    Time Complexity: O(n * alpha(26)) = O(n)
#    Space Complexity: O(26)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# equations = ["a==b","b!=c","b==c"]
# Pass 1: union(a,b), union(b,c)
# Pass 2: b!=c but find(b)==find(c) -> false
#
# Edge Cases:
# - "a==a" is always satisfiable
# - "a!=a" is never satisfiable

def equations_possible_brute?(equations)
  parent = Array.new(26) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }

  equations.each do |eq|
    next unless eq[1] == '='
    a = eq[0].ord - 'a'.ord
    b = eq[3].ord - 'a'.ord
    pa, pb = find.call(a), find.call(b)
    parent[pa] = pb unless pa == pb
  end

  equations.each do |eq|
    next if eq[1] == '='
    a = eq[0].ord - 'a'.ord
    b = eq[3].ord - 'a'.ord
    return false if find.call(a) == find.call(b)
  end
  true
end

# optimized: same union-find, clean implementation
def equations_possible?(equations)
  parent = Array.new(26) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }

  equations.select { |eq| eq[1] == '=' }.each do |eq|
    a, b = eq[0].ord - 97, eq[3].ord - 97
    parent[find.call(a)] = find.call(b)
  end

  equations.select { |eq| eq[1] == '!' }.none? do |eq|
    a, b = eq[0].ord - 97, eq[3].ord - 97
    find.call(a) == find.call(b)
  end
end

if __FILE__ == $PROGRAM_NAME
  puts equations_possible_brute?(['a==b', 'b!=c', 'b==c'])  # false
  puts equations_possible?(['c==c', 'b==d', 'x!=z'])        # true
end
