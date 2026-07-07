#!/usr/bin/env bash
set -euo pipefail

payload="$(cat)"
command_text="$(
    jq -r '
        .tool_input.command //
        .tool_input.cmd //
        .input.command //
        .input.cmd //
        .arguments.command //
        .arguments.cmd //
        .params.command //
        .params.cmd //
        .command //
        .cmd //
        ""
    ' <<<"$payload" 2>/dev/null || printf ''
)"

if [[ -z "$command_text" ]]; then
    exit 0
fi

normalised="$(tr '\n' ' ' <<<"$command_text")"

if grep -Eq '(^|[;&|({[:space:]])(sudo[[:space:]]+|command[[:space:]]+|builtin[[:space:]]+|env[[:space:]]+)*(/usr/bin/|/bin/)?rm([[:space:]]|$)' <<<"$normalised" \
    || grep -Eq '(^|[;&|({[:space:]])xargs([^;&|()]*)[[:space:]]+(/usr/bin/|/bin/)?rm([[:space:]]|$)' <<<"$normalised"; then
    cat >&2 <<'EOF'
Blocked: do not use rm in AI-run shell commands.
Use gomi for deletions instead. If permanent deletion is truly required, ask the user for explicit approval and explain the exact path and reason.
EOF
    exit 2
fi
