source $HOME/dotfiles/rc
source $HOME/dotfiles/p10k.zsh

# Git autocompletion
# autoload -Uz compinit
# compinit

# Git prompt
# autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst
# zstyle ':vcs_info:git:*' formats ' %F{11}[⎇ %b]%f'

# Emacs style bindings
bindkey -e

zstyle ':autocomplete:*' recent-dirs zoxide
+autocomplete:recent-directories() {
  reply=(${(f)"$(zoxide query --list)"})
}

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# PS1='%F{15}%n%f@%F{9}%m%f:%~${vcs_info_msg_0_}'$'\n'"$ "

# bindkey -v
