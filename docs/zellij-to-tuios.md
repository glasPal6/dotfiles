# From zellij to tuios

A guide to tuios (0.10.1) as set up in these dotfiles, written for someone whose
fingers still know zellij. Every key here was checked against
`tuios keybinds list` on this config. That command is the source of truth when
something feels off.

## 1. The mental model

| zellij           | tuios                     | Notes                                                        |
|------------------|---------------------------|--------------------------------------------------------------|
| session          | session                   | Kept alive by a daemon. `tuios ls`, `tuios attach NAME`      |
| tab              | **workspace** (1–9)       | Shown as tabs in the dock at the top                         |
| pane             | **window**                | Each window owns one pane (one shell or program)             |
| floating pane    | floating window           | A workspace is either tiled or floating (`ctrl+space space`) |
| layout (`.kdl`)  | layout template / script  | See §5. tuios has no declarative layout files                |
| locked mode      | **terminal mode**         | Keys go to the program in the pane                           |
| normal mode      | **window mode**           | Single letters manage windows (`n`, `x`, `z`, …)             |
| `ctrl+space` + … | `ctrl+space` + … (prefix) | Same leader as before. The keys after it differ (§3)         |

Two modes matter. **Terminal mode** is where you live, and it works like zellij's
locked mode. **Window mode** is entered with `opt+esc` (or `ctrl+space esc`) and
is like zellij's normal mode without the sub-modes: one key does one thing.
Leave it with `i` or `enter`. In zellij each sub-mode (pane, tab, resize, move)
had its own leader letter. tuios mostly uses one flat prefix table, plus a
few sub-prefixes (`ctrl+space t` window, `w` workspace, `L` layout).

Lost? `ctrl+space ?` shows the help, and `ctrl+p` opens the command palette,
where every action is searchable by name.

## 2. What this setup changes

All of this lives in `tuios/.config/tuios/config.toml` and is stowed to
`~/.config/tuios/config.toml`:

- **Auto-tiling**: new sessions start tiled with the BSP scheme (`[startup]`).
  Without that table tuios treats `startup.tiled` and `startup.daemon` as off.
- **Shared borders**: neighbouring panes share one border line instead of two.
  `appearance.gap` stays at 0.
- **Session rail (sidebar) hidden**: `appearance.sidebar.enabled = false`.
  `ctrl+space b` toggles it back for a moment when you want it.
- **No title-bar buttons** on panes.
- **Leader** `ctrl+space`, the same as the old zellij setup.
- **Pane focus** on `opt+shift+arrows`, so `opt+arrows` still move by word in zsh.
- **Workspace stepping** on `opt+ctrl+left/right`.

Ghostty has `clipboard-read = allow`, so pasting no longer asks "this
application is trying to read from the clipboard" (see §6).

**After editing config.toml:** a running daemon may keep the old appearance.
From a terminal **outside** tuios, run `tuios config apply`. Or recreate the
session:

```sh
tuios kill-session Base   # the next Ghostty window recreates it via .zshrc
```

An existing session keeps its own tiling mode. `ctrl+space space` toggles
tiling on the current workspace.

Most options can also be changed live: open the settings page with `,` in
window mode (or `ctrl+space ,`), or run
`tuios set-config appearance.gap 1`. To find an option, use
`tuios list-options --section appearance`.

## 3. Your old zellij keys → tuios

Your zellij binds came from `zellij/.config/zellij/config.kdl`. `P` below means
`ctrl+space`.

### Panes

| You did in zellij                      | tuios                                         |
|----------------------------------------|-----------------------------------------------|
| `Alt+arrows` move focus                | `opt+shift+arrows` (or `P` + arrows)          |
| `P p` then `d` / `l` new pane down/right | `P -` split top/bottom, `P \|` split left/right |
| `Alt n` / `P p n` new pane             | `P c` (new window, tiled in automatically)     |
| `P p x` close pane                     | `P x`                                         |
| `P p f` fullscreen pane                | `P z` (zoom), `z` in window mode              |
| `P p ;` last pane                      | `;` in window mode                            |
| `P p c` rename pane                    | `P r`                                         |
| `P p tab` cycle panes                  | `opt+tab` / `opt+shift+tab`, or `P n` / `P p` |
| `P p e` / `Alt f` floating             | `P space` toggles tiling for the workspace    |
| resize mode (`P r` + arrows)           | window mode: `[` `]` `{` `}` height, `<` `>` master width; `P =` equalize |
| move mode (`P m` + arrows)             | window mode: `H` `J` `K` `L` (or `ctrl+arrows`) swap |
| `P t b` break pane to new tab          | `P w` + `!`…`(` moves the window to workspace 1–9 |

