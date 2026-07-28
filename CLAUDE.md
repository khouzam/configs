# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal dotfiles / workstation-provisioning repo (shell scripts and config files only — no build system, no test framework, no package manager). The repo is cloned to `~/.myconfigs` and the config files are **symlinked** into `$HOME`, so a `git pull` updates the live shell configuration in place.

## Commands

```sh
./macos/setup.sh              # full macOS provision (brew packages, configs, TouchID/WatchID sudo, iTerm2)
./macos/setup.sh --no-gui     # skip cask/GUI apps — use for headless machines
./linux/setup.sh [--no-gui]   # same for apt or dnf distros (auto-detected)

common/scripts/linkconfigs.sh          # (re)create the ~/.zshrc etc. symlinks only
common/scripts/setgit.sh               # apply global git config
common/scripts/installzsh.sh           # oh-my-zsh + powerlevel10k + zsh-autosuggestions
common/scripts/installconsolefonts.sh  # Nerd Fonts (not called by setup.sh — run manually)
common/scripts/setupssh.sh             # pull SSH keys out of LastPass into ~/.ssh (interactive lpass login)

zsh ~/.oh-my-zsh/custom/plugins/sapling/test.zsh   # the only test in the repo; must be run from inside a Sapling repo
```

Both `setup.sh` entry points are idempotent: every install goes through a `brew_install`/`pkg_install` helper that checks first, and every config script re-applies cleanly. Keep new code that way.

## Layout and conventions

- `common/` — everything shared. `config/` holds the files that get symlinked; `scripts/` holds cross-platform provisioning steps; `plugins/` holds custom oh-my-zsh plugins.
- `macos/`, `linux/` — platform entry point `setup.sh` plus platform-only scripts/config. Platform setup scripts call into `common/scripts/*` via a `run_script` helper that no-ops if the file is missing.
- Every script starts with the same `SCRIPT_PATH=$(dirname "$0"); SCRIPT_PATH=$(cd ... && pwd)` preamble so it can be invoked from anywhere; follow it in new scripts.
- macOS scripts are `#!/bin/zsh` or bash; Linux scripts are bash. Common scripts must stay bash-compatible since both platforms source them.

### Symlinked files (edit here, not in `$HOME`)

`common/config/{zshenv,zshrc,zsh_aliases,p10k.zsh}` → `~/.zshenv`, `~/.zshrc`, `~/.zsh_aliases`, `~/.p10k.zsh`, and `common/plugins/sapling/sapling.plugin.zsh` → `~/.oh-my-zsh/custom/plugins/sapling/`. Editing `~/.zshrc` edits this repo. iTerm2 is handled differently: `macos/scripts/setupiTerm.sh` points iTerm's `PrefsCustomFolder` at `macos/iTerm/settings/`, so iTerm writes its plist back into the repo on quit — expect churn in that file.

### Local, un-versioned overrides

Each config sources an optional local counterpart at the end: `~/.zshenv_local`, `~/.zshrc_local`, `~/.zsh_aliases_local`. Machine-specific settings belong there, never in the versioned files.

## Shell config architecture

- `zshenv` runs first: sets Homebrew on PATH for macOS and decides `TMUX_OPTIONS`. `-CC` (iTerm2 control mode) is only used when the client is iTerm2 (`TERM_PROGRAM=iTerm.app` locally, or `LC_TERMINAL=iTerm2` forwarded over SSH) — other clients can't decode control mode.
- `zshrc` auto-attaches tmux on interactive SSH logins (skipped inside tmux, inside VSCode, on non-ttys, or when `NO_TMUX`/`LC_NO_TMUX` is set). It prefers an unattached session, else reattaches the newest with `-d`.
- The `sshnt` alias in `zsh_aliases` forwards `LC_NO_TMUX=1` via `ssh -o SendEnv` to skip the remote auto-attach. `LC_*` is used deliberately because most `sshd` configs already `AcceptEnv LC_*`; RHEL/Fedora/vanilla OpenSSH need `AcceptEnv LC_NO_TMUX LC_TERMINAL` added. See README.md.
- `zshaddhistory` in `zshrc` filters history: honors `HIST_IGNORE_SPACE` explicitly (the hook overrides zsh's built-in handling) and drops anything matching a pattern in `$ZSH_HIST_IGNORE_PATTERN` (set in `zshenv`).

## Sapling p10k plugin

`common/plugins/sapling/sapling.plugin.zsh` makes Powerlevel10k's existing `vcs` segment show Sapling info. It saves `prompt_vcs` into `_p9k_prompt_vcs_sapling_orig` and replaces it with a wrapper that checks `sl root` **and** `[[ -d "$root/.sl" ]]` (bare `sl root` also succeeds in git repos), populates the `VCS_STATUS_*` variables in gitstatus format so `my_git_formatter` in `p10k.zsh` renders it, and otherwise delegates to the saved original.

Consequences when touching this: do **not** add `sapling` to `POWERLEVEL9K_VCS_BACKENDS` (it must stay `(git)`, see `common/config/p10k.zsh:490`) and do not add a separate `sapling` prompt element. The plugin's own README.md/SETUP.md document the display format and aliases (`sls`, `slg`, `sld`, `slc`, `slp`, `slps`, `sla`, `slss`).
