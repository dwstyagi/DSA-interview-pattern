# frozen_string_literal: true

# LeetCode 721: Accounts Merge
#
# Problem:
# Given accounts where accounts[i][0] is name and rest are emails, merge accounts
# sharing any email. Return merged accounts with sorted emails.
#
# -----------------------------------------------------------------------------
# Interview Flow
#
# 1. True Brute Force
#    For each pair of accounts, check if they share an email. Merge if so. Repeat.
#    Time Complexity: O(n^2 * m) where m = avg emails per account
#    Space Complexity: O(n * m)
#
# 2. Bottleneck
#    Repeated pairwise checking. Union-Find: map each email to a representative.
#    Union accounts sharing an email.
#
# 3. Optimized Accepted Approach
#    Assign each account an index. For each email, union current account with
#    first account that claimed this email. Group accounts by root, collect emails.
#
#    Time Complexity: O(n * m * alpha(n))
#    Space Complexity: O(n * m)
#
# -----------------------------------------------------------------------------
# Dry Run
#
# accounts=[["John","a","b"],["John","c"],["John","b","c"]]
# email->first_account: a->0, b->0, c->1
# account 2: b already owned by 0 -> union(2,0); c owned by 1 -> union(2,1)
# roots: 0,1,2 all same -> merge into one account
#
# Edge Cases:
# - No shared emails: return original accounts sorted
# - Single account: return as-is

def accounts_merge_brute(accounts)
  email_to_accounts = Hash.new { |h, k| h[k] = [] }
  accounts.each_with_index do |account, i|
    account[1..].each { |email| email_to_accounts[email] << i }
  end

  visited = Array.new(accounts.length, false)
  result = []

  accounts.each_with_index do |account, i|
    next if visited[i]
    emails = Set.new
    queue = [i]
    while queue.any?
      idx = queue.pop
      next if visited[idx]
      visited[idx] = true
      accounts[idx][1..].each do |email|
        emails.add(email)
        email_to_accounts[email].each { |j| queue << j unless visited[j] }
      end
    end
    result << ([account[0]] + emails.to_a.sort)
  end
  result
end

# optimized: Union-Find approach
def accounts_merge(accounts)
  parent = Array.new(accounts.length) { |i| i }
  find = lambda { |x| parent[x] = find.call(parent[x]) unless parent[x] == x; parent[x] }
  email_owner = {}

  accounts.each_with_index do |account, i|
    account[1..].each do |email|
      if email_owner.key?(email)
        pi, pe = find.call(i), find.call(email_owner[email])
        parent[pi] = pe unless pi == pe
      else
        email_owner[email] = i
      end
    end
  end

  groups = Hash.new { |h, k| h[k] = Set.new }
  email_owner.each { |email, i| groups[find.call(i)].add(email) }
  groups.map { |root, emails| [accounts[root][0]] + emails.to_a.sort }
end

if __FILE__ == $PROGRAM_NAME
  accounts = [['John', 'a@x.com', 'b@x.com'], ['John', 'c@x.com'], ['John', 'b@x.com', 'c@x.com']]
  puts accounts_merge_brute(accounts).inspect
  puts accounts_merge(accounts).inspect
end
