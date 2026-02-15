# LSP Module
# Language Server configuration for Neovim

# Mason is the lazy.nvim package manager
# Key LSP packages to install

# Typescript/JavaScript
typescript = {
    "typescript-language-server": "npm install -g typescript-language-server",
    "typescript-eslint-language-server": "npm install -g typescript-eslint-language-server",
    "vue-language-server": "npm install -g @vue/language-server",
    "prettier": "npm install -g @fsouza/prettier-plugin",
}

# Python
python = {
    "python-lsp-server": "pip install python-lsp-server",
    "ruff": "npm install -g ruff",
}

# Rust
rust = {
    "rust-analyzer": "cargo install rust-analyzer",
}

# Go
gopls = "go install golang.org/x/tools/gopls@latest"

# Java/Eclipse JDT LS
jdtls = "jdtls"

# Kotlin
kotlin-language-server = "npm install -g kotlin-language-server"

# C/C++
clangd = "brew install clangd"
ccls = "brew install ccls"

# JSON
jsonls = "npm install -g vscode-json-languageserver"

# Install LSPs based on project type
lsp_install() {
    local type="$1"
    local server="${2:-none}"

    case "$type" in
        ts|typescript)
            server="${typescript[server]:-typescript-language-server}"
            ;;
        js)
            server="${typescript[server]:-typescript-language-server}"
            ;;
        vue)
            server="${typescript[vue-language-server]}"
            ;;
        py|python)
            server="${python[python-lsp-server]}"
            ;;
        rust)
            server="${rust[rust-analyzer]}"
            ;;
        go)
            server="$gopls"
            ;;
        java|kt|jvm)
            server="${jdtls}"
            ;;
        c-cpp|c)
            server="${clangd}"
            ;;
        json)
            server="${jsonls}"
            ;;
        *)
            echo "❌ Unknown LSP type: $type"
            return 1
            ;;
    esac

    if [[ -n "$server" ]]; then
        echo "Installing $server for $type..."
        nvim --headless "+MasonInstall $server"
    fi
}

# Aliases for quick install
alias lsp-install='lsp_install'
alias lsp-ts='lsp_install ts typescript-language-server'
alias lsp-js='lsp_install js typescript-language-server'
alias lsp-py='lsp_install py python-lsp-server'
alias lsp-rust='lsp_install rust rust-analyzer'
alias lsp-go='lsp_install go gopls'
alias lsp-java='lsp_install java jdtls'
alias lsp-json='lsp_install json vscode-json-languageserver'
alias lsp-update='nvim --headless "+MasonUpdateAll"'
