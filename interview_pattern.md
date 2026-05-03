# Interview Problem-Solving Pattern

Use this with the reusable write-up template in [problem_solution_template.md](./problem_solution_template.md).

## The Steps

### 1. Understand the Problem
- Read carefully, make sure you get what's being asked
- Restate it in your own words to the interviewer

### 2. Clarifying Questions
- Is the input sorted?
- Can there be duplicates?
- What are the constraints? (size, value range)
- What should we return for empty input?
- Any edge cases to handle upfront?

### 3. Brute Force First
- Don't jump to optimal — think naive solution first
- State it out loud even if it's slow
- Shows you can solve the problem before optimizing

### 4. Identify the Bottleneck
- What's slow? Why?
- Nested loops? → O(n²)
- Repeated work? → Can we cache?
- Unnecessary comparisons? → Can we sort/preprocess?

### 5. Optimize
- What insight removes the bottleneck?
- Common patterns: sort, hash map, two pointers, sliding window, binary search
- State the insight clearly before coding

### 6. Code
- Write clean, readable code based on the optimized approach
- Name variables clearly
- Don't over-engineer

### 7. Dry Run
- Trace through an example by hand
- Use the given example first, then try your own
- Catch off-by-one errors or missed edge cases

### 8. Complexity Analysis
- Time complexity
- Space complexity
- Ask: what if input was pre-sorted / pre-processed?

### 9. Edge Cases
- Empty input
- Single element
- All same elements
- Already sorted / reverse sorted
- Fully contained intervals, touching boundaries, etc.

---

## Key Habit
> Never jump to optimal directly.
> Brute force → bottleneck → optimize shows your thinking process,
> which is what interviewers actually care about.
> move to next step only if prev step is clear.
