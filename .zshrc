# Charles H. Leggett's .zshrc
# there are many like it, but this one is mine.

## Use Antigen to manage plugins #######################
source ~/.antigen/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

## Setup prompt and make things pretty #################
PROMPT='%n@%m %c %# '
RPROMPT='%~'
export CLICOLOR=1
# LSCOLORS string to approximate solarized colorscheme
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD


## Set up environment ##################################
PATH="/usr/local/bin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"
PATH="$PATH:/Users/cleggett/bin"
PATH="$PATH:/Users/cleggett/bin-is"
PATH="$PATH:/opt/X11/bin"
PATH="$PATH:/usr/local/MacGPG2/bin"
PATH="$PATH:/Applications/Splunk/bin"
export PATH


## Set aliases for convenience #########################
alias e="exit"
alias q="exit"
alias c="clear"
alias pg="ping 8.8.8.8"
#alias nmap="nmap -Pn"
alias chbspasswd="chbspasswd -w 3 -b d,1 -a s,1"
alias showFiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideFiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"


## Save and share history ##############################
HISTFILE=~/.zsh_history
SAVEHIST=1000
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


## Setup zsh-history-substring-search ##################
# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


## Source .zshrc.homebrew for HOMEBREW_GITHUB_API_TOKEN
source ~/.zshrc.homebrew
