export TERM="xterm-256color"
export EDITOR="nvim"




path+=('/Users/solardebris/build/homebrew/bin/')
path+=('/Users/solardebris/.cargo/bin')
path+=('/Users/solardebris/build/')

export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH


alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."






# Networking 
alias me="echo $(ifconfig $WIFI | grep "inet " | cut -b 9- | cut -d " " -f 2)"
alias myip="curl ipinfo.io/ip"
alias ports="netstat -tulpn"

# Git Stuff

git config --global alias.lmao "!git add . && git commit -m "$(curl -s https://whatthecommit.com/index.txt)" && git push"





eval "$(starship init zsh)"

