# Sapling SCM Plugin for Powerlevel10k

A simple Powerlevel10k segment that displays Sapling SCM repository information and integrates directly into the `vcs` prompt segment

## Features

- **Smart Display**: Shows current bookmark (or short commit hash if no bookmark)
- **Change Indicator**: Displays `*` when there are uncommitted changes
- **Color Coding**:
  - Green for clean repos
  - Yellow/orange for dirty repos (uncommitted changes)
  - Red during merge/rebase operations
- **Operation Detection**: Shows MERGING/REBASING status
- **Phase Indication**: Different icon (◆) for public commits vs draft commits (⎇)
- **Performance**: Caches repository root to minimize `sl` command calls
- **Context Aware**: Only appears when inside a Sapling repository

## How It Works

The plugin hooks into Powerlevel10k's VCS system by:
1. Overriding the `prompt_vcs` function to detect Sapling repositories
2. Providing VCS status in the same format as git (branch, dirty state, actions)
3. Falling back to the original VCS handler (git/hg) when not in a Sapling repo

This means:
- **You use the `vcs` segment** in your prompt elements (not a separate `sapling` segment)
- **It automatically detects** whether you're in git or Sapling and shows the right info
- **It looks and feels** like the git integration

## Installation

### 1. Enable the plugin in your `.zshrc`

Add `sapling` to your plugins array:

```zsh
plugins=(... sapling)
```

### 2. Verify VCS Integration

**IMPORTANT**: This plugin integrates with the existing `vcs` segment. You do **NOT** need to add a separate `sapling` element if the `vcs` prompt element is enabled!

Your `~/.p10k.zsh` should already have `vcs` in your prompt elements:

```zsh
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context
  dir
  vcs        # This automatically shows git OR sapling!
)
```

### 3. Reload your shell

```bash
source ~/.zshrc
```

Or simply restart your terminal.

## How It Works

This plugin **integrates with Powerlevel10k's VCS system**:
- In git repos: shows git info (e.g., ` main`)
- In Sapling repos: shows Sapling info (e.g., `⎇ c97a221`)
- Automatic detection - no configuration needed per-repo

See [VCS-INTEGRATION.md](VCS-INTEGRATION.md) for technical details.

## Segment Display

The VCS segment uses the same format as git:
- `⎇ c97a221` - Clean state (green background)
- `⎇ c97a221 !1` - 1 modified file (yellow background)
- `⎇ bookmark +2` - 2 added files (yellow background)
- `⎇ bookmark !3 ?2` - 3 modified, 2 untracked files (yellow background)
- `⎇ bookmark ~1 merge` - 1 conflict during merge (red background)
- `◆ bookmark` - Public commit (different icon)

### Status Indicators

Matches your git format:
- `!N` - N unstaged/modified files
- `+N` - N staged/added files
- `?N` - N untracked files
- `~N` - N conflicted files
- `merge`/`rebase` - Operation in progress

### Icons

- `⎇` - Draft commits (default)
- `◆` - Public commits (already pushed/landed)

## Customization

You can customize the appearance by adding these settings to your `~/.p10k.zsh`:

```zsh
# Sapling segment customization
typeset -g POWERLEVEL9K_SAPLING_FOREGROUND=208        # Orange color
typeset -g POWERLEVEL9K_SAPLING_ICON='⎇'              # Icon to use

# Change colors based on state
typeset -g POWERLEVEL9K_SAPLING_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_SAPLING_DIRTY_FOREGROUND=yellow
```

## Included Aliases

The plugin also provides convenient aliases:

- `sls` - Quick `sl status`
- `slg` - `sl log -G` (graphical log)
- `sld` - `sl diff` (show changes)
- `slc` - `sl commit` (create commit)
- `slp` - `sl pull` (pull changes)
- `slps` - `sl push` (push changes)
- `sla` - `sl amend` (amend current commit)
- `slss` - Show detailed status (custom function with emoji icons)

## Testing

To test if the plugin works:

```bash
# Navigate to a Sapling repository
cd /path/to/sapling/repo

# Your prompt should now show the bookmark/commit
# Make a change to a file
echo "test" >> somefile.txt

# You should see the * indicator appear
```

## Troubleshooting

**Segment doesn't appear:**
- Make sure Sapling is installed: `which sl`
- Verify you're in a Sapling repo: `sl root`
- Check that the plugin is loaded: `echo $plugins`
- Reload your shell: `source ~/.zshrc`

**Slow prompt:**
- The plugin runs `sl` commands which may be slow in large repos
- Consider reducing the frequency of checks or caching results

## Performance Notes

The plugin runs Sapling commands synchronously, which may cause slight delays in very large repositories. For optimal performance:

- Keep your Sapling installation updated
- Use Sapling's built-in caching features
- Consider adding the segment to the right prompt instead of left

## License

MIT
