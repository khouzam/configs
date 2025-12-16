# Example Powerlevel10k configuration for Sapling plugin
# Add these lines to your ~/.p10k.zsh file

# ==========================[ Sapling Segment Configuration ]=========================

# 1. Add 'sapling' to your prompt elements
# Find the line with POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
# and add 'sapling' to the array:

# Example for left prompt:
# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#   os_icon                 # os identifier
#   dir                     # current directory
#   vcs                     # git status (for git repos)
#   sapling                 # sapling status (for sapling repos)
#   prompt_char             # prompt symbol
# )

# Example for right prompt:
# typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
#   status                  # exit code of the last command
#   command_execution_time  # duration of the last command
#   sapling                 # sapling status
#   background_jobs         # presence of background jobs
#   time                    # current time
# )

# 2. Customize the Sapling segment appearance (optional)

# Icon to display (default: ⎇)
# typeset -g POWERLEVEL9K_SAPLING_ICON='⎇'
# typeset -g POWERLEVEL9K_SAPLING_ICON='🌱'  # Alternative: seedling emoji
# typeset -g POWERLEVEL9K_SAPLING_ICON=''   # Alternative: Nerd Font git icon

# Foreground color (default: auto-colored based on state)
# typeset -g POWERLEVEL9K_SAPLING_FOREGROUND=76        # Green (clean state)

# Custom colors for different states
# typeset -g POWERLEVEL9K_SAPLING_CLEAN_FOREGROUND=76     # Green for clean
# typeset -g POWERLEVEL9K_SAPLING_DIRTY_FOREGROUND=220    # Yellow for dirty
# typeset -g POWERLEVEL9K_SAPLING_CONFLICT_FOREGROUND=196 # Red for conflicts

# Background color (default: none/transparent)
# typeset -g POWERLEVEL9K_SAPLING_BACKGROUND=234

# Visual identifier (icon) color
# typeset -g POWERLEVEL9K_SAPLING_VISUAL_IDENTIFIER_COLOR=76

# 3. Example of a complete minimal configuration

# If you want to use both git (vcs) and sapling segments side by side:
# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#   context               # user@hostname
#   dir                   # current directory
#   vcs                   # git/mercurial/svn
#   sapling              # sapling scm
#   newline              # \n
#   prompt_char          # prompt symbol
# )

# 4. Example with both in right prompt (cleaner left side)

# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#   dir                   # current directory
#   prompt_char          # prompt symbol
# )
#
# typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
#   status                  # exit code
#   command_execution_time  # duration
#   vcs                     # git status
#   sapling                # sapling status
#   time                    # current time
# )

# =======================[ Advanced Customization ]========================

# Show full bookmark name (no truncation)
# The plugin shows the full bookmark/commit by default, but p10k can truncate it
# typeset -g POWERLEVEL9K_SAPLING_MAX_LENGTH=40

# Add prefix/suffix
# typeset -g POWERLEVEL9K_SAPLING_PREFIX='['
# typeset -g POWERLEVEL9K_SAPLING_SUFFIX=']'

# Spacing
# typeset -g POWERLEVEL9K_SAPLING_LEFT_DELIMITER=' '
# typeset -g POWERLEVEL9K_SAPLING_RIGHT_DELIMITER=' '

# ========================[ Color Reference ]========================

# Common p10k color codes:
# - 76  : Green (clean state)
# - 220 : Yellow/Orange (dirty state)
# - 196 : Red (conflicts/errors)
# - 75  : Light Blue
# - 141 : Purple
# - 208 : Orange

# For full color reference, see:
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

# ========================[ Full Example ]========================

# Minimal configuration for Sapling-only project:
#
# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#   dir
#   sapling
#   newline
#   prompt_char
# )
#
# typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
#   status
#   command_execution_time
# )
#
# typeset -g POWERLEVEL9K_SAPLING_ICON='🌱'
# typeset -g POWERLEVEL9K_SAPLING_FOREGROUND=76

# ========================[ After Editing ]========================

# Remember to reload your shell after editing:
# source ~/.zshrc