### Tabs → workspaces

| You did in zellij                      | tuios                                         |
|----------------------------------------|-----------------------------------------------|
| `P t 1…9` go to tab                    | `opt+1…9` (or `P w 1…9`)                      |
| `P t left/right` prev/next tab         | `opt+ctrl+left/right`                         |
| `Alt left/right` at the edge → next tab | Not possible: focus stops at the last pane. Use `opt+ctrl+right` |
| `P t n` / `Alt t` new tab              | `opt+<n>` to an empty workspace, then `P c`   |
| `P t r` rename tab                     | `P w r`                                       |
| `P t x` close tab                      | command palette → "close workspace"           |
| move window to a tab and follow        | `opt+shift+1…9`                               |
| workspace picker                       | `P W`                                         |

### Session

| You did in zellij                      | tuios                                         |
|----------------------------------------|-----------------------------------------------|
| `P o d` detach                         | `P d`                                         |
| `P o w` session manager                | `P S` session switcher, `P /` find any pane   |
| `P f` zsm new session (name, folder)   | `P E` popup: name, then folder (`tuios-new-session`) |
| `ctrl+q` quit                          | `P q` (kills the session), `P X` close session |
| search / copy scrollback               | `P [` copy mode, `P s` scrollback browser     |

If you'd rather have zellij-shaped keys, there is a preset:
`tuios keybinds cheatsheet zellij` shows what it changes, and
`tuios keybinds preset zellij` switches to it (its leader is `ctrl+g`;
bindings in config.toml win over the preset).

## 4. Getting around

- **Panes:** `opt+shift+arrows`. `P Q` labels every pane, so you can jump to one
  by its label.
- **Workspaces:** `opt+1…9` jumps directly. `opt+ctrl+left/right` steps
  through the workspaces that have panes and skips empty ones.
- **Move a pane:** `opt+shift+<n>` sends the focused pane to workspace n and
  follows it.
- **Last pane:** `;` in window mode.
- **Zoom:** `P z` toggles the focused pane to (nearly) full screen.
- **Scratch terminal:** `P g` shows or hides a drop-down shell, which is handy for
  a quick command.

## 5. The `dev` layout

The zellij `dev` layout had three tabs: nvim, claude and term. The `dev`
function in `zsh/.zshrc` builds the same thing out of workspaces. Run it from a
pane on workspace 1, in the project directory:

```sh
cd ~/code/my-project
dev
```

| Workspace | Name   | Runs         | Key     |
|-----------|--------|--------------|---------|
| 1         | nvim   | `nvim .`     | `opt+1` |
| 2         | claude | `claude`     | `opt+2` |
| 3         | term   | a zsh shell  | `opt+3` |

claude is typed into a shell rather than run as the pane's process, so quitting
it leaves you at a prompt instead of closing the pane.

The function uses plain tuios commands, and you can use the same commands for
your own layouts:

```sh
tuios new-window NAME --workspace 2 --cwd "$PWD" --no-focus   # open a pane
tuios send-text -w NAME $'some command\n'                      # type into it
tuios set-workspace-name 2 NAME                                # name a workspace
tuios select-workspace 1                                       # show a workspace
```

**Saved layout templates** are the other way to do it. Arrange the panes by hand,
then press `P L s` to save the layout and `P L l` to load one.
`tuios layout list` shows the saved ones, and `tuios layout export NAME` prints
one as a tape script you can edit. Templates are stored in
`~/.config/tuios/layouts/`.

**Layout schemes** inside one workspace: the default is BSP. You can also set
`startup.layout = "master-stack"` (one big pane plus a stack, sized with
`<` `>` and `P L` …) or `"scrolling"` (niri-style columns).

## 6. Copy and paste

