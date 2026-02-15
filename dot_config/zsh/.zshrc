# ============================================
# Spaceship ZSH Configuration
# ============================================

# -------------------------
# Neovim Integration
# -------------------------

# Lazy-load nvim from chezmoi config
source ~/.config/zsh/modules/nvim.zsh

# -------------------------
# Formatting LSP
# -------------------------

# Prettier
alias prettier='npx prettier --write "*"'

# ESLint
alias eslint='npx eslint --fix "*"'

# Auto-format on save for certain file types
auto_format_extensions=(
    ts
    tsx
    js
    jsx
    json
)

# Format on save hook (via gum)
format_on_save() {
    local file="$1"
    local ext="${file##*.}"

    if [[ " $ext" == " ${auto_format_extensions[@]}" ]]; then
        echo "🎨 Formatting $file..."
        prettier --write "$file"
    fi
}

# Show installed formatters
alias fmt-list='echo "Installed: prettier, eslint (use eslint --fix for auto-fix)"'

# -------------------------
# Profile System
# -------------------------

# Quick profile switcher
function profile() {
    local profile_name="${1:-calebcoverdale}"
    local profile_path="$HOME/.config/zsh/profiles/$profile_name/profile.zsh"

    if [[ ! -f "$profile_path" ]]; then
        echo "❌ Profile '$profile_name' not found"
        echo "Available profiles:"
        ls -1 "$HOME/.config/zsh/profiles" | sed 's/ / /' | grep -v "/$"
        return 1
    fi

    # Source the profile
    source "$profile_path"
}

# Aliases for quick switching
alias pp='profile calebcoverdale'      # personal profile
alias pa='profile aurorion'         # aurorion profile

# -------------------------
# Prompt Order
# -------------------------

# spaceship-prompt first, then minimal oh-my-zsh
export SPACESHIP_PROMPT_ORDER="2"

# -------------------------
# Spaceship Prompt Settings
# -------------------------

# Async prompt (don't block command execution)
export SPACESHIP_PROMPT_ASYNC="true"

# Suggestions engine
export SPACESHIP_PROMPT_RPROMPT_ENGINE="zsh-autosuggestions"

# Don't add extra newline
export SPACESHIP_PROMPT_ADD_NEWLINE="false"

# Show prefix in prompt
export SPACESHIP_PROMPT_PREFIX_SHOW="true"

# Don't show first prefix line
export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="false"

# Disable oh-my-zsh's default prompt (spaceship replaces it)
export ZSH_THEME=""

# -------------------------
# Essential Plugins
# -------------------------

# Fast, essential, well-maintained plugins only
plugins=(
    git
    sudo
    docker
    docker-compose
    kubectl
    helm
    tmux
    zoxide
    fzf
    direnv
    gh
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# -------------------------
# Backup Source (chezmoi)
# -------------------------
export BACKUP_PATH="/Volumes/4tb/caleb-mini/backup/02-2026/dotfiles"

# -------------------------
# Oh My ZSH
# -------------------------

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Use stock oh-my-zsh.sh (minimal, no custom prompt)
source $ZSH/oh-my-zsh.sh

# -------------------------
# Oh My ZSH
# -------------------------

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Use stock oh-my-zsh.sh (minimal, no custom prompt)
source $ZSH/oh-my-zsh.sh

# -------------------------
# Spaceship Prompt (after oh-my-zsh)
# -------------------------

# Load spaceship prompt
if [[ -f "$HOME/.config/zsh/modules/spaceship.zsh" ]]; then
    source "$HOME/.config/zsh/modules/spaceship.zsh"
fi

# -------------------------
# Module Loading
# -------------------------

# Load all modules
for module in ~/.config/zsh/modules/*.zsh; do
    source "$module"
done
