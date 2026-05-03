# Pattern 16 — Stack

## Recognize It

Ask yourself:

- Does the problem involve **matched pairs** (parentheses, tags, brackets)?
- Do you need to **undo / revisit** the most recent item?
- Is it about **evaluating expressions** (infix, postfix, reverse Polish)?
- Does the input need to be processed **last-in-first-out**?

If yes → Stack. (For "next greater/smaller" variants, see Monotonic Stack — pattern 17.)

---

## Core Templates

### 1. Balanced Parentheses

```ruby
def valid?(s)
  pairs = { ')' => '(', ']' => '[', '}' => '{' }
  stack = []

  s.each_char do |c|
    if pairs.value?(c)
      stack << c
    else
      return false if stack.pop != pairs[c]
    end
  end

  stack.empty?
end
```

---

### 2. Evaluate Reverse Polish Notation

```ruby
def eval_rpn(tokens)
  stack = []
  tokens.each do |t|
    if %w[+ - * /].include?(t)
      b = stack.pop
      a = stack.pop
      stack << case t
               when '+' then a + b
               when '-' then a - b
               when '*' then a * b
               when '/' then (a.to_f / b).to_i   # truncate toward zero
               end
    else
      stack << t.to_i
    end
  end
  stack[0]
end
```

---

### 3. Min Stack (stack with O(1) getMin)

```ruby
class MinStack
  def initialize
    @stack    = []
    @min_stack = []
  end

  def push(x)
    @stack << x
    @min_stack << (@min_stack.empty? ? x : [@min_stack[-1], x].min)
  end

  def pop
    @stack.pop
    @min_stack.pop
  end

  def top        = @stack[-1]
  def get_min    = @min_stack[-1]
end
```

---

### 4. Two Stacks → Queue

```ruby
class MyQueue
  def initialize
    @in_stack  = []
    @out_stack = []
  end

  def push(x)
    @in_stack << x
  end

  def pop
    shift_if_empty
    @out_stack.pop
  end

  def peek
    shift_if_empty
    @out_stack[-1]
  end

  def empty?
    @in_stack.empty? && @out_stack.empty?
  end

  private

  def shift_if_empty
    @out_stack << @in_stack.pop while !@in_stack.empty? && @out_stack.empty?
  end
end
```

---

## Problem List

### Easy

