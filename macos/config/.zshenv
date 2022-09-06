# Add brew to the path
path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

if [[ -f ~/.zshenv_local ]]; then
    source ~/.zshenv_local
fi