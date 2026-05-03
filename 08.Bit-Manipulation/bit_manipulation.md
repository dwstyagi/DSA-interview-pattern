# Pattern 08 — Bit Manipulation

## Recognize It

Ask yourself:
- Is there an element appearing **once** while others appear **twice / three times**?
- Do you need to **count set bits**, toggle, or check powers of two?
- Is the state space small enough (≤ 20-30 items) to encode as a **bitmask**?
- Is the problem about **subsets, parity, or XOR tricks**?

If yes → Bit Manipulation.

---

## Core Operations (know these cold)

```ruby
n & 1                 # last bit (parity)
n >> 1                # divide by 2 (drop LSB)
n << 1                # multiply by 2
n | (1 << k)          # set bit k
n & ~(1 << k)         # clear bit k
n ^ (1 << k)          # toggle bit k
(n >> k) & 1          # read bit k
n & (n - 1)           # drop lowest set bit  ← Brian Kernighan
n & -n                # isolate lowest set bit
n == (n & -n)         # is power of two?  (for n > 0)
```

---

## Core Templates

### 1. XOR to Find the Unique Element

```
a ^ a = 0,  a ^ 0 = a,  XOR is commutative & associative
→ XOR of all elements cancels duplicates, leaving the unique one
```

```ruby
def single_number(nums)
  nums.reduce(0, :^)
end
```

---

### 2. Count Set Bits (Brian Kernighan)

```ruby
def count_bits(n)
  c = 0
  while n > 0
    n &= (n - 1)     # drop lowest set bit
    c += 1
  end
  c
end
```

---

### 3. Iterate All Subsets via Bitmask

```ruby
def all_subsets(nums)
  n = nums.length
  result = []

  (0...(1 << n)).each do |mask|
    subset = []
    (0...n).each { |i| subset << nums[i] if (mask >> i) & 1 == 1 }
    result << subset
  end

  result
end
```

---

### 4. Two Unique Numbers (all others appear twice)

```ruby
def single_number_iii(nums)
  xor = nums.reduce(0, :^)              # a ^ b
  bit = xor & -xor                      # any set bit where a, b differ
  a = b = 0
  nums.each { |n| (n & bit) == 0 ? a ^= n : b ^= n }
  [a, b]
end
```

---

## Problem List

### Easy

| # | Problem | LC | Trick | Track |
|---|---------|-----|-------|-------|
| 1 | Single Number | [136](https://leetcode.com/problems/single-number/) | XOR cancels pairs | reduce ^ |
| 2 | Number of 1 Bits | [191](https://leetcode.com/problems/number-of-1-bits/) | Brian Kernighan | n & (n-1) |
| 3 | Power of Two | [231](https://leetcode.com/problems/power-of-two/) | Single set bit | n & (n-1) == 0 |
| 4 | Missing Number | [268](https://leetcode.com/problems/missing-number/) | XOR with indices | 0..n ^ nums |
| 5 | Reverse Bits | [190](https://leetcode.com/problems/reverse-bits/) | Shift accumulate | 32 passes |
| 6 | Power of Four | [342](https://leetcode.com/problems/power-of-four/) | Power-of-2 + mask | & 0x55555555 |

### Medium

| # | Problem | LC | Trick | Track |
|---|---------|-----|-------|-------|
| 7 | Single Number II | [137](https://leetcode.com/problems/single-number-ii/) | Bit-count mod 3 | bit-by-bit sum |
| 8 | Single Number III | [260](https://leetcode.com/problems/single-number-iii/) | Diff bit split | a^b → partition |
| 9 | Counting Bits | [338](https://leetcode.com/problems/counting-bits/) | DP on bits | dp[i] = dp[i>>1]+(i&1) |
| 10 | Sum of Two Integers | [371](https://leetcode.com/problems/sum-of-two-integers/) | Add without + | XOR + carry |
| 11 | Bitwise AND of Range | [201](https://leetcode.com/problems/bitwise-and-of-numbers-range/) | Common prefix | right-shift both |
| 12 | Subsets | [78](https://leetcode.com/problems/subsets/) | Bitmask enum | 2^n masks |
| 13 | Maximum XOR of Two Numbers | [421](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) | Trie of bits | greedy MSB |
| 14 | Gray Code | [89](https://leetcode.com/problems/gray-code/) | i ^ (i >> 1) | formula |
| 15 | Find the Difference | [389](https://leetcode.com/problems/find-the-difference/) | XOR all chars | s ^ t |
| 16 | Complement of Base 10 Integer | [1009](https://leetcode.com/problems/complement-of-base-10-integer/) | Mask flip | all-ones mask |

### Hard

| # | Problem | LC | Trick | Track |
|---|---------|-----|-------|-------|
| 17 | Maximum Product of Word Lengths | [318](https://leetcode.com/problems/maximum-product-of-word-lengths/) | Letter bitmask | disjoint check |
| 18 | Smallest Sufficient Team | [1125](https://leetcode.com/problems/smallest-sufficient-team/) | DP on skill mask | bitmask state |

---

## Key Tricks to Remember

**XOR identity chain**
```ruby
# XOR of any number with itself = 0
# so in a sea of pairs with one lone element, XOR-all = the lone one
# extends to "one appears once, others appear even times"
```

**Brian Kernighan's bit counting**
```ruby
# n & (n - 1) drops the lowest set bit
# loop count = number of set bits (faster than checking every bit)
```

**The -n trick (two's complement)**
```ruby
n & -n   # isolates the lowest set bit
         # works because -n = ~n + 1, which flips everything above lowest bit
```

**Bitmask as a "set" of up to 30 items**
```ruby
mask | (1 << i)      # add item i
mask & ~(1 << i)     # remove item i
mask & (1 << i)      # check item i
__builtin_popcount(mask)   # set size (use your language's equivalent)
```

**Iterate all subsets of a mask**
```ruby
sub = mask
while sub > 0
  # process sub
  sub = (sub - 1) & mask
end
# plus 0 at the end (empty subset)
```

**Single Number II (each appears 3x except one)**
```ruby
# count each bit position mod 3; leftover bits form the unique number
# or: ones, twos state machine  (two bit-vectors, XOR-based update)
```

---

## Decision Checklist

```
find unique in pairs?          → XOR all
count set bits?                → Brian Kernighan
power of two?                  → n > 0 && n & (n-1) == 0
subsets / permutations small n?→ bitmask enumeration (n ≤ 20-ish)
pick best from subset DP?      → DP with state = bitmask of used items
range AND?                     → find common MSB prefix
```

---

## Solved
- [ ] 136 — Single Number
- [ ] 191 — Number of 1 Bits
- [ ] 231 — Power of Two
- [ ] 268 — Missing Number
- [ ] 190 — Reverse Bits
- [ ] 342 — Power of Four
- [ ] 137 — Single Number II
- [ ] 260 — Single Number III
- [ ] 338 — Counting Bits
- [ ] 371 — Sum of Two Integers
- [ ] 201 — Bitwise AND of Range
- [ ] 78 — Subsets
- [ ] 421 — Maximum XOR of Two Numbers
- [ ] 89 — Gray Code
- [ ] 389 — Find the Difference
- [ ] 1009 — Complement of Base 10 Integer
- [ ] 318 — Max Product of Word Lengths
- [ ] 1125 — Smallest Sufficient Team