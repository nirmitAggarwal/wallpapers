
# ╭──────────────────────────────────────────────╮
# │         NIRMIT'S DEVELOPER SHELL          │
# ╰──────────────────────────────────────────────╯

# ── Bash settings ─────────────────────────────
export EDITOR="zed"
export VISUAL="zed"
export PAGER="less"

shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s globstar

# ── History ──────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# ── Colors ───────────────────────────────────
export CLICOLOR=1
export LS_COLORS="di=1;34:ln=1;36:ex=1;32:*.rs=1;31:*.py=1;33:*.js=1;33:*.ts=1;36"


# ── Fastfetch ────────────────────────────────
if command -v fastfetch &>/dev/null && [[ $- == *i* ]]; then
    fastfetch
fi

# ── Zoxide (smart cd) ────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# ── FZF ─────────────────────────────────────
if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d'
fi

# ── Direnv ──────────────────────────────────
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# ── Rust / Cargo ─────────────────────────────
if [[ -d "$HOME/.cargo" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ── NVM (Node Version Manager) ──────────────
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
    source "$NVM_DIR/bash_completion"
fi

# ── Bun ─────────────────────────────────────
if [[ -d "$HOME/.bun/bin" ]]; then
    export PATH="$HOME/.bun/bin:$PATH"
fi

# ── Python ──────────────────────────────────
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# ── PATH additions ───────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# ── Developer aliases ────────────────────────
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltr'
alias lS='ls -lS'

# Navigation
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias cls='clear'
alias home='cd ~'
alias downloads='cd ~/Downloads'
alias desktop='cd ~/Desktop'
alias projects='cd ~/Projects'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# System
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias cleanup='sudo apt autoremove'
alias ports='ss -tulnp'
alias myip='curl -s https://ifconfig.me'

# Rust
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'
alias cc='cargo check'
alias ccl='cargo clippy'

# Node
alias nr='npm run'
alias ni='npm install'
alias nid='npm install -D'
alias nrd='npm run dev'
alias nrb='npm run build'

# Docker
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# ── Custom functions ──────────────────────────

# Create a directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files/folders by name
ff() {
    find . -iname "*$1*" 2>/dev/null
}

# Search text recursively
search() {
    grep -rnw . -e "$1" --exclude-dir=.git 2>/dev/null
}

# Extract common archive formats
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *) echo "Unsupported archive format: $1" ;;
        esac
    else
        echo "File not found: $1"
    fi
}

# Fuzzy-find and edit a file with Zed
fzed() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {}' --select-1)
    [[ -n "$file" ]] && zed "$file"
}

# Fuzzy directory navigation
fcd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# Custom compact prompt
PS1='\[\e]0;\u@\h: \w\a\]\[\e[38;5;141m\]\u\[\e[0m\] \[\e[38;5;110m\]\w\[\e[0m\] \$ '

eval "$(zoxide init bash)"
# ── Welcome message ───────────────────────────
# Fastfetch handles the welcome screen.
. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
