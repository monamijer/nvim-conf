# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# ~/.zshrc — Optimized Arch Linux Shell Configuration
# Manager: Zinit (fast, lazy-loading plugin manager)
# Target: <80ms startup time
# ============================================================

# ------------------------------------------------------------
# PROFILING (uncomment to debug slow startup)
# Run: zsh -i -c exit && zprof
# ------------------------------------------------------------
# zmodload zsh/zprof

# ------------------------------------------------------------
# 1. ENVIRONMENT — set early, before anything sources them
# ------------------------------------------------------------
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS="-R --mouse"

# XDG base dirs (many tools respect these)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# PATH — single declaration, no duplicate checks needed here
# (duplicates are cleaned below via typeset)
path=(
  "$HOME/.local/bin"
  "$HOME/.local/share/pnpm"   # pnpm
  $path
)
# Remove duplicate PATH entries silently
typeset -U path

# NVM — lazy-load: only sourced when `nvm`, `node`, or `npm` is first called
# This alone saves ~200-400ms on startup.
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { nvm; node "$@"; }
npm()  { nvm; npm  "$@"; }
npx()  { nvm; npx  "$@"; }

# Wayland / Hyprland environment variables
# (keep them here so any shell started from Hyprland inherits them)
export XCURSOR_SIZE=24
export XCURSOR_THEME=Bibata-Modern-Ice
export MOZ_ENABLE_WAYLAND=1          # Firefox on Wayland
export QT_QPA_PLATFORM=wayland       # Qt apps on Wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1 # Fix blank Java windows in WMs

# ------------------------------------------------------------
# 2. ZINIT BOOTSTRAP
# Install path: ~/.local/share/zinit/zinit.git
# One-time install: bash <(curl -sL git.io/zinit-install)
# ------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{cyan}Zinit not found. Installing…%f"
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ------------------------------------------------------------
# 3. PLUGINS — loaded with appropriate strategies
#
#  wait"0"  → deferred (loaded asynchronously after prompt)
#  lucid    → suppress output
#  atinit   → run code before loading
#  atload   → run code after loading
# ------------------------------------------------------------

# -- Prompt: Powerlevel10k (instant, no wait needed) --
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Load p10k config if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -- Syntax highlighting (must be near the end of plugin loading) --
zinit ice wait"0" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# -- Autosuggestions (fish-like, deferred) --
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# -- Better completions (deferred) --
zinit ice lucid blockf
zinit light zsh-users/zsh-completions

# -- fzf-tab: replace default completion menu with fzf (deferred) --
zinit ice lucid
zinit light Aloxaf/fzf-tab

# -- Useful aliases (git, docker, etc.) — light, no overhead --
zinit ice wait"1" lucid
zinit snippet OMZP::git

# ------------------------------------------------------------
# 4. COMPLETION SYSTEM
# ------------------------------------------------------------
autoload -Uz compinit
compinit -C


# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# ------------------------------------------------------------
# 5. HISTORY
# ------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS       # Don't record duplicate consecutive entries
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt SHARE_HISTORY          # Share history between all sessions
setopt INC_APPEND_HISTORY     # Add commands immediately, not on exit

# ------------------------------------------------------------
# 6. ZSH OPTIONS
# ------------------------------------------------------------
setopt AUTO_CD           # cd without typing cd
setopt CORRECT           # Auto-correct commands
setopt GLOB_DOTS         # Include dotfiles in glob patterns
setopt EXTENDED_GLOB     # Extended globbing (**, ^pattern, etc.)
setopt NO_BEEP           # No bell on errors
setopt PROMPT_SUBST      # Allow prompt substitution

# Vi mode (optional — comment out if you prefer emacs/default)
# bindkey -v

# Emacs-style keybindings (default, friendlier for most users)
bindkey -e
bindkey '^[[A' history-search-backward  # Up arrow: history search
bindkey '^[[B' history-search-forward   # Down arrow: history search
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete key

# ------------------------------------------------------------
# 7. ALIASES
# ------------------------------------------------------------

# -- Navigation --
alias ..=' cd ..'
alias ...=' cd ../..'
alias ....=' cd ../../..'
alias ~=' cd ~'
alias cdm='  cd ~/Documents/priv.2.2.2.2/music/download'
alias cdb='  cd ~/Documents/jerome/backend'
alias cdf='  cd ~/Documents/jerome/frontend'
alias cdw='  cd ~/Downloads'
alias cdo='  cd ~/Documents'
alias cdv='  cd ~/Videos'
alias cdoc=' cd ~/Documents/priv.2.2.2.2/.doc/'

# -- Listing (use eza if available, fallback to ls) --
if command -v eza &>/dev/null; then
  alias ls=' eza --icons --group-directories-first'
  alias ll=' eza -lah --icons --group-directories-first --git'
  alias lt=' eza --tree --icons --level=2'
else
  alias ls=' ls --color=auto -F'
  alias ll=' ls -lahF --color=auto'
fi

# -- Editor --
alias v=' nvim'
alias vi=' nvim'

# -- Shell config --
alias zshrc=' vim ~/.zshrc'
alias giro=' source ~/.zshrc && reset && echo "✓ zshrc reloaded"'

