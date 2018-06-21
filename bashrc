# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

if [ -e ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

### git-prompt
__git_ps1() { :;}
if [ -e ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi
PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
PS1=$PS1'\[\e[0;38m\]\w$(__git_ps1 "\[\033[38;5;214m\] [⎇ %s]")\[\e[1;35m\]\n$ \[\e[0m\]'

export EDITOR=nvim
export LANG=en_US.UTF-8

# export FZF_DEFAULT_COMMAND='ag -g ""'
if ! [ -x "$(command -v fd)" ]; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find * -type f'
fi
# export FZF_COMPLETION_OPTS='--extended --cycle --tiebreak=end,length'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -n $TMUX ]; then
  export NVIM_TUI_ENABLE_TRUE_COLOR=1
fi

_fzf_recent_branches() {
  git reflog | egrep -io "moving from ([^[:space:]]+)" | awk '{ print $3 }' | awk ' !x[$0]++' | fzf
}
alias gcor='git checkout $(_fzf_recent_branches)'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%an, %cr"'
alias gitme='git log --author="$(git config user.name)"'
alias opentorrent='peerflix --vlc -n -d --list '

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export TERM=xterm-256color

if [ -d "$HOME/.nvm" ]; then
  # local node_modules
  export PATH=$PATH:./node_modules/.bin
fi


if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

if [ -d "$HOME/.yarn" ]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

if [ -d "$HOME/.cargo" ]; then
  export PATH=$PATH:$HOME/.cargo/bin
fi

export CFLAGS="-I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"

# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -200'
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
  bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
  bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
  bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
fi

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -t __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi
