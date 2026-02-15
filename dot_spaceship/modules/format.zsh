# Formatting Module
# LSP setup for consistent formatting

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
