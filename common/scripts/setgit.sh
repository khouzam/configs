#! /bin/bash
SCRIPT_PATH=$(dirname "$0") # relative
SCRIPT_PATH=$(cd "$SCRIPT_PATH" && pwd)
if [[ -z "$SCRIPT_PATH" ]]; then
    # error; for some reason, the path is not accessible
    # to the script (e.g. permissions re-evaled after suid)
    exit 1 # fail
fi

# Make sure we are in the git repo
pushd $SCRIPT_PATH

# Configure Git
git config --global column.ui auto
git config --global branch.sort -committerdate
git config --global tag.sort version:refname
git config --global diff.algorithm histogram
git config --global alias.root 'rev-parse --show-toplevel'
git config --global core.pager "less -FX"
git config --global diff.colorMoved plain
git config --global diff.mnemonicPrefix true
git config --global diff.renames true
git config --global diff.colorMoved zebra
git config --global push.autoSetupRemote true
# git config --global push.followTags true
git config --global fetch.prune true
git config --global fetch.pruneTags true
git config --global fetch.all true
git config --global pull.rebase true
git config --global help.autocorrect prompt
git config --global commit.verbose true

git config --global rerere.enabled true
git config --global rerere.autoupdate true

git config --global rebase.autoSquash true
git config --global rebase.autoStash true
git config --global rebase.updateRefs true

# Set the global user name (which might be changed)
git config --global user.name "Gilles Khouzam"
git config --global user.email gilles@khouzam.com

# Set the repo user name (which might be different than the global one eventually)
git config user.name "Gilles Khouzam"
git config user.email gilles@khouzam.com

# Set the remote to use SSH instead of HTTPS
git config url."git@github.com:".insteadOf "https://github.com/"

popd
