---
name: wails
description: Expert guidance for Wails, the Go framework for building desktop apps with web frontends. Use this skill whenever the user is building a Wails app, setting up a new Wails project, writing Go backend methods to expose to the frontend, configuring TypeScript bindings, wiring up system tray/menus, packaging for distribution, or debugging Wails-specific issues (dev mode, cross-compilation, embed). Also trigger on questions about Go ↔ JS/TS communication, window management, native dialogs, Wails v2 vs v3 migration, or any "desktop app with Go" context.
license: Apache-2.0
compatibility: Go 1.21+, Node.js 16+
metadata:
  author: terminal-skills
  version: 1.0.0
  category: development
  tags:
    - desktop
    - go
    - golang
    - cross-platform
    - native
---

# Wails — Desktop Apps with Go and Web Frontend

## Project Setup

```bash
# Install Wails CLI
go install github.com/wailsapp/wails/v2/cmd/wails@latest

# Verify system dependencies (GTK, WebKit, etc.)
wails doctor

# New project — pick a template: react-ts, vue-ts, svelte-ts, vanilla, etc.
wails init -n my-app -t react-ts
cd my-app

# Development (hot reload for both Go and frontend)
wails dev

# Production build
wails build                          # Outputs to build/bin/
wails build -platform darwin/amd64  # Cross-compile
wails build -nsis                    # Windows installer (.exe + NSIS)
wails build -webview2 embed          # Embed WebView2 runtime (Windows)
```

## Core Architecture

Wails bridges Go and the browser in one binary:

```
main.go
├── wails.Run(&options.App{...})   ← entry point
├── Bind: []interface{}{app}       ← exposes Go methods to JS
└── AssetServer: embed.FS          ← bundles frontend assets

App struct (app.go)
├── Exported methods → auto-generated TypeScript bindings
├── startup(ctx)  → initialize DB, resources
├── shutdown(ctx) → cleanup
└── domReady(ctx) → DOM is ready, safe to emit events
```

The generated bindings live in `frontend/wailsjs/go/` — never edit them manually, Wails regenerates on every `wails dev`/`wails build`.

## Go Backend

Exported methods on the bound struct become callable from JS. Return types are serialized to JSON automatically.

```go
// app.go
package main

import (
    "context"
    "github.com/wailsapp/wails/v2/pkg/runtime"
)

type App struct {
    ctx context.Context
}

func (a *App) startup(ctx context.Context) { a.ctx = ctx }

// Greet is exposed as Greet(name: string): Promise<string> in TypeScript
func (a *App) Greet(name string) string {
    return "Hello, " + name
}

// GetItems returns a typed slice — Wails generates a TypeScript interface for Item
func (a *App) GetItems() ([]Item, error) { ... }

// OpenFilePicker uses native OS dialog
func (a *App) OpenFilePicker() (string, error) {
    path, err := runtime.OpenFileDialog(a.ctx, runtime.OpenDialogOptions{
        Title: "Choose a file",
        Filters: []runtime.FileFilter{
            {DisplayName: "Markdown", Pattern: "*.md"},
        },
    })
    return path, err
}

// EmitProgress sends an event to the frontend (Go → JS)
func (a *App) RunLongTask() {
    go func() {
        for i := 0; i <= 100; i += 10 {
            runtime.EventsEmit(a.ctx, "progress", i)
        }
    }()
}
```

**Key rules:**
- Only exported methods are bound. Unexported helpers stay private.
- Return `(T, error)` for fallible operations — the error becomes a JS rejection.
- Use goroutines + `runtime.EventsEmit` for background work; never block the bound method.
- Structs used as return types must have JSON tags.

## Frontend (React + TypeScript)

```tsx
// frontend/src/App.tsx
import { Greet, GetItems, OpenFilePicker } from "../wailsjs/go/main/App";
import { main } from "../wailsjs/go/models";  // auto-generated types
import { EventsOn } from "../wailsjs/runtime/runtime";
import { useEffect, useState } from "react";

function App() {
  const [items, setItems] = useState<main.Item[]>([]);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    GetItems().then(setItems);

    // Listen for events emitted by Go
    const unsubscribe = EventsOn("progress", (pct: number) => setProgress(pct));
    return unsubscribe;
  }, []);

  const handleOpen = async () => {
    const path = await OpenFilePicker();  // opens native OS dialog
    console.log("Picked:", path);
  };

  return <div>...</div>;
}
```

