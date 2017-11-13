# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh
source $HOME/mes_aliases_git

alias lr="ls -artlh"
alias kssh="pkill -f .ssh/sockets"
alias support="ssh -l support"
#alias cd="pushd"

function precmd {
    if [ -f .local/bin/activate ] ; then
        source .local/bin/activate
    fi
}

# Customize to your needs...
export GOROOT=/home/gl/src/go-dist
export GOPATH=/home/gl/src/go
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PYENV_ROOT/bin:$PATH:/home/gl/Documents/Clients/bin/:/home/gl/node_modules/.bin/:/home/gl/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$GOROOT/bin:$GOPATH/bin:/home/gl/anaconda2/bin
export PAGER="less -S"
export DEBEMAIL="gleveque@itrust.fr"
export DEBFULLNAME="Ghislain Lévêque"

bindkey '^R' history-incremental-pattern-search-backward
