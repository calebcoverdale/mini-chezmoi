# Profile: aurorion (Company)
# ============================================

# Profile metadata
export ZSH_PROFILE="aurorion"
export ZSH_PROFILE_TYPE="company"

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
export AURORION_CODE_DIR="$HOME/code/auroriontech"
export PROJECTS_DIR="$HOME/code/auroriontech"

# -------------------------
# PATH Additions
# -------------------------
# Company binaries
export PATH="$HOME/.local/bin:$PATH"

# -------------------------
# Aliases (Profile-specific)
# -------------------------
alias acd='cd $PROJECTS_DIR'
alias aurorion='cd $AURORION_CODE_DIR'

# -------------------------
# Prompt Customization
# -------------------------
# Set a distinct prompt indicator for this profile
export STARSHIP_PROFILE="aurorion"

# -------------------------
# Profile indicator
# -------------------------
if [[ $- == *i* ]]; then
    echo "🏢 Profile loaded: aurorion (company)"
fi
