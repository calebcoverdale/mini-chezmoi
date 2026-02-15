# Spaceship Prompt Module
# Sourced from ~/.config/zsh/modules/spaceship.zsh

# Prompt initialization happens in pre hook
# This file contains the actual prompt configuration

# Spaceship prompt settings
export SPACESHIP_PROMPT_ORDER="2"  # spaceship first, then oh-my-zsh
export SPACESHIP_PROMPT_ADD_NEWLINE="false"
export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="false"
export SPACESHIP_PROMPT_PREFIX_SHOW="true"
export SPACESHIP_PROMPT_ASYNC="true"
export SPACESHIP_PROMPT_RPROMPT_ENGINE="zsh-autosuggestions"

# Disable oh-my-zsh prompt since spaceship replaces it
export ZSH_THEME=""

# Keep oh-my-zsh's git handling (spaceship doesn't override this)
export SPACESHIP_GIT_SHOW="true"
