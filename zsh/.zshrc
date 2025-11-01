# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export TERMINAL=kitty

#bindkey -v

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
	git
	vi-mode
)

source $ZSH/oh-my-zsh.sh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# User configuration
path+=($HOME/Applications/flutter/bin/)
path+=($HOME/Applications/)
path+=($HOME/.pub-cache/bin/)
path+=($HOME/.local/bin/)

# Turso
export PATH="$PATH:/home/joeser/.turso"
export PATH="/home/joeser/.shorebird/bin:$PATH"
# Go
export PATH=$PATH:/usr/local/go/bin
export PATH="$BUN_INSTALL/bin:$PATH"

# Varibles
export CHROME_EXECUTABLE=/usr/bin/chromium
export JAVA_HOME=/home/joeser/Applications/jdk-17.0.13
export LLDB_USE_NATIVE_PDB_READER=yes

# bun
export BUN_INSTALL="$HOME/.bun"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="cd ~/dotfiles/nvim/.config/nvim && nvim"
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# Initialize zsh completions
autoload -Uz compinit
compinit
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/joeser/.dart-cli-completion/zsh-config.zsh ]] && . /home/joeser/.dart-cli-completion/zsh-config.zsh || true
# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/joeser/.zsh/completions:"* ]]; then export FPATH="/home/joeser/.zsh/completions:$FPATH"; fi
# bun completions
[ -s "/home/joeser/.bun/_bun" ] && source "/home/joeser/.bun/_bun"
## [/Completion]

. "$HOME/.local/bin/env"
. "/home/joeser/.deno/env"

# opencode
export PATH=/home/joeser/.opencode/bin:$PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
