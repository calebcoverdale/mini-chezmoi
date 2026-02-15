# Profile: calebcoverdale (Personal)
# ============================================

# Profile metadata
export ZSH_PROFILE="calebcoverdale"
export ZSH_PROFILE_TYPE="personal"

# -------------------------
# Git Identity
# -------------------------
export GIT_AUTHOR_NAME="Caleb Coverdale"
export GIT_AUTHOR_EMAIL="caleb@calebcoverdale.com"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# -------------------------
# Project Paths
# -------------------------
export PERSONAL_CODE_DIR="$HOME/code/personal"
export PROJECTS_DIR="$HOME/code/personal"

# -------------------------
# PATH Additions
# -------------------------
# Personal binaries
export PATH="$HOME/.local/bin:$PATH"

# -------------------------
# Aliases (Profile-specific)
# -------------------------
alias cdp='cd $PROJECTS_DIR'
alias personal='cd $PERSONAL_CODE_DIR'

# -------------------------
# Prompt Customization
# -------------------------
# Set a distinct prompt indicator for this profile
export STARSHIP_PROFILE="personal"

# -------------------------
# Profile indicator
# -------------------------
if [[ $- == *i* ]]; then
    echo "✨ Profile loaded: calebcoverdale (personal)"
fi
