# Charles H. Leggett's .zshrc
# there are many like it, but this one is mine.

source /usr/local/opt/zsh-git-prompt/zshrc.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

## Setup prompt ########################################
PROMPT='%n@%m %c %# '
RPROMPT='$(git_super_status)'

# GIT_PROMPT_EXECUTABLE="haskell"
ZSH_THEME_GIT_PROMPT_CACHE="1"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

## Make things pretty ##################################
export CLICOLOR=1

## Run tmux if not already in a tmux session ###########
if [ "$TMUX" = "" ]; then exec tmux; fi
#if [[ -z "$TMUX" ]]; then
#    if tmux has-session 2>/dev/null; then
#        exec tmux attach
#    else
#        exec tmux
#    fi
#fi

## Set up environment ##################################
export TERM="xterm-256color"

PATH="$PATH:/Users/cleggett/bin"
PATH="$PATH:/Users/cleggett/bin-is"
export PATH


## Set aliases for convenience #########################
alias srczshrc="source ~/.zshrc"
alias srctmuxconf="tmux source ~/.tmux.conf"
alias e="exit"
alias q="exit"
alias c="clear"
alias tml="tmux list-sessions"
alias tmk="tmux kill-session -t"
alias speedtest="speedtest-cli"
alias finder="open ."
alias numbers="open -a Numbers"
alias pg="ping 8.8.8.8"
alias nmap="nmap -Pn"
alias chbspasswd="chbspasswd -w 3 -b d,1 -a s,1"


## Save and share history ##############################
HISTFILE=~/.zsh_history
SAVEHIST=1000
setopt inc_append_history
# setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space


## Enable completion ###################################
autoload -U compinit
compinit


## Use Vim everywhere! #################################
bindkey -v
export KEYTIMEOUT=1
#export PAGER=vimpager
#alias less=$PAGER
#alias zless=$PAGER
export EDITOR=vim


## Setup zsh-history-substring-search ##################
# bind UP and DOWN arrow keys

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

