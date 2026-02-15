# Neovim Module
# Lazy-load nvim with lazy.nvim + chezmoi config

# Install lazy.nvim if not present
if [[ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
    echo "Installing lazy.nvim..."
    mkdir -p "$HOME/.local/share/nvim/lazy"
    curl -L https://raw.githubusercontent.com/LazyVim/LazyVim/master/README.lua \
        -o "$HOME/.local/share/nvim/lazy/lazy.nvim" \
        --create-dirs 2>/dev/null || {
        echo "Failed to download lazy.nvim"
        return 1
    }
    echo "lazy.nvim installed"
fi

# Load nvim config from chezmoi
nvim_chezmoi() {
    # Initialize once
    if [[ ! -f "$HOME/.local/share/nvim/lazy/" ]]; then
        export NVIM_APP_NAME="chezmoi"
    fi

    # Load chezmoi nvim config
    export NVIM_APP_NAME="chezmoi"
    nvim --headless "+LazyLoadFile ~/.config/nvim/lazy/lazy.nvim"
}

# Aliases
alias nvim='nvim_chezmoi'
alias nvimrebuild='nvim --headless "+LazyRebuild"'
alias nvimconf='e ~/.config/nvim/init.lua'
alias nvimclean='rm -rf ~/.local/state/nvim'

# Ensure nvim lazy directories exist
mkdir -p "$HOME/.local/share/nvim/lazy"
mkdir -p "$HOME/.local/share/nvim/lua"