- **Paste:** `cmd+v`, `ctrl+shift+v` or middle-click. tuios asks Ghostty for
  the host clipboard over OSC 52. Ghostty's default `clipboard-read = ask` is
  what showed the "this application is trying to read from the clipboard"
  prompt. `clipboard-read = allow` in the Ghostty config removes it. Restart
  Ghostty after changing it.
- **Copy:** selecting with the mouse copies on release (`copy_on_select`).
- **Copy mode:** `P [` enters it. Move with vim keys, search with `/` and `?`,
  yank, and the text goes to the clipboard.
- **Hints:** `P F` labels the URLs, paths and hashes on screen. Press a label
  to copy that item.
- **Paste buffers:** every yank is kept. `P ]` pastes the newest, and `P #`
  lets you pick an older one.
- **Images:** `P V` pastes a clipboard image as a file path, which is useful
  for handing a screenshot to Claude.

## 7. Agents in tuios

tuios is built with coding agents in mind. Claude Code's hooks are already
installed (`tuios doctor agents` shows `claude-code integration installed`).
Each Claude pane therefore reports its own state, and tuios shows it.

- **Agent state on every pane:** working, needs input, done or errored. You
  can see which Claude is waiting for you without visiting each workspace.
  `tuios list-agents` prints the same thing.
- **The Inbox:** `P i` opens one list of everything waiting for you across all
  sessions: permission prompts, plan approvals, questions and finished turns.
  `P o` jumps straight to the oldest item, and `P O` to the newest unseen
  finished turn. You can approve Claude's permission prompts from the Inbox
  without switching panes. `tuios list-attention` is the CLI version.
- **Review:** `P v` shows what the agent in the focused pane changed: the diff
  against its base branch, including uncommitted and untracked files.
- **Checkpoints:** when an agent's turn ends inside a git repo, tuios saves
  the work tree under `refs/tuios/checkpoints/…` without touching your branch,
  index or stash. Undo a bad turn with:
  ```sh
  tuios checkpoint list -w claude
  tuios checkpoint diff -w claude 3
  tuios checkpoint restore -w claude 2
  ```
- **A helper agent next to you:**
  ```sh
  tuios start-agent claude --name reviewer --grants read
  tuios ask-agent -w reviewer 'review the diff on this branch and list anything risky'
  ```
- **Worktrees as sessions:** `tuios worktree new feat/x --agent claude` creates
  a git worktree, a session for it and a Claude inside it. `tuios worktree ls`
  shows them all with their state.
- **Fan-out:** `tuios fan 3 --agent claude 'Add retry with backoff'` runs three
  Claudes on the same prompt, each in its own worktree. Compare them with
  `tuios fan compare …` and keep one with `tuios fan keep …`.
- **One pane per item:** `tuios xpanes a b c` opens a pane per item on a new
  workspace with multifocus on, so typing goes to all of them.
- **Agent settings:** `P A`.

Agents can also message each other (`send-agent-message`) and ask you a
question (`ask-human`). That arrives in the Inbox.

Claude itself can read the built-in docs with `tuios --skill` (there is a
`tuios` skill for it), so you can ask it to "open a pane and run the tests"
and it will drive tuios.

## 8. Tips and tricks

- `ctrl+p`: the command palette. If you've forgotten a key, search for the action.
- `alt+space` or `P a`: the app launcher.
- `,` in window mode: settings, with every option and a live preview.
- `P k`: the keybind manager. `tuios keybinds explain opt+ctrl+right` says
  what a key does, and `tuios keybinds doctor` lists conflicts and every key
  tuios takes from the pane.
- `P C`: a screenshot of the terminal, copied to the clipboard.
- `p` in window mode: picture-in-picture. Pin the focused pane as a small
  floating view, for example to keep an eye on a build log from another workspace.
- `B`: spotlight, which dims everything except the focused pane.
- Themes: `tuios --list-themes`, and `tuios set-config appearance.theme NAME` to
  try one live.
- `tuios resurrect`: restore a session after a reboot.
- `tuios ls` and `tuios attach NAME -c`: list sessions, or attach and create one
  if it's missing. Every top-level Ghostty shell attaches to `Base` (see
  `zsh/.zshrc`).
- Stuck in window mode with keys not reaching the shell? Press `i` or `enter`.
