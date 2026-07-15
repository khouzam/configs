#! /bin/bash
# This script installs zsh and oh-my-zsh on macOS and Linux
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install oh-my-zsh: https://ohmyz.sh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k: https://github.com/romkatv/powerlevel10k
if [[ ! -d $ZSH_CUSTOM_DIR/themes/powerlevel10k ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM_DIR/themes/powerlevel10k
fi

# Install zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
if [[ ! -d $ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions
fi
