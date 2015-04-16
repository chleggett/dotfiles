# Charles H. Leggett's .zshrc
# there are many like it, but this one is mine.

## Setup prompt and make things pretty #################
PROMPT='%n@%m %c %# '
RPROMPT='%~'
export CLICOLOR=1
# LSCOLORS string to approximate solarized colorscheme
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD


## Set up environment ##################################
PATH=$PATH:~/bin
PATH=$PATH:~/bin-is
PATH=$PATH:/Applications/Splunk/bin


## Set aliases for convenience #########################
alias e="exit"
alias q="exit"
alias c="clear"
alias nmap="nmap -Pn"
alias chbspasswd="chbspasswd -w 3 -b d,1 -a s,1"


## Save and share history ##############################
HISTFILE=~/.zsh_history
SAVEHIST=100
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space


## Enable completion ###################################
autoload -U compinit
compinit


## Use Vim everywhere! #################################
bindkey -v
export KEYTIMEOUT=1
export PAGER=vimpager
alias less=$PAGER
alias zless=$PAGER
export EDITOR=vim


