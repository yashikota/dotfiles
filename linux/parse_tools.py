#!/usr/bin/env python3
"""Parse tools.toml and emit tool metadata.

Usage:
  parse_tools.py names  [path]          # one tool name per line
  parse_tools.py json   [path]          # JSON array of names (for CI matrix)
  parse_tools.py get    [path] <tool>   # key=value lines for a single tool
"""

import json
import re
import sys


def parse_toml(path):
    try:
        import tomllib

        with open(path, "rb") as f:
            return tomllib.load(f)
    except ImportError:
        pass
    # fallback: simple regex parser for flat TOML sections
    text = open(path).read()
    result = {}
    for m in re.finditer(
        r"^\[([\w-]+)\]\s*$(.*?)(?=^\[|\Z)", text, re.M | re.S
    ):
        name = m.group(1)
        cfg = dict(re.findall(r'^(\w+)\s*=\s*"([^"]*)"', m.group(2), re.M))
        result[name] = cfg
    return result


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "names"
    path = sys.argv[2] if len(sys.argv) > 2 else "linux/tools.toml"
    data = parse_toml(path)

    if mode == "names":
        for name in data:
            print(name)
    elif mode == "json":
        print(json.dumps(list(data.keys())))
    elif mode == "get":
        tool = sys.argv[3]
        cfg = data.get(tool, {})
        for k, v in cfg.items():
            escaped = v.replace("'", "'\\''")
            print(f"{k}='{escaped}'")


if __name__ == "__main__":
    main()
