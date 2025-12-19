# Sapling SCM plugin for Powerlevel10k
# Integrates with the VCS system to provide Sapling repository information
# Works with POWERLEVEL9K_VCS_BACKENDS=(git hg sapling)

# Powerlevel10k calls _p9k_vcs_info_all which in turn calls VCS-specific functions
# We need to provide the interface that p10k expects for Sapling

# Function to get Sapling status in a format compatible with p10k
function _p9k_vcs_sapling_status() {
  # Check if we're in a Sapling repository
  local root
  root=$(sl root 2>/dev/null) || return 1

  # Set VCS variables that p10k expects
  local bookmark hash phase

  # Get bookmark and commit info in one call for efficiency
  local commit_info
  commit_info=$(sl log -r . -T '{activebookmark}\n{shortest(node, 7)}\n{phase}' 2>/dev/null) || return 1

  local lines=("${(@f)commit_info}")
  bookmark="${lines[1]}"
  hash="${lines[2]}"
  phase="${lines[3]}"

  # Use bookmark or hash as branch name
  local branch="${bookmark:-$hash}"

  # Check for uncommitted changes
  local dirty=0
  if ! sl status -q 2>/dev/null; then
    dirty=1
  fi

  # Check for operations
  local action=""
  if [[ -d "$root/.sl/merge" ]]; then
    action="merge"
  elif [[ -d "$root/.sl/rebase" ]]; then
    action="rebase"
  fi

  # Export variables that p10k VCS system uses
  # These variables follow the pattern that p10k expects
  VCS_STATUS_LOCAL_BRANCH="$branch"
  VCS_STATUS_REMOTE_BRANCH=""
  VCS_STATUS_REMOTE_NAME=""
  VCS_STATUS_ACTION="$action"
  VCS_STATUS_NUM_STAGED=0
  VCS_STATUS_NUM_UNSTAGED=$dirty
  VCS_STATUS_NUM_CONFLICTED=0
  VCS_STATUS_NUM_UNTRACKED=0
  VCS_STATUS_HAS_STAGED=0
  VCS_STATUS_HAS_UNSTAGED=$dirty
  VCS_STATUS_HAS_CONFLICTED=0
  VCS_STATUS_HAS_UNTRACKED=0
  VCS_STATUS_COMMITS_AHEAD=0
  VCS_STATUS_COMMITS_BEHIND=0
  VCS_STATUS_RESULT="ok-sync"
  VCS_STATUS_WORKDIR="$root"

  # Store Sapling-specific data
  typeset -g _p9k_sapling_phase="$phase"

  return 0
}

# Hook into p10k's my_git_formatter to handle Sapling
# This function is called by p10k when formatting the VCS segment
function _p9k_sapling_formatter() {
  # Check if we're in a Sapling repo
  [[ -n "$VCS_STATUS_WORKDIR" ]] || return 1

  # Get Sapling-specific formatting
  local phase="${_p9k_sapling_phase:-draft}"
  local icon

  # Set icon based on phase
  if [[ "$phase" == "public" ]]; then
    icon="◆"
  else
    icon="⎇"
  fi

  # Format output similar to git
  local branch="$VCS_STATUS_LOCAL_BRANCH"
  local dirty=""

  if (( VCS_STATUS_HAS_UNSTAGED )); then
    dirty="*"
  fi

  local action=""
  if [[ -n "$VCS_STATUS_ACTION" ]]; then
    action=" ${VCS_STATUS_ACTION^^}"
  fi

  # Set the formatted output
  _p9k_sapling_format="$icon $branch$dirty$action"

  return 0
}

# Override p10k's VCS detection to properly handle Sapling
# This hooks into p10k's prompt rendering
function _p9k_vcs_status_for_dir_sapling() {
  _p9k_vcs_sapling_status
}

# Gitstatus-compatible wrapper for Sapling
# P10k may call this function expecting gitstatus-like behavior
function _p9k_gitstatus_sapling() {
  _p9k_vcs_sapling_status
}

# Initialize Sapling support when plugin loads
function _p9k_sapling_plugin_init() {
  # Register Sapling handlers with p10k if it's loaded
  if (( ${+functions[_p9k_vcs_info]} )); then
    # p10k is loaded, register our handlers

    # Add Sapling to recognized VCS systems
    typeset -gA _p9k_vcs_backends
    _p9k_vcs_backends[sapling]=1
    _p9k_vcs_backends[sl]=1
  fi
}

# Call init on plugin load
_p9k_sapling_plugin_init

