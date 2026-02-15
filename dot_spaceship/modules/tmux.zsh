# Tmux Module
# Workspace and profile management

# Tmux aliases - simplified from your setup
alias tm='tmux'
alias tma='tmux attach -t'
alias tml='tmux list-sessions'
alias tmls='tmux ls'
alias tmlsa='tmux new-session -As'
alias tmlad='tmux attach -d -t'
alias tmks='tmux kill-session -a'
alias tmksa='tmux kill-server'

# Quick profile switches
alias tp='tmux attach -t calebcoverdale'
alias ta='tmux attach -t aurorion'

# List sessions with profiles
function tmls() {
    if ! tmux list-sessions &>/dev/null; then
        echo "No tmux sessions running"
        return 0
    fi

    echo "Active tmux sessions:"
    echo ""
    tmux list-sessions -F "#{session_name}" | while read -r session; do
        local profile=$(tmux show-environment -t "$session" ZSH_PROFILE 2>/dev/null | cut -d= -f2)
        if [[ -n "$profile" ]]; then
            echo "  $session → $profile"
        else
            echo "  $session → (no profile)"
        fi
    done
}