| #   | Problem                        | LC                                                                              | Variant         | Track          |
| --- | ------------------------------ | ------------------------------------------------------------------------------- | --------------- | -------------- |
| 1   | Valid Parentheses              | [20](https://leetcode.com/problems/valid-parentheses/)                          | Matching        | pair map       |
| 2   | Min Stack                      | [155](https://leetcode.com/problems/min-stack/)                                 | Auxiliary stack | running min    |
| 3   | Implement Queue using Stacks   | [232](https://leetcode.com/problems/implement-queue-using-stacks/)              | Two stacks      | lazy transfer  |
| 4   | Implement Stack using Queues   | [225](https://leetcode.com/problems/implement-stack-using-queues/)              | Queue rotation  | rotate on push |
| 5   | Baseball Game                  | [682](https://leetcode.com/problems/baseball-game/)                             | Apply rules     | op codes       |
| 6   | Remove All Adjacent Duplicates | [1047](https://leetcode.com/problems/remove-all-adjacent-duplicates-in-string/) | Dedupe stack    | pop on match   |

### Medium

| #   | Problem                                 | LC                                                                                                 | Variant             | Track                  |
| --- | --------------------------------------- | -------------------------------------------------------------------------------------------------- | ------------------- | ---------------------- |
| 7   | Evaluate Reverse Polish Notation        | [150](https://leetcode.com/problems/evaluate-reverse-polish-notation/)                             | RPN                 | binary op              |
| 8   | Decode String                           | [394](https://leetcode.com/problems/decode-string/)                                                | Nested "k[..]"      | count + str stacks     |
| 9   | Basic Calculator II                     | [227](https://leetcode.com/problems/basic-calculator-ii/)                                          | Infix with +-\*/    | lazy last op           |
| 10  | Simplify Path                           | [71](https://leetcode.com/problems/simplify-path/)                                                 | Path tokens         | .., ., names           |
| 11  | Asteroid Collision                      | [735](https://leetcode.com/problems/asteroid-collision/)                                           | Collision logic     | sign + magnitude       |
| 12  | Remove K Digits                         | [402](https://leetcode.com/problems/remove-k-digits/)                                              | Smallest result     | monotonic increasing   |
| 13  | Valid Parenthesis String                | [678](https://leetcode.com/problems/valid-parenthesis-string/)                                     | '\*' wildcard       | two stacks (or greedy) |
| 14  | Exclusive Time of Functions             | [636](https://leetcode.com/problems/exclusive-time-of-functions/)                                  | Call-stack sim      | delta on pop           |
| 15  | Next Greater Element II (circular)      | [503](https://leetcode.com/problems/next-greater-element-ii/)                                      | Circular mono stack | iterate 2n             |
| 16  | LRU Cache                               | [146](https://leetcode.com/problems/lru-cache/)                                                    | Doubly LL + Hash    | O(1) get/put           |
| 17  | First Non-Repeating Character in Stream | [GFG](https://practice.geeksforgeeks.org/problems/first-non-repeating-character-in-a-stream1216/1) | Queue + freq hash   | front = answer         |

### Hard

| #   | Problem                        | LC                                                                  | Variant                 | Track              |
| --- | ------------------------------ | ------------------------------------------------------------------- | ----------------------- | ------------------ |
| 16  | Basic Calculator               | [224](https://leetcode.com/problems/basic-calculator/)              | +/-/parens              | stack of signs     |
| 17  | Basic Calculator III           | [772](https://leetcode.com/problems/basic-calculator-iii/)          | All ops + parens        | recursive or stack |
| 18  | Largest Rectangle in Histogram | [84](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Monotonic stack         | see pattern 17     |
| 19  | LFU Cache                      | [460](https://leetcode.com/problems/lfu-cache/)                     | freq map + DLL per freq | min_freq tracking  |

---

## Key Tricks to Remember

**Push open, pop close, compare**

```ruby
# for matching-pair problems, maintain a map of close→open
# on close bracket: pop and compare, return false on mismatch
# at end, stack MUST be empty
```

**Parallel stacks for multi-value state**

```ruby
# Decode String: one stack for counts, one for partial strings
# on ']', pop count k and prev_str; assembled = prev_str + current * k
```

**Delayed evaluation for operator precedence**

```ruby
# Basic Calculator II: scan number, remember LAST operator
# on '+ / -' push signed num; on '* / /' multiply/divide top-of-stack
# sum the stack at the end
```

**Stack of signs for parens**

```ruby
# Basic Calculator (I): sign_stack tracks cumulative sign through parens
# on '(' push current sign; on ')' pop; numbers use top-of-stack as multiplier
```

**Monotonic residue cleanup**

```ruby
# Remove K Digits / Next Smaller: when a smaller number appears,
# pop the stack while top > current AND we still have pops left
# stack ends up as the lexicographically smallest answer
```

**LRU Cache — O(1) get and put**

```ruby
# doubly linked list (most-recent at head, LRU at tail) + HashMap of key → node
# get:  move node to head, return val
# put:  if key exists update + move to head
#       else create at head; if over capacity, evict tail
# the list maintains ORDER; the hash gives O(1) access to any node
```

**LFU Cache — O(1) get and put**

```ruby
# needs THREE data structures:
#   key_map:   key → [value, freq]
#   freq_map:  freq → OrderedDict/LinkedHashSet of keys (insertion order = recency)
#   min_freq:  integer tracking current minimum frequency
#
# get(key):
#   increment freq for key
#   move key from freq_map[old_freq] to freq_map[new_freq]
#   if freq_map[min_freq] is now empty → min_freq += 1
#
# put(key, val):
#   if key exists → update value + call get logic (bump freq)
#   else:
#     if at capacity → evict LRU from freq_map[min_freq] (first inserted = oldest)
#     insert key with freq=1, min_freq = 1
#
# in Ruby, use a Hash as an ordered map (Ruby hashes preserve insertion order)
```

```ruby
class LFUCache
  def initialize(capacity)
    @cap      = capacity
    @key_map  = {}                          # key → [val, freq]
    @freq_map = Hash.new { |h, k| h[k] = {} }  # freq → {key => true} (ordered)
    @min_freq = 0
  end

  def get(key)
    return -1 unless @key_map[key]
    val, freq = @key_map[key]
    bump(key, val, freq)
    val
  end

  def put(key, value)
    return if @cap == 0
    if @key_map[key]
      bump(key, value, @key_map[key][1])
    else
      evict if @key_map.size == @cap
      @key_map[key] = [value, 1]
      @freq_map[1][key] = true
      @min_freq = 1
    end
  end

  private

  def bump(key, val, freq)
    @freq_map[freq].delete(key)
    @min_freq += 1 if @freq_map[@min_freq].empty?
    new_freq = freq + 1
    @key_map[key] = [val, new_freq]
    @freq_map[new_freq][key] = true
  end

  def evict
    lru_key = @freq_map[@min_freq].first[0]   # oldest key at min freq
    @freq_map[@min_freq].delete(lru_key)
    @key_map.delete(lru_key)
  end
end
```

**LRU vs LFU — when each evicts**

```
LRU: evicts the key that was accessed LEAST RECENTLY (time-based)
LFU: evicts the key with the LOWEST ACCESS FREQUENCY
     tie-break on frequency → evict the LEAST RECENTLY USED among tied keys
LFU is strictly harder: needs freq tracking on top of recency tracking
```

**When to use stack vs recursion**

```ruby
# stack makes iteration + undo explicit (safer on huge inputs)
# recursion reads cleaner but risks stack-overflow on adversarial input
```

---

## Decision Checklist

```
matching pairs?                  → stack
LIFO processing needed?          → stack
evaluate expression / RPN?       → stack
next greater / smaller element?  → monotonic stack (pattern 17)
need min/max in O(1)?            → auxiliary min/max stack
convert recursion to iteration?  → explicit stack
O(1) cache with recency eviction?→ LRU (DLL + HashMap)
O(1) cache with freq eviction?   → LFU (freq_map + min_freq + ordered keys)
```

---

## Solved

- [ ] 20 — Valid Parentheses
- [ ] 155 — Min Stack
- [ ] 232 — Implement Queue using Stacks
- [ ] 225 — Implement Stack using Queues
- [ ] 682 — Baseball Game
- [ ] 1047 — Remove All Adjacent Duplicates
- [ ] 150 — Evaluate Reverse Polish Notation
- [ ] 394 — Decode String
- [ ] 227 — Basic Calculator II
- [ ] 71 — Simplify Path
- [ ] 735 — Asteroid Collision
- [ ] 402 — Remove K Digits
- [ ] 678 — Valid Parenthesis String
- [ ] 636 — Exclusive Time of Functions
- [ ] 503 — Next Greater Element II
- [ ] 146 — LRU Cache
- [ ] 460 — LFU Cache
- [ ] GFG — First Non-Repeating Character in Stream
- [ ] 224 — Basic Calculator
- [ ] 772 — Basic Calculator III
- [ ] 84 — Largest Rectangle in Histogram
