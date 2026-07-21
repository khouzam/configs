# Gilles's Configs

This is my personal repository to configure my workstations with an easy git clone and a simple setup script.

It will install my regular applications, customizations for development and will update most of the settings as I fine tune them by a simple pull of the git repo.

## tmux over SSH

On an interactive SSH login the remote `zshrc` auto-attaches (or creates) a tmux session. It reuses an unattached session first, otherwise reattaches the most recent one with `-d` to kick off any stale client.

- `-CC` (iTerm2 control mode) is only used when the client is iTerm2, detected via `TERM_PROGRAM=iTerm.app` locally or `LC_TERMINAL=iTerm2` forwarded over SSH. Other clients (Termius, etc.) can't decode control mode, so they get plain tmux.
- Set `NO_TMUX=1` in the shell, or use the `sshnt` alias, to skip auto-attach.

### Skipping auto-attach from the client: `sshnt`

`sshnt` connects without auto-attaching tmux:

```sh
sshnt user@host
```

It forwards `LC_NO_TMUX=1` (via `ssh -o SendEnv=LC_NO_TMUX`); the remote `zshrc` sees it and skips the attach. The `LC_*` prefix is used because most `sshd` configs already accept it, so it survives the hop where an arbitrary variable would be stripped.

### Required remote `sshd` config

`SendEnv` only works if the remote `sshd` accepts the variable. Add to the remote `/etc/ssh/sshd_config` (or a drop-in under `/etc/ssh/sshd_config.d/`):

```
AcceptEnv LC_NO_TMUX LC_TERMINAL
```

Then reload sshd (`sudo systemctl reload sshd`, or `sudo launchctl kickstart -k system/com.openssh.sshd` on macOS). Without this the forwarded variables are dropped and auto-attach behaves as if they were unset.

Debian, Ubuntu, and their derivatives ship `AcceptEnv LANG LC_*` enabled by default, so `LC_NO_TMUX` and `LC_TERMINAL` work out of the box. Fedora/RHEL and vanilla upstream OpenSSH do **not** set `AcceptEnv` at all (verified against the stock `openssh-server` package — nothing in `sshd_config` or its `sshd_config.d` drop-ins), so the line above must be added there.