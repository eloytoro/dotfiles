# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

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

export LANG=en_US.UTF-8

# export FZF_DEFAULT_COMMAND='ag -g ""'
if [ -x "$(command -v fd)" ]; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
else
  export FZF_DEFAULT_COMMAND='find * -type f'
fi
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'
if [ -x ~/.config/nvim/plug/fzf.vim/bin/preview.rb ]; then
  export FZF_CTRL_T_OPTS="--preview '~/.config/nvim/plug/fzf.vim/bin/preview.rb {} | head -200'"
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

export EDITOR=nvim

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export TERM=xterm-256color

# local node_modules
export PATH=./node_modules/.bin:$PATH


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

if [ -d "$HOME/dotfiles/bin" ]; then
  export PATH=$PATH:$HOME/dotfiles/bin
fi

export CFLAGS="-I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib"

# c - browse chrome history
c() {
  local cols sep
  export cols=$(( COLUMNS / 3 ))
  export sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select title, url from urls order by last_visit_time desc" |
  ruby -ne '
    cols = ENV["cols"].to_i
    title, url = $_.split(ENV["sep"])
    len = 0
    puts "\x1b[36m" + title.each_char.take_while { |e|
      if len < cols
        len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
      end
    }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
  fzf --ansi --multi --no-hscroll --tiebreak=index |
  sed 's#.*\(https*://\)#\1#' | xargs open
}

# GIT heart FZF
# -------------

fzf-down() {
  fzf --height 50% "$@" --border
}

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
  git branch --color=always | grep -v '/HEAD\s' | sort |
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
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" $@ --graph --color=always |
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

gc() {
  gb | xargs git checkout
}

opl() {
  op list items |
  jq '[.[] | [.overview.title, .uuid] | join(": ")] | join("\n")' -r |
  fzf-down --ansi --multi --tac --preview-window right:40% \
    --preview 'op get item $(sed "s/^.*:[[:space:]]//" <<< {}) | jq "{ title: .overview.title, fields: .details.fields | map(.designation) }" -C' |
  sed "s/^.*:[[:space:]]//" |
  xargs -I {} op get item {} |
  jq ".details.fields | map(select(.designation == \"password\")) | .[0].value" -r
}

if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
  bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
  bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
  bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
fi

# Z integration
# source "$HOME/dotfiles/z.sh"
# unalias z 2> /dev/null
# z() {
#   [ $# -gt 0 ] && _z "$*" && return
#   cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
# }

function enable_proxy() {
        export HTTP_PROXY=http://webproxy.lhr4.dqs.booking.com:3128/
        export http_proxy=http://webproxy.lhr4.dqs.booking.com:3128/
        export HTTPS_PROXY=http://webproxy.lhr4.dqs.booking.com:3128/
        export https_proxy=http://webproxy.lhr4.dqs.booking.com:3128/
}

function appstore() {
  sshfs adm:/usr/local/git_tree/main/apps/admin/hoteladmin/extranet_ng/static/js/manage/app_store/app/ $HOME/workspace/appstore
  cd $HOME/workspace/appstore
}
