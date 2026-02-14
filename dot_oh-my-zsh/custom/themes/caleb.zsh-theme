# Blink-friendly, no-special-font theme.
# Shows: user@host (when SSH), cwd, git branch (+dirty), and exit status when non-zero.

autoload -U colors && colors
setopt prompt_subst

# git prompt styling (requires OMZ git plugin, which you already have enabled)
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[magenta]%}git:(%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[magenta]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

_caleb_ssh_tag() {
  [[ -n "${SSH_CONNECTION:-}" ]] && print -r -- "%{$fg[yellow]%}ssh%{$reset_color%} "
}

_caleb_userhost() {
  # Keep local prompts clean; show user@host on SSH.
  [[ -n "${SSH_CONNECTION:-}" ]] || return 0
  print -r -- "%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} "
}

_caleb_status() {
  local st=$?
  (( st == 0 )) && return 0
  print -r -- "%{$fg[red]%}[${st}]%{$reset_color%} "
}

PROMPT='${$(_caleb_status)}$(_caleb_ssh_tag)$(_caleb_userhost)%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)
%{$fg[white]%}%(!.#.$)%{$reset_color%} '