# -- Pacman / Yay --
alias pac=' sudo pacman'
alias pacs=' sudo pacman -S'
alias pacss=' pacman -Ss'
alias pacr=' sudo pacman -Rns'
alias pacu=' sudo pacman -Syu'
alias paci=' pacman -Qi'
alias yays=' yay -S'
alias yayu=' yay -Syu'

# -- System --
alias df=' df -h'
alias du=' du -h'
alias dud=' du -h --max-depth=1'
alias png=' ping -i 0.01 google.com'
alias free='free -h'
alias ps=' ps auxf'
alias top=' btop'                        # requires btop
alias open=' xdg-open'
alias pbcopy=' wl-copy'                  # Wayland clipboard
alias c=' clear'
alias pbpaste='  wl-paste'
alias photos=" fd -i '\.(jpg|jpeg|png|gif|webp|tiff|bmp)$'"
alias videos=" fd -i '\.(mp4|mkv|avi|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp)$'"

# -- Git shortcuts (complements the git plugin) --
alias g=' git'
alias gs=' git status'
alias gd=' git diff'
alias gc=' git commit -m'
alias gp=' git push'
alias gl=' git pull'
alias glog=' git log --oneline --graph --decorate --all'

# -- Safety nets --
alias rm=' rm -i'
alias cp=' cp -i'
alias mv=' mv -i'

# -- Networking --
alias myip=' curl -s ifconfig.me && echo'
alias localip=" ip route get 1 | awk '{print \$7; exit}'"

# -- other alias --
alias bvlc=' vlc -I rc --loop $1'
alias lgrep=' ls -lha | grep -i --color=always $1'
alias def=' sdcv $1'

# -- connection and wifi alias
alias wf=' for i in {1..10}; do nmcli d w; done'
alias wfs=' nmcli d w sh'
alias wfc=' nmcli d w c'
alias pirate-get='pirate-get -C "aria2c -c -x 8 -s 8 %s"'

# -- pkill alias for closing process
alias pcj=' killall caja'
alias pch=' killall /usr/lib/chromium/chromium || killall chromium'
alias pfr=' killall firefox'
alias pcd=' killall code-oss'
alias pwf=' systemctl poweroff'
# ------------------------------------------------------------
# 8. FUNCTIONS
# ------------------------------------------------------------

# Create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Fuzzy-find and edit a file (requires fzf)
fe() {
  local file
  file=$(fzf --preview 'bat --color=always {}' 2>/dev/null) && ${EDITOR} "$file"
}

nmfix() {
    if (( $# != 1 )); then
        echo "Usage: nmfix <connection-name>"
        return 1
    fi

    local con="$1"

    if ! nmcli con mod "$con" \
        ipv4.dhcp-send-hostname false \
        ipv6.dhcp-send-hostname false \
        ipv4.dhcp-client-id mac \
        ipv4.dhcp-iaid mac \
        ipv6.dhcp-iaid mac \
        ipv4.dhcp-hostname ""; then

        echo "✗ Failed to configure Wi-Fi connection: $con"
        return 1
    fi

    echo "✓ Wi-Fi connection configured successfully: $con"
}

# Quick archive extraction
extract() {
  case "$1" in
    *.tar.bz2)  tar xjf "$1"    ;;
    *.tar.gz)   tar xzf "$1"    ;;
    *.tar.xz)   tar xJf "$1"    ;;
    *.bz2)      bunzip2 "$1"    ;;
    *.gz)       gunzip "$1"     ;;
    *.zip)      unzip "$1"      ;;
    *.7z)       7z x "$1"       ;;
    *.rar)      unrar x "$1"    ;;
    *)          echo "Unknown archive format: $1" ;;
  esac
}

# Show most-used commands (useful for creating aliases)
topcmds() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head -20
}

# ------------------------------------------------------------
# 9. FZF INTEGRATION (install: pacman -S fzf)
# ------------------------------------------------------------
if command -v fzf &>/dev/null; then
  source /usr/share/fzf/key-bindings.zsh 2>/dev/null
  source /usr/share/fzf/completion.zsh   2>/dev/null

  export FZF_DEFAULT_OPTS="
    --height=40%
    --layout=reverse
    --border=rounded
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  "
  # Use fd for fzf file search if available
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ------------------------------------------------------------
# 10. AUTOSUGGESTIONS CONFIG
# ------------------------------------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,italic"
# Accept suggestion with Ctrl+Space or right arrow
bindkey '^ ' autosuggest-accept
bindkey '^[[C' autosuggest-accept   # Right arrow

# ------------------------------------------------------------
# PROFILING END (uncomment if profiling is active above)
# ------------------------------------------------------------
# zprof
alias php-xampp="/opt/lampp/bin/php"
source /usr/share/fzf/key-bindings.zsh 2>/dev/null
source /usr/share/fzf/completion.zsh   2>/dev/null
# ------------------------------------------------------------
# NMFIX COMPLETION
# ------------------------------------------------------------

_nmfix_connections() {
    local -a connections

    connections=(
        "${(@f)$(
            nmcli -t -f NAME,TYPE connection show 2>/dev/null |
            awk -F: '$2 == "802-11-wireless" {print $1}'
        )}"
    )

    _describe 'Wi-Fi connections' connections
}

_nmfix() {
    _arguments '1:Wi-Fi connection:_nmfix_connections'
}

compdef _nmfix nmfix
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
