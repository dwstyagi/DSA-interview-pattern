# Pattern 00 — Strings

## Recognize It

Ask yourself:

- Is the problem about **substrings, subsequences, or character frequency**?
- Do you need to **parse, transform, or validate** a string?
- Is there a **palindrome** structure to exploit?
- Does it involve **pattern matching** or character-by-character comparison?

String problems rarely have a single "pattern" — they combine multiple techniques. This file covers string-specific tricks and problems that don't cleanly fit elsewhere.

---

## Core Techniques

### 1. Two-Pointer on String (Palindrome / Expand Around Center)

```ruby
# check palindrome in O(n)
def palindrome?(s)
  l, r = 0, s.length - 1
  while l < r
    return false if s[l] != s[r]
    l += 1; r -= 1
  end
  true
end

# longest palindromic substring — expand around each center
def longest_palindrome(s)
  result = ""
  (0...s.length).each do |i|
    [expand(s, i, i), expand(s, i, i + 1)].each do |sub|
      result = sub if sub.length > result.length
    end
  end
  result
end

def expand(s, l, r)
  l -= 1; r += 1 while l >= 0 && r < s.length && s[l] == s[r]
  s[(l + 1)...r]
end
```

---

### 2. Character Frequency / Hash Map

```ruby
# anagram check — O(n)
def anagram?(s, t)
  return false if s.length != t.length
  s.chars.tally == t.chars.tally
end

# first non-repeating character
def first_unique(s)
  freq = s.chars.tally
  s.each_char { |c| return c if freq[c] == 1 }
  nil
end
```

---

### 3. Atoi (String to Integer parsing)

```ruby
def my_atoi(str)
  s = str.lstrip
  return 0 if s.empty?

  sign = 1
  i = 0
  if s[0] == '+' || s[0] == '-'
    sign = s[0] == '-' ? -1 : 1
    i = 1
  end

  result = 0
  while i < s.length && s[i].match?(/\d/)
    result = result * 10 + s[i].to_i
    i += 1
  end

  sign * result.clamp(-2**31, 2**31 - 1)
end
```

---

### 4. Reverse Words

```ruby
def reverse_words(s)
  s.split.reverse.join(' ')
  # split without args handles leading/trailing/multiple spaces
end
```

---

### 5. String Rotation Check

```ruby
# s2 is a rotation of s1 iff s2 is a substring of s1 + s1
def rotation?(s1, s2)
  return false if s1.length != s2.length
  (s1 + s1).include?(s2)
end
```

---

## Problem List

### Easy

