---
name: review-responder
description: >
  Respond to GitHub PR review comments — triage each comment (actionable vs. dismissible),
  apply code fixes for valid feedback, reply in the reviewer's language explaining the
  decision, resolve the thread, then commit and push. Use this skill whenever the user asks
  to handle, process, respond to, or work through GitHub review comments or PR feedback.
  Trigger phrases include: "レビュー対応して", "handle the review", "PRのコメント直して",
  "review comments", "address feedback", "コメントを処理して", "レビューを処理して",
  "対応お願い", "fix the review".
---

## Goal

Work through every unresolved review comment on a GitHub PR. For each comment:
1. Decide whether it is **actionable** or **dismissible**
2. If actionable → fix the code
3. Reply explaining what was done (or why it was dismissed), in the same language as the comment
4. Resolve the thread
5. After all comments are processed → commit the changes and push

---

## Step 1 — Gather context

```bash
# Get the PR number (ask the user if unknown)
gh pr view --json number,title,body,baseRefName,headRefName

# Fetch all review threads via GraphQL, paginating until hasNextPage is false
CURSOR=""
while true; do
  RESULT=$(gh api graphql -f query='
    query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $number) {
          reviewThreads(first: 100, after: $cursor) {
            pageInfo { hasNextPage endCursor }
            nodes {
              id
              isResolved
              path
              line
              comments(first: 100) {
                nodes {
                  id
                  databaseId
                  diffHunk
                  body
                  author { login }
                }
              }
            }
          }
        }
      }
    }
  ' -F owner="<OWNER>" -F repo="<REPO>" -F number=<PR_NUMBER> -F cursor="$CURSOR")
  echo "$RESULT"
  HAS_NEXT=$(echo "$RESULT" | jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage')
  [ "$HAS_NEXT" = "true" ] || break
  CURSOR=$(echo "$RESULT" | jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.endCursor')
done
```

Read the PR description and linked issue/ticket (if any) to understand the product intent — you will need this when judging comments.

---

## Step 2 — Classify each comment

For every unresolved thread, decide:

| Verdict | Examples |
|---------|---------|
| **Actionable** | Bug pointed out, logic error, crash risk, security issue, violation of a project convention documented in CLAUDE.md / README, missing test for a stated requirement |
| **Dismissible** | Pure style preference not backed by a linter rule, misunderstanding of the code, information the reviewer had wrong (stale API docs, outdated assumption), request that contradicts the stated ticket / product direction |

**Key heuristic**: if fixing the comment makes the product more correct, more robust, or more aligned with the stated requirements — it is actionable. If it is a matter of opinion without a backing standard, or based on incorrect premises — it is dismissible.

Style/formatting comments are always dismissible because lint/format tools handle those. Do **not** make manual formatting changes.

---

## Step 3 — Fix actionable comments

- Make the minimal change that addresses the concern
- Do not refactor unrelated code while fixing
- One logical change per comment; if multiple comments touch the same file, batch the edits sensibly

---

## Step 4 — Reply and resolve each thread

Reply in the **same language as the comment** (Japanese → Japanese, English → English).

### Actionable reply template
> 修正しました。[何をどう変えたか、1〜2文で説明]

> Fixed. [1–2 sentences explaining what was changed and why]

### Dismissible reply template
> この指摘は [理由] のため、今回は対応を見送ります。[誤解や前提の違いがあれば補足]

> Not addressing this one because [reason]. [Optional: clarify the misunderstanding or context]

Use `gh` to post the reply and resolve:

```bash
# Post a reply to a specific thread
# IMPORTANT: {comment_id} must be the integer databaseId of the *first* comment in the thread
# (not the GraphQL node id string, and not a reply's id — replies to replies are unsupported)
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo}/pulls/{pull_number}/comments/{comment_id}/replies \
  -f body="<your reply>"

# Resolve the thread (GraphQL is the only way — no REST endpoint exists for this)
gh api graphql -f query='
  mutation {
    resolveReviewThread(input: {threadId: "<THREAD_NODE_ID>"}) {
      thread { isResolved }
    }
  }
'
```

---

## Step 5 — Commit and push

After all comments are processed:

```bash
git add <files>   # Stage only the review-driven files explicitly (avoid -p; it's interactive and blocks agents)
git commit -m "address review comments"
git push
```

Commit message convention: imperative mood, lowercase, no period (matches this repo's style).

If no code changes were made (all comments were dismissed), skip the commit.

---

## Handling ambiguity

- If a comment is genuinely unclear, post a clarifying question as a reply instead of guessing
- If you are unsure whether something is a project convention, check CLAUDE.md and the codebase before dismissing
- If the PR has no unresolved threads, tell the user and stop

---

## What NOT to do

- Do not make speculative improvements beyond what the comments ask for
- Do not change formatting or style (linters own that)
- Do not resolve threads without leaving a reply — the reviewer deserves an explanation either way
- Do not push without a commit message that reflects what was done
