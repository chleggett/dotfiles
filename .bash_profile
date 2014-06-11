# Set vi keybindings
set -o vi

alias e="exit"
alias q="exit"
alias c="clear"
alias nmap="nmap -Pn"
alias chbspasswd="chbspasswd -w 3 -b d,1 -a s,1"

export CLICOLOR=1
export LSCOLORS="hxDxbxdxcxegedabagacad"

# Custom bash prompt via kirsle.net/wizards/ps1.html
export PS1="\[$(tput setaf 2)\]\u\[$(tput setaf 6)\]@\[$(tput setaf 2)\]\h\[$(tput setaf 6)\]: \[$(tput setaf 6)\]\W \[$(tput setaf 6)\]\\$ \[$(tput sgr0)\]"

export PAGER=vimpager
alias less=$PAGER
alias zless=$PAGER

export HOMEBREW_SVN="/usr/local/bin/svn"
export HOMEBREW_GITHUB_API_TOKEN="14636cf55809ec40dee34d77cd09913406f950f7"

export SVN_EDITOR=vim
export EDITOR=vim

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin::/opt/X11/bin:/usr/local/MacGPG2/bin:~/bin:~/bin-is:/Applications/Splunk/bin"

# Using rbenv to avoid the OS X provided ruby installation
eval "$(rbenv init -)"

export PYTHONPATH="/usr/local/Cellar/bulk_extractor/1.3.1/share/bulk_extractor/python"

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

## TMUX
#if which tmux 2>&1 >/dev/null; then
#  if [ -z "$TMUX" ]; then
#    ($(tmux ls | grep -vq attached) && $(exec tmux attach -t $(tmux ls | grep -vm1 attached | cut -d: -f1))) || exec tmux new
#  fi
#fi

