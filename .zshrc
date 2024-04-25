export TERM="xterm-256color"
export EDITOR="nvim"
export WIFI="$(ifconfig | grep wlp | cut -d ':' -f 1)"
export LANG="en_US.UTF-8"

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Mac Paths
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
export PATH=$PATH:/Users/solardebris/build/homebrew/bin/

alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Aliases
alias tmux='TERM=screen-256color tmux -2'
alias vim='nvim'
alias ls='exa -al --color=always --group-directories-first'
alias cat='bat'  # Default
alias pat='/bin/cat'  # Used for copying and pasting


alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Shortcuts 
alias copy='xsel --clipboard --input'
alias paste='xsel --clipboard --output'

# Networking 
alias me="echo $(ifconfig $WIFI | grep "inet " | cut -b 9- | cut -d " " -f 2)"
alias myip="curl ipinfo.io/ip"
alias ports="netstat -tulpn"

alias chbackground="feh --randomize --bg-fill ~/wallpapers/*"
alias newpwn="cp ~/stuff/templates/pwntemplate.py .; mv ./pwntemplate.py"
alias newangr="cp ~/stuff/templates/angrtemplate.py .; mv ./angrtemplate.py"
alias rz="rizin"

# Git Stuff
git config --global alias.lmao "!git add . && git commit -m "$(curl -s https://whatthecommit.com/index.txt)" && git push"

eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