# Hook to install the VCS wrapper after p10k loads
function _sapling_install_vcs_hook() {
  # Only install once
  [[ -n $_sapling_vcs_hook_installed ]] && return

  # Wait for prompt_vcs to exist (p10k loaded)
  if ! (( ${+functions[prompt_vcs]} )); then
    return
  fi

  # Don't wrap if already wrapped
  (( ${+functions[_p9k_prompt_vcs_sapling_orig]} )) && return

  typeset -g _sapling_vcs_hook_installed=1

  # Save the original function
  functions[_p9k_prompt_vcs_sapling_orig]=${functions[prompt_vcs]}

  function prompt_vcs() {
    # Check if we're in a Sapling repo first
    # We need to verify .sl directory exists, not just sl root success
    # (sl root can succeed in git repos due to compatibility)
    local root
    if root=$(sl root 2>/dev/null) && [[ -d "$root/.sl" ]]; then
      # We're in a Sapling repo - set up VCS_STATUS variables for p10k

      # Get commit info
      local commit_info
      commit_info=$(sl log -r . -T '{activebookmark}\n{shortest(node, 7)}\n{phase}' 2>/dev/null)
      local lines=("${(@f)commit_info}")
      local bookmark="${lines[1]}"
      local hash="${lines[2]}"
      local phase="${lines[3]}"

      local branch="${bookmark:-$hash}"

      # Parse sl status to get file counts
      local status_output
      status_output=$(sl status 2>/dev/null)

      local num_modified=0
      local num_added=0
      local num_removed=0
      local num_untracked=0
      local num_conflicted=0

      # Count files by status
      while IFS= read -r line; do
        case "${line:0:1}" in
          M) (( num_modified++ )) ;;
          A) (( num_added++ )) ;;
          R) (( num_removed++ )) ;;
          \?) (( num_untracked++ )) ;;
          U) (( num_conflicted++ )) ;;
        esac
      done <<< "$status_output"

      local num_unstaged=$((num_modified + num_removed))
      local num_staged=$num_added
      local has_changes=0

      if (( num_unstaged + num_staged + num_untracked + num_conflicted > 0 )); then
        has_changes=1
      fi

      # Check for operations
      local action=""
      local state="CLEAN"
      if [[ -d "$root/.sl/merge" ]]; then
        action="merge"
        state="CONFLICTED"
      elif [[ -d "$root/.sl/rebase" ]]; then
        action="rebase"
        state="CONFLICTED"
      elif (( num_conflicted > 0 )); then
        state="CONFLICTED"
      elif (( has_changes )); then
        state="MODIFIED"
      fi

      # Set VCS_STATUS variables that p10k's formatter expects
      typeset -g VCS_STATUS_LOCAL_BRANCH="$branch"
      typeset -g VCS_STATUS_REMOTE_BRANCH=""
      typeset -g VCS_STATUS_REMOTE_NAME=""
      typeset -g VCS_STATUS_ACTION="$action"
      typeset -g VCS_STATUS_NUM_STAGED=$num_staged
      typeset -g VCS_STATUS_NUM_UNSTAGED=$num_unstaged
      typeset -g VCS_STATUS_NUM_CONFLICTED=$num_conflicted
      typeset -g VCS_STATUS_NUM_UNTRACKED=$num_untracked
      typeset -g VCS_STATUS_HAS_STAGED=$num_staged
      typeset -g VCS_STATUS_HAS_UNSTAGED=$num_unstaged
      typeset -g VCS_STATUS_HAS_CONFLICTED=$num_conflicted
      typeset -g VCS_STATUS_HAS_UNTRACKED=$num_untracked
      typeset -g VCS_STATUS_COMMITS_AHEAD=0
      typeset -g VCS_STATUS_COMMITS_BEHIND=0
      typeset -g VCS_STATUS_STASHES=0
      typeset -g VCS_STATUS_TAG=""
      typeset -g VCS_STATUS_COMMIT="$hash"
      typeset -g VCS_STATUS_COMMIT_SUMMARY=$(sl log -r . -T '{desc|firstline}' 2>/dev/null)
      typeset -g VCS_STATUS_WORKDIR="$root"

      # Set icon based on phase
      local icon
      if [[ "$phase" == "public" ]]; then
        icon="◆"
      else
        icon="⎇"
      fi

      # Let p10k's formatter handle the display via my_git_formatter
      # We need to set P9K_CONTENT to empty so it uses VCS_STATUS_* variables
      typeset -g P9K_CONTENT=""

      # Call my_git_formatter if it exists
      if (( ${+functions[my_git_formatter]} )); then
        my_git_formatter
        # Render with proper state and the formatted content
        p10k segment -s "$state" -i "$icon" -t "${my_git_format}"
      else
        # Fallback if formatter doesn't exist
        local display="$branch"
        (( num_unstaged )) && display+=" !${num_unstaged}"
        (( num_staged )) && display+=" +${num_staged}"
        (( num_untracked )) && display+=" ?${num_untracked}"
        (( num_conflicted )) && display+=" ~${num_conflicted}"
        [[ -n "$action" ]] && display+=" ${action}"

        p10k segment -s "$state" -i "$icon" -t " ${display}"
      fi

      return 0
    fi

    # Not in Sapling, call original VCS function
    _p9k_prompt_vcs_sapling_orig
  }
}

# Install the hook on precmd (runs before each prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd _sapling_install_vcs_hook

# Try to install immediately if p10k is already loaded
_sapling_install_vcs_hook

# Helper function to check if we're in a Sapling repo
function in_sapling_repo() {
  local root
  root=$(sl root 2>/dev/null) && [[ -d "$root/.sl" ]]
}

# Function to show more detailed status
function sapling_status_detailed() {
  if ! in_sapling_repo; then
    echo "Not in a Sapling repository"
    return 1
  fi

  echo "📁 Repository: $(sl root)"
  echo "🔖 Bookmark: $(sl log -r . -T '{activebookmark}' 2>/dev/null || echo 'none')"
  echo "📝 Commit: $(sl log -r . -T '{shortest(node, 7)} - {desc|firstline}' 2>/dev/null)"
  echo ""
  sl status
}

# Convenient aliases
alias sls='sl status'
alias slg='sl log -G'
alias sld='sl diff'
alias slc='sl commit'
alias slp='sl pull'
alias slps='sl push'
alias sla='sl amend'
alias slss='sapling_status_detailed'

# Add completion for sl if not already present
if [[ ! -f ~/.oh-my-zsh/custom/plugins/sapling/_sl ]]; then
  # Try to enable Sapling's built-in completion
  if command -v sl &> /dev/null; then
    # Sapling provides its own completion, try to source it
    if [[ -f "/home/linuxbrew/.linuxbrew/share/zsh/site-functions/_sl" ]]; then
      source "/home/linuxbrew/.linuxbrew/share/zsh/site-functions/_sl" 2>/dev/null
    fi
  fi
fi
