# frozen_string_literal: true

# LeetCode 71: Simplify Path
#
# Problem:
# Given a Unix file path, simplify it. '.' = current dir, '..' = parent dir.
# Multiple slashes treated as one. Return canonical path.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    Split by '/', filter, process '..' by removing last component. Join with '/'.
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# 2. Bottleneck
#    Already O(n). Stack naturally handles '..' by popping.
#
# 3. Optimized Accepted Approach
#    Split by '/'. For each part: skip '' and '.'; '..' pops stack if non-empty;
#    otherwise push to stack. Join with '/' and prepend '/'.
#
#    Time Complexity: O(n)
#    Space Complexity: O(n)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# path = "/home/../usr/./bin"
# parts: ["home", "..", "usr", ".", "bin"]
# "home": push -> [home]
# "..": pop -> []
# "usr": push -> [usr]
# ".": skip
# "bin": push -> [usr, bin]
# Result: "/usr/bin"
#
# Edge Cases:
# - Root "/": return "/"
# - Multiple slashes "//a": same as "/a"
# - Trailing slash: ignored

def simplify_path_brute(path)
  parts = path.split('/')
  stack = []
  parts.each do |p|
    if p == '..'
      stack.pop unless stack.empty?
    elsif p != '' && p != '.'
      stack << p
    end
  end
  '/' + stack.join('/')
end

# optimized: same stack approach (already optimal)
def simplify_path(path)
  stack = []
  path.split('/').each do |part|
    if part == '..'
      stack.pop unless stack.empty?
    elsif part != '' && part != '.'
      stack << part
    end
  end
  "/#{stack.join('/')}"
end

if __FILE__ == $PROGRAM_NAME
  puts simplify_path_brute('/home/../usr/./bin')  # "/usr/bin"
  puts simplify_path('/a/./b/../../c/')           # "/c"
end
