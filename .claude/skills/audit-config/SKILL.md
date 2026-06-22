---
name: audit-config
description: Audit Claude Code configuration (.claude/) against best practices from the official steering guide
---
Audit the current `.claude/` configuration against the best practices documented in the Claude Code steering guide. Check each area below and report findings as a checklist.

## Checklist

### CLAUDE.md
- [ ] Under 200 lines
- [ ] Contains: build commands, directory structure, coding conventions
- [ ] No procedural instructions that should be a Skill (30+ line how-to blocks)
- [ ] No "every time X, always do Y" patterns that should be Hooks
- [ ] No "never do X" that should be enforced by Hooks + Permissions
- [ ] No personal preferences that belong in user-level settings

### Rules (.claude/rules/)
- [ ] Path-scoped rules exist for directories with special conventions
- [ ] Rules are concise (constraint + reason, not tutorials)
- [ ] No duplicate content between rules and CLAUDE.md

### Skills (.claude/skills/)
- [ ] Repetitive multi-step workflows are captured as skills
- [ ] Each skill has a clear trigger description
- [ ] Skills are procedural (step-by-step), not declarative (that belongs in rules)

### Agents (.claude/agents/)
- [ ] Tasks requiring deep isolated exploration have dedicated agents
- [ ] Agent descriptions clearly state what they do (for auto-matching)
- [ ] Model is specified (prefer sonnet for cost-efficiency unless complexity demands opus)

### Hooks (settings.json)
- [ ] Deterministic checks (linting, formatting, validation) use hooks, not CLAUDE.md instructions
- [ ] Hooks have appropriate matchers (not overly broad)
- [ ] No hooks that duplicate permission deny rules

### Permissions (settings.json)
- [ ] Dangerous commands are in deny list (force-push, rm -rf, etc.)
- [ ] Frequently used safe commands are in allow list to reduce prompts
- [ ] Destructive-but-sometimes-needed commands are in ask list

### Settings (settings.json)
- [ ] No redundant settings (e.g. deprecated fields still present)
- [ ] Plugins are relevant to actual workflow (no unused plugins)

## Output Format

For each item, report:
- PASS: meets best practice
- WARN: minor improvement possible (describe what)
- FAIL: violates best practice (describe fix)

End with a prioritized list of recommended changes.
