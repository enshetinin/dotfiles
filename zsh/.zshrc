# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/yev/.zsh/completions:"* ]]; then export FPATH="/Users/yev/.zsh/completions:$FPATH"; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Set directory where we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone --depth=1 git@github.com:zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
fi

# Source/Load zinit
if [ -f "${ZINIT_HOME}/zinit.zsh" ]; then
  source "${ZINIT_HOME}/zinit.zsh"
fi

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# Load zsh-completions
autoload -U compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

alias gh="cd ~/Desktop/"
alias gc="cd ~/.config/"
alias ..="cd .."
alias l="eza -l --icons"
alias show="ls -la --color=always"
alias gg="serie"
alias lg="lazygit"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Created by `pipx` on 2025-08-13 10:27:21
export PATH="$PATH:/Users/yev/.local/bin"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

export DOTNET_ROOT="/usr/local/share/dotnet"
export DOTNET_MULTILEVEL_LOOKUP=0
export PATH="$DOTNET_ROOT:$PATH"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

alias love="/Applications/love.app/Contents/MacOS/love"

[[ -f ~/.config/broot/launcher/bash/br ]] && source ~/.config/broot/launcher/bash/br

eval "$(fzf --zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/Users/yev/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/yev/.bun/_bun" ] && source "/Users/yev/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/development/flutter/bin"

alias luamake="'/Users/yev/.local/share/nvim/debuggers/luamake/luamake'"
. "/Users/yev/.deno/env"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export NDK_HOME="$ANDROID_HOME/ndk/30.0.15729638"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

alias blender='/Applications/Blender.app/Contents/MacOS/Blender'

# Unity CLI
. "/Users/yev/.unity/env"
