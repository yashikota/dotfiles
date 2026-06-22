---
name: add-tool
description: Add a new CLI tool to the dotfiles setup (aqua, apt, brew, or manual install)
---
When adding a new CLI tool to this dotfiles repository, follow these steps:

1. **Determine install method** (preference order):
   - aqua (preferred) — check with `aqua g <tool-name>`
   - brew (macOS) + apt/alternative (Linux)
   - Manual install script

2. **If aqua**: Add to `.config/aquaproj-aqua/aqua.yaml`, keep alphabetical order by registry path

3. **If brew**: Add to `mac/Brewfile`

4. **If apt or other Linux method**: Add to `linux/tools.toml` under the appropriate section (apt/curl/cargo/go/script)

5. **If it needs PATH or env config**:
   - Add to `.config/zsh/.zshrc` (or a new file in `.config/zsh/functions/`)
   - Add equivalent to `.config/fish/config.fish`

6. **If it has XDG-compatible config**:
   - Create `.config/<tool>/` directory with config files
   - link.sh handles symlinking automatically

7. **If it's a significant tool**: Update CLAUDE.md key tool configs table

8. **Verify**:
   - Run `aqua i` if added to aqua.yaml
   - Check the tool is accessible: `which <tool-name>`