**Key rules:**
- Import from `../wailsjs/go/main/App` (matches your Go package and struct name).
- All Go calls return `Promise<T>` — always `await` or `.then()`.
- `EventsOn` returns an unsubscribe function — call it in cleanup to avoid leaks.

## main.go Wiring

```go
package main

import (
    "embed"
    "github.com/wailsapp/wails/v2"
    "github.com/wailsapp/wails/v2/pkg/menu"
    "github.com/wailsapp/wails/v2/pkg/options"
    "github.com/wailsapp/wails/v2/pkg/options/assetserver"
    "github.com/wailsapp/wails/v2/pkg/options/mac"
    "github.com/wailsapp/wails/v2/pkg/options/windows"
)

//go:embed all:frontend/dist
var assets embed.FS

func main() {
    app := &App{}

    appMenu := menu.NewMenu()
    file := appMenu.AddSubmenu("File")
    file.AddText("Open…", keys.CmdOrCtrl("o"), func(_ *menu.CallbackData) {
        runtime.EventsEmit(app.ctx, "menu:open")
    })
    file.AddSeparator()
    file.AddText("Quit", keys.CmdOrCtrl("q"), func(_ *menu.CallbackData) {
        runtime.Quit(app.ctx)
    })

    wails.Run(&options.App{
        Title:  "My App",
        Width:  1200,
        Height: 800,
        AssetServer: &assetserver.Options{Assets: assets},
        OnStartup:   app.startup,
        OnShutdown:  app.shutdown,
        Bind:        []interface{}{app},
        Menu:        appMenu,
        Mac: &mac.Options{
            TitleBar: mac.TitleBarHiddenInset(),
        },
        Windows: &windows.Options{
            WebviewIsTransparent: false,
        },
    })
}
```

## Local Data (SQLite)

Ship a zero-dependency local DB — one file in the user's app data dir:

```go
import (
    "os"
    "path/filepath"
    _ "modernc.org/sqlite"  // pure-Go SQLite, no CGO required
    "database/sql"
)

func dbPath() string {
    home, _ := os.UserHomeDir()
    dir := filepath.Join(home, ".my-app")
    os.MkdirAll(dir, 0755)
    return filepath.Join(dir, "data.db")
}

func (a *App) startup(ctx context.Context) {
    a.ctx = ctx
    db, err := sql.Open("sqlite", dbPath())
    if err != nil { /* handle */ }
    a.db = db
    a.db.Exec(`CREATE TABLE IF NOT EXISTS items (
        id   INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
    )`)
}
```

## System Tray

```go
import "github.com/wailsapp/wails/v2/pkg/options/linux"

// In wails.Run options:
Linux: &linux.Options{
    // system tray config here if needed
},

// To show/hide the window from a tray:
runtime.WindowShow(a.ctx)
runtime.WindowHide(a.ctx)
```

## Installation Prerequisites

```bash
# macOS
xcode-select --install

# Ubuntu / Debian
sudo apt install libgtk-3-dev libwebkit2gtk-4.0-dev

# Fedora / RHEL
sudo dnf install gtk3-devel webkit2gtk3-devel

# Windows — just needs Go + Node; WebView2 is pre-installed on Win11
```

## Guidelines

1. **Go owns the logic** — file I/O, DB, business logic all live in Go; the frontend is pure UI.
2. **Never touch generated bindings** — `frontend/wailsjs/` is regenerated on every build.
3. **Background work via goroutines + events** — long tasks run in a goroutine and report progress with `runtime.EventsEmit`; the bound method returns immediately.
4. **Single binary distribution** — `//go:embed all:frontend/dist` bundles the frontend; `wails build` produces one file.
5. **Native dialogs over HTML modals** — use `runtime.OpenFileDialog`, `runtime.MessageDialog`, etc. for OS-native feel.
6. **`modernc.org/sqlite` for CGO-free SQLite** — avoids CGO complexity on all platforms; pure Go.
7. **`wails dev` for fast iteration** — hot-reloads both Go and frontend; no rebuild needed for UI tweaks.
8. **Test on each target OS** — WebKit rendering differs between macOS (WebKit), Windows (WebView2), and Linux (WebKitGTK); verify layouts on each.
