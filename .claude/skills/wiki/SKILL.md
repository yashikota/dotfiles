---
name: wiki
description: "Maintain the personal Obsidian wiki at ~/obsidian. Ingest sources (raw files, diary, dev notes, etc.), answer queries, and keep wiki/contents/ up to date."
---

# wiki — Personal Obsidian knowledge base

Vault: `~/obsidian`
Schema: `~/obsidian/AGENTS.md` — **read this first before any operation.**

## Operations

### ingest — Add a source to the wiki

Triggered by: "〇〇を読んで wiki に追加して", "このURL を ingest して", "dev/xxx.md を wiki に取り込んで"

Flow:
1. Read `AGENTS.md` for current schema and conventions
2. Read `wiki/contents/index.md` to understand existing structure
3. Read the source (file path or URL)
4. Discuss key takeaways if the user is present; otherwise proceed autonomously
5. Create `wiki/contents/sources/<title>.md` (summary page)
6. Update relevant `entities/`, `concepts/` pages (create if missing)
7. Append entry to top of `wiki/contents/log.md`
8. Update `wiki/contents/index.md`
9. git commit and push

```bash
cd ~/obsidian
git add wiki/contents/
git -c user.name="claw" -c user.email="claw@openclaw.local" \
    commit -m "wiki: ingest <title>"
git push
```

### query — Answer questions using the wiki

Triggered by: "wiki で〇〇を調べて", "〇〇について wiki は何て言ってる？"

Flow:
1. Read `wiki/contents/index.md`
2. Read relevant pages from `contents/`
3. If needed, read source dirs (`日記/`, `dev/`, etc.) for additional context
4. Synthesize answer with `[[page]]` citations
5. If the answer is valuable, save it as `wiki/contents/analyses/<title>.md` and update index + log

### lint — Health-check the wiki

Triggered by: "wiki を lint して", "wiki の状態チェックして"

Check for:
- Orphan pages (no inbound links)
- Stale claims superseded by newer sources
- Important concepts mentioned but lacking their own page
- Missing cross-references
- Pages with no frontmatter

### update — Revise existing pages

Triggered by: "wiki の〇〇ページを更新して", "新しい情報が出たので反映して"

Always update `updated:` frontmatter date and append to `log.md`.

## Source directories (all read-only)

- `wiki/raw/` — explicitly added raw sources
- **everything else in the vault** — read-only sources; proactively read when relevant, no explicit permission needed

## Git convention

author: `claw <claw@openclaw.local>`
commit format: `wiki: <verb> <subject>` (e.g. `wiki: ingest lawn project`, `wiki: add concept/kubernetes`)
