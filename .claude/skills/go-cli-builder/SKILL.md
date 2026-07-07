---
name: go-cli-builder
description: Use when building a Go CLI tool as a releasable command binary. Invoke whenever the user wants to scaffold or extend a Go CLI project, set up CI/CD, add linting, testing, or release workflows to a Go binary project.
license: MIT
---

# Go CLI Builder

Use this skill when building a Go CLI tool as a releasable command binary.

## Project Shape

- Put the CLI entrypoint at the repository root as `main.go`.
- Keep `main.go` thin: configure process-wide logging, call the command package, translate known command errors to exit codes, log unexpected errors, and exit.
- Put command behavior outside `main.go`, typically under packages such as `internal`.
- Prefer standard Go project conventions before adding framework-specific structure.
- Write tests for pure-function parts.

## Package Manager (aqua)

Use `aqua` as the package manager. Initialize and install tools:

```sh
aqua init
aqua g -i suzuki-shunsuke/pinact golangci/golangci-lint go-task/task jiro4989/richgo
aqua i
```

## Task Runner (Taskfile)

Create `Taskfile.yaml` at the repository root. Use `task` for all developer operations — both locally and in CI — so `task <name>` is the only command anyone needs to remember.

Three tasks are required; everything else is added as the project needs it.

```yaml
version: "3"

tasks:
  default:
    desc: "Display this help message"
    cmds:
      - task -l

  lint:
    desc: "Lint"
    cmds:
      - golangci-lint run --fix
      - golangci-lint fmt

  test:
    desc: "Run all tests"
    deps: [test:unit]

  test:unit:
    desc: "Unit test"
    cmds:
      - richgo test -v -shuffle=on -race ./...
```

`test` is the stable entry point CI calls. Add sub-tasks (`test:scenario`, `test:integration`, etc.) as deps of `test` when the project needs them — no CI changes required.

## Version Information

Embed the release version through the package-level `Version` variable in `main.go`. Refer to this implementation:

```go
var Version string

func getVersion() string {
	if Version != "" {
		return Version
	}

	if info, ok := debug.ReadBuildInfo(); ok {
		if info.Main.Version != "(devel)" {
			return info.Main.Version
		}

		if v, ok := getVCSBuildVersion(info); ok {
			return v
		}
	}

	return "(unset)"
}

func getVCSBuildVersion(info *debug.BuildInfo) (string, bool) {
	var (
		revision string
		dirty    string
	)

	for _, v := range info.Settings {
		switch v.Key {
		case "vcs.revision":
			revision = v.Value
		case "vcs.modified":
			if v.Value == "true" {
				dirty = " (dirty)"
			}
		}
	}

	if revision == "" {
		return "", false
	}

	return revision + dirty, true
}
```

## CI Workflows

### check.yaml

Create `.github/workflows/check.yaml` for lint, format, and test runs triggered on every push to `main` and every PR. The workflow uses aqua to install tools and calls `task` directly — matching the local developer workflow exactly.

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  check:
    name: Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@HASH # vX.Y.Z

      - uses: actions/setup-go@HASH # vX.Y.Z
        with:
          go-version-file: go.mod
          cache: true

      - uses: actions/cache@HASH # vX.Y.Z
        with:
          path: ~/.local/share/aquaproj-aqua
          key: v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('aqua.yaml') }}
          restore-keys: |
            v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-

      - uses: aquaproj/aqua-installer@HASH # vX.Y.Z
        with:
          aqua_version: v2.60.1

      - name: Check
        run: task check

      - name: Verify no diff
        run: |
          if [ -n "$(git status --porcelain)" ]; then
            git status --short
            git diff --exit-code || true
            echo "::error::CI checks produced file changes. Run 'task check' locally and commit the result."
            exit 1
          fi

  test:
    name: Unit test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@HASH # vX.Y.Z

      - uses: actions/setup-go@HASH # vX.Y.Z
        with:
          go-version-file: go.mod
          cache: true

      - uses: actions/cache@HASH # vX.Y.Z
        with:
          path: ~/.local/share/aquaproj-aqua
          key: v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('aqua.yaml') }}
          restore-keys: |
            v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-

      - uses: aquaproj/aqua-installer@HASH # vX.Y.Z
        with:
          aqua_version: v2.60.1

      - name: Unit test
        run: task test

  scenario:
    name: Scenario tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@HASH # vX.Y.Z

      - uses: actions/setup-go@HASH # vX.Y.Z
        with:
          go-version-file: go.mod
          cache: true

      - uses: actions/cache@HASH # vX.Y.Z
        with:
          path: ~/.local/share/aquaproj-aqua
          key: v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-${{ hashFiles('aqua.yaml') }}
          restore-keys: |
            v2-aqua-installer-${{ runner.os }}-${{ runner.arch }}-

      - uses: aquaproj/aqua-installer@HASH # vX.Y.Z
        with:
          aqua_version: v2.60.1

      - name: Scenario tests
        run: task test:scenario
```

After writing the workflow file, replace all `HASH # vX.Y.Z` placeholders by running:

```sh
pinact run --update --min-age 3 .github/workflows/check.yaml
```

### release.yaml

Create `.github/workflows/release.yaml` and run GoReleaser when a version tag is pushed.  
Do not create `.goreleaser.yaml`. This project should rely on GoReleaser's default behavior and run only from the GitHub Actions workflow.

After creating the workflow, run `pinact run --update --min-age 3 .github/workflows/release.yaml` to pin all action hashes.

```yaml
name: Release

on:
  push:
    tags:
      - "v*"

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@HASH # vX.Y.Z
        with:
          fetch-depth: 0

      - uses: actions/setup-go@HASH # vX.Y.Z
        with:
          go-version-file: go.mod
          cache: true

      - name: Run GoReleaser
        uses: goreleaser/goreleaser-action@HASH # vX.Y.Z
        with:
          distribution: goreleaser
          version: '~> v2'
          args: release --clean
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
