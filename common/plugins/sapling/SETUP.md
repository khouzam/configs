# Quick Setup Guide

## Step 1: Enable the Plugin

Edit your `~/.zshrc` file and add `sapling` to your plugins array:

```zsh
plugins=(
  git
  sapling
  # ... other plugins
)
```

## Step 2: Verify VCS Integration

**IMPORTANT**: This plugin integrates with the existing `vcs` segment. You do **NOT** need to add a separate `sapling` element!

Your `~/.p10k.zsh` (or `~/.myconfigs/common/config/p10k.zsh`) should already have:

```zsh
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context
  dir
  vcs        # This will show git OR sapling automatically!
  # ... rest of elements ...
)

# REMOVE sapling from the backends list (around line 491)
typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)  # NO 'sapling' here!
```

**Important**:
- Do NOT add `sapling` to POWERLEVEL9K_VCS_BACKENDS (causes errors)
- Do NOT add a separate `sapling` element - the `vcs` segment handles it!

## Step 3: Reload Your Shell

```bash
source ~/.zshrc
```

Or restart your terminal.

## Verify It Works

Navigate to a Sapling repository:

```bash
cd /home/gilles/dev/slls
```

Your VCS segment should now show:
- `⎇ c97a221` - Clean state (green background)
- `⎇ c97a221 !1` - With uncommitted changes (yellow background)
- File counts instead of listing all files

The display format matches git's format, using your existing `my_git_formatter` function.

## Test the Plugin

Run the test script to verify everything works:

```bash
zsh ~/.oh-my-zsh/custom/plugins/sapling/test.zsh
```

## Try the Aliases

```bash
sls          # Quick status
slss         # Detailed status with emoji
slg          # Graphical log
sld          # Show diff
```

## Troubleshooting

**Prompt is slow:**
- The plugin caches the repository root to minimize `sl` calls
- Most slowness comes from `sl status` checking for changes
- Consider moving the segment to the right prompt for less visual delay

**Segment doesn't appear:**
- Make sure you added `sapling` to the plugins array in `~/.zshrc`
- Make sure you added `sapling` to the prompt elements in `~/.p10k.zsh`
- Reload your shell: `source ~/.zshrc`
- Check that you're in a Sapling repo: `sl root`

**Icon not displaying:**
- Make sure your terminal supports Unicode
- Make sure you're using a Nerd Font (required by Powerlevel10k)
- You can change the icon in your p10k config

## What Gets Displayed

| Display | Meaning |
|---------|---------|
| `⎇ mybookmark` | On bookmark "mybookmark", clean repo |
| `⎇ mybookmark*` | Uncommitted changes |
| `⎇ c97a221` | No bookmark, showing commit hash |
| `◆ mybookmark` | Public commit (already pushed) |
| `⎇ main* MERGING` | In the middle of a merge |

Enjoy your new Sapling prompt! 🌱