| #   | Problem               | LC                                                                                      | Technique       | Track                   |
| --- | --------------------- | --------------------------------------------------------------------------------------- | --------------- | ----------------------- |
| 1   | Valid Anagram         | [242](https://leetcode.com/problems/valid-anagram/)                                     | Tally           | freq hash               |
| 2   | Reverse String        | [344](https://leetcode.com/problems/reverse-string/)                                    | Two pointer     | in-place swap           |
| 3   | Valid Palindrome      | [125](https://leetcode.com/problems/valid-palindrome/)                                  | Two pointer     | alphanumeric filter     |
| 4   | Longest Common Prefix | [14](https://leetcode.com/problems/longest-common-prefix/)                              | Vertical scan   | shared prefix           |
| 5   | Roman to Integer      | [13](https://leetcode.com/problems/roman-to-integer/)                                   | Hash + scan     | subtract if prev < curr |
| 6   | Implement strStr()    | [28](https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/) | Sliding / KMP   | match index             |
| 7   | Is Subsequence        | [392](https://leetcode.com/problems/is-subsequence/)                                    | Two pointer     | advance on match        |
| 8   | Reverse Words III     | [557](https://leetcode.com/problems/reverse-words-in-a-string-iii/)                     | Split + reverse | word-level              |

### Medium

| #   | Problem                             | LC                                                                                 | Technique            | Track              |
| --- | ----------------------------------- | ---------------------------------------------------------------------------------- | -------------------- | ------------------ |
| 9   | Longest Palindromic Substring       | [5](https://leetcode.com/problems/longest-palindromic-substring/)                  | Expand around center | odd + even         |
| 10  | Reverse Words in a String           | [151](https://leetcode.com/problems/reverse-words-in-a-string/)                    | Split + reverse      | trim spaces        |
| 11  | String to Integer (Atoi)            | [8](https://leetcode.com/problems/string-to-integer-atoi/)                         | Parsing              | sign + overflow    |
| 12  | Longest Substring Without Repeating | [3](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Sliding window       | see pattern 01     |
| 13  | Group Anagrams                      | [49](https://leetcode.com/problems/group-anagrams/)                                | Sort key             | hash of sorted     |
| 14  | Longest Palindromic Subsequence     | [516](https://leetcode.com/problems/longest-palindromic-subsequence/)              | 2D DP                | LCS of s + rev(s)  |
| 15  | Decode Ways                         | [91](https://leetcode.com/problems/decode-ways/)                                   | 1D DP                | 1 or 2 char decode |
| 16  | Minimum Window Substring            | [76](https://leetcode.com/problems/minimum-window-substring/)                      | Sliding window       | see pattern 01     |
| 17  | Count and Say                       | [38](https://leetcode.com/problems/count-and-say/)                                 | Simulation           | run-length encode  |
| 18  | Rotate String                       | [796](https://leetcode.com/problems/rotate-string/)                                | Doubled string       | s1+s1 contains s2  |
| 19  | Multiply Strings                    | [43](https://leetcode.com/problems/multiply-strings/)                              | Grade-school mult    | digit arrays       |
| 20  | Zigzag Conversion                   | [6](https://leetcode.com/problems/zigzag-conversion/)                              | Simulation           | row cycling        |

### Hard

| #   | Problem                     | LC                                                               | Technique        | Track                     |
| --- | --------------------------- | ---------------------------------------------------------------- | ---------------- | ------------------------- |
| 21  | Edit Distance               | [72](https://leetcode.com/problems/edit-distance/)               | 2D DP            | see pattern 19            |
| 22  | Regular Expression Matching | [10](https://leetcode.com/problems/regular-expression-matching/) | 2D DP            | see pattern 19            |
| 23  | Shortest Palindrome         | [214](https://leetcode.com/problems/shortest-palindrome/)        | KMP / Z-function | longest prefix palindrome |
| 24  | Longest Common Substring    | GFG                                                              | 2D DP            | dp[i][j] match + reset    |

---

## Key Tricks to Remember

**Roman to Integer — subtract when previous < current**

```ruby
map = { 'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50,
        'C' => 100, 'D' => 500, 'M' => 1000 }
result = 0
(0...s.length).each do |i|
  if i + 1 < s.length && map[s[i]] < map[s[i + 1]]
    result -= map[s[i]]
  else
    result += map[s[i]]
  end
end
```

**Group Anagrams — sorted string as hash key**

```ruby
words.group_by { |w| w.chars.sort.join }
# O(n * L log L) where L = avg word length
```

**Expand around center — always check both odd and even**

```ruby
# odd-length:  expand(s, i, i)
# even-length: expand(s, i, i + 1)
# forgetting the even case is the most common palindrome bug
```

**Atoi — strict order of operations**

```ruby
# 1. lstrip whitespace
# 2. read optional +/-
# 3. read digits, stop at first non-digit
# 4. clamp to [-2^31, 2^31 - 1]
# return 0 for empty or all-whitespace input
```

**LCS vs Longest Common Substring**

```ruby
# LCS (subsequence): not contiguous
#   match:   dp[i][j] = dp[i-1][j-1] + 1
#   no match: dp[i][j] = max(dp[i-1][j], dp[i][j-1])

# Longest Common Substring: must be contiguous
#   match:   dp[i][j] = dp[i-1][j-1] + 1
#   no match: dp[i][j] = 0            ← key difference
#   track global max separately
```

**String rotation → doubled string**

```ruby
(s1 + s1).include?(s2)   # O(n) with KMP under the hood
# works because every rotation of s1 is a substring of s1+s1
```

---

## Decision Checklist

```
palindrome check?               → two-pointer from ends
longest palindromic substring?  → expand around center
anagram / permutation in string?→ sliding window (pattern 01)
substring search / match?       → KMP or sliding window
string DP (LCS, edit, match)?   → 2D DP (pattern 19)
parsing (Atoi, calculator)?     → state machine + sign + digit loop
word-level reversal?            → split + reverse + join
rotation check?                 → s1 + s1 contains s2
```

---

## Solved

- [ ] 242 — Valid Anagram
- [ ] 344 — Reverse String
- [ ] 125 — Valid Palindrome
- [ ] 14 — Longest Common Prefix
- [ ] 13 — Roman to Integer
- [ ] 28 — Implement strStr()
- [ ] 392 — Is Subsequence
- [ ] 557 — Reverse Words III
- [ ] 5 — Longest Palindromic Substring
- [ ] 151 — Reverse Words in a String
- [ ] 8 — String to Integer (Atoi)
- [ ] 3 — Longest Substring Without Repeating
- [ ] 49 — Group Anagrams
- [ ] 516 — Longest Palindromic Subsequence
- [ ] 91 — Decode Ways
- [ ] 76 — Minimum Window Substring
- [ ] 38 — Count and Say
- [ ] 796 — Rotate String
- [ ] 43 — Multiply Strings
- [ ] 6 — Zigzag Conversion
- [ ] 72 — Edit Distance
- [ ] 10 — Regular Expression Matching
- [ ] 214 — Shortest Palindrome
- [ ] GFG — Longest Common Substring
