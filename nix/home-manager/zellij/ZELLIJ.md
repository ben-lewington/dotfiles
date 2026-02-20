# Zellij Reference

## Configuration

- Config language: **KDL** (not YAML — old YAML configs need migration)
- Default config location: `~/.config/zellij/config.kdl`
- Override with `--config [FILE]` or `ZELLIJ_CONFIG_DIR` env var
- Dump defaults: `zellij setup --dump-config > config.kdl`
- Start clean (no config): `zellij options --clean`

## Keybinding System

### Modes

Zellij is **modal** — keybindings are scoped to modes:

`normal` · `locked` · `resize` · `pane` · `move` · `tab` · `scroll` · `search` · `entersearch` · `renametab` · `renamepane` · `session` · `tmux`

The `tmux` mode is a built-in prefix-key mode (default `Ctrl-b`) that works like tmux's prefix system.

### Presets

- **Default**: modes accessible directly from normal mode via `Ctrl-<key>` shortcuts
- **Unlock-First (non-colliding)**: press `Ctrl-g` first to unlock, then access modes — avoids conflicts with terminal apps

Switch between presets at runtime via the Configuration screen (`Ctrl-o` → `c`).

### Binding Syntax

```kdl
bind "Ctrl a"  { SomeAction; }           // modifier + key
bind "h" "Left" { MoveFocus "Left"; }    // multiple keys, same action
bind "f" { ActionOne; ActionTwo; }       // multiple actions (no ordering guarantee)
```

Valid keys: `a`–`z`, `0`–`9`, `F1`–`F12`, `Left`/`Right`/`Up`/`Down`, `Enter`, `Esc`, `Tab`, `Space`, `Backspace`, `Home`, `End`, `PageUp`, `PageDown`, `Delete`, `Insert`

Modifiers: `Ctrl`, `Alt`, `Shift`, `Super` (multiple modifiers like `Ctrl Alt` require terminal support — Alacritty, WezTerm, foot)

### Overriding & Unbinding

- Mode-specific bindings override shared/default bindings for that key
- `unbind "Ctrl g"` at keybinds level removes from all modes
- `unbind` inside a mode block removes only in that mode
- `clear-defaults=true` on a mode or on `keybinds` wipes defaults entirely

### Shared Bindings

```kdl
shared_except "locked" { ... }       // applies to all modes except locked
shared_except "normal" "locked" { ... }
```

## Layouts

- Layout language: KDL
- Default layout dir: `~/.config/zellij/layouts/`
- Apply on start: `zellij --layout /path/to/layout.kdl`
- Dump built-in: `zellij setup --dump-layout default > layout.kdl`

### Structure

```kdl
layout {
    pane                                    // bare pane
    pane command="htop"                     // pane running a command
    pane split_direction="vertical" {       // logical container
        pane size="70%"
        pane size="30%"
    }
    pane stacked=true { pane; pane; pane }  // stacked panes
}
```

Pane properties: `command`, `cwd`, `size` (percentage or fixed), `borderless`, `focus`, `split_direction`, `plugin`, `close_on_exit`, `start_suspended`, `stacked`, `expanded`

### Tabs

```kdl
layout {
    tab name="editor" { pane command="nvim" }
    tab name="shell" { pane }
}
```

### Templates

`pane_template` and `tab_template` avoid repetition. Use a `children` node as a placeholder for consumer panes:

```kdl
layout {
    tab_template name="with-bar" {
        pane size=1 borderless=true { plugin location="zellij:compact-bar" }
        children
    }
    with-bar name="main" { pane }
}
```

`default_tab_template` applies to all tabs (including new ones opened during the session).

### Floating Panes

```kdl
layout {
    floating_panes {
        pane { x 10; y "10%"; width 80; height "50%" }
    }
}
```

### CWD Composition

Relative `cwd` values compose: pane cwd is appended to tab cwd, which is appended to global cwd.

## Themes

### Legacy Format (still supported)

```kdl
themes {
    my-theme {
        fg "#c0caf5"
        bg "#1a1b26"
        black "#15161e"
        red "#f7768e"
        green "#9ece6a"
        yellow "#e0af68"
        blue "#7aa2f7"
        magenta "#bb9af7"
        orange "#ff9e64"
        cyan "#7dcfff"
        white "#a9b1d6"
    }
}
theme "my-theme"
```

Supports RGB triples (`fg 200 200 200`), hex strings (`fg "#c0caf5"`), or 256-color indices (`fg 12`).

### New Component Format

Gives fine-grained control over individual UI elements. Each component has `base`, `background`, `emphasis_0` through `emphasis_3` (RGB triples):

Components: `ribbon_selected` · `ribbon_unselected` · `text_selected` · `text_unselected` · `frame_selected` · `frame_unselected` · `table_title` · `table_cell_selected` · `table_cell_unselected` · `list_selected` · `list_unselected` · `exit_code_success` · `exit_code_error` · `multiplayer_user_colors`

Themes update live — no session restart needed.

## Key Options

| Option | Default | Notes |
|---|---|---|
| `mouse_mode` | `true` | Can interfere with text selection |
| `scroll_buffer_size` | `10000` | Per-pane scrollback lines |
| `pane_frames` | `true` | Borders around panes |
| `default_layout` | `"default"` | Built-in: `default`, `compact` |
| `default_mode` | `"normal"` | Can set to `"locked"` |
| `default_shell` | `$SHELL` | Path to shell |
| `copy_on_select` | `true` | Auto-copy on mouse release |
| `on_force_close` | `"detach"` | Or `"quit"` |
| `session_serialization` | `true` | Enables session resurrection |
| `simplified_ui` | `false` | No arrow fonts in plugins |
| `auto_layout` | `true` | Auto-arrange panes with swap layouts |
| `styled_underlines` | `true` | Extended underline ANSI support |
| `stacked_resize` | `true` | Stack panes when resizing |

## Plugins

Built-in plugin aliases (changeable in config under `plugins {}`):

- `tab-bar` — full tab bar (2 lines)
- `compact-bar` — single-line tab bar
- `status-bar` — bottom status bar with keybinding hints
- `strider` — file explorer sidebar
- `session-manager` — session switcher (also the welcome screen)
- `configuration` — runtime config/preset switcher
- `plugin-manager` — manage running plugins

Plugins are WASM-based. Load from `zellij:name`, `file:/path.wasm`, or `https://url/plugin.wasm`.

## CLI Control

Run commands inside a session from another terminal:

```sh
zellij run -- cargo build              # run in a new pane
zellij run -f -- htop                  # run in a floating pane
zellij edit src/main.rs                # open in $EDITOR pane
zellij action new-tab                  # send actions to the session
zellij pipe                            # send data to plugins
```

## Session Resurrection

Sessions are serialized to disk by default (`session_serialization true`). After a crash or detach, `zellij attach` restores tabs, panes, and layout. Enable `pane_viewport_serialization` to also restore visible pane content. `scrollback_lines_to_serialize` controls how much scrollback to save (0 = all).

## Compatibility Notes

- Multiple modifiers and `Super` require terminal emulator support (Alacritty, WezTerm, foot)
- `copy_command` can be set for terminals without OSC 52 support (`xclip`, `wl-copy`, `pbcopy`)
- `simplified_ui true` for terminals that can't render special arrow characters
