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
alias bas="ssh bastion"
#alias cd="pushd"

function precmd {
    if [ -f .local/bin/activate ] ; then
        source .local/bin/activate
    fi
}

# Customize to your needs...
export GOROOT=/home/gl/src/go-dist
export GOPATH=/home/gl/src/go
export PATH=$PATH:/home/gl/node_modules/.bin/:/home/gl/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$GOROOT/bin:$GOPATH/bin:/home/gl/anaconda3/bin
export PAGER="less -S"
export DEBEMAIL="gleveque@itrust.fr"
export DEBFULLNAME="Ghislain Lévêque"

###-begin-yo-completion-###
_yo_completion () {
  local cword line point words si
  read -Ac words
  read -cn cword
  let cword-=1
  read -l line
  read -ln point
  si="$IFS"
  IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                     COMP_LINE="$line" \
                     COMP_POINT="$point" \
                     yo-complete completion -- "${words[@]}" \
                     2>/dev/null)) || return $?
  IFS="$si"
}
compctl -K _yo_completion yo
###-end-yo-completion-###
#
bindkey '^R' history-incremental-pattern-search-backward
