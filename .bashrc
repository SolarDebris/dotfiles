### Exports
export TERM="xterm-256color"
export EDITOR="nvim"
export WIFI="$(ifconfig | grep wlp | cut -d ':' -f 1)"
export LANG="en_US.UTF-8"

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


### PATH
if [ -d "$HOME/.bin" ] ;
    then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.cargo" ];
    then PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ];
    then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/applications" ];
    then PATH="$HOME/applications:$PATH"
fi

alias .1="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../.."

alias ls='exa -al --color=always --group-directories-first'

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Shortcuts 
alias copy='xsel --clipboard --input'
alias paste='xsel --clipboard --output'

# Aliases
alias tmux='TERM=screen-256color tmux -2'
alias vim='nvim'
alias ssh-add='eval `ssh-agent -s`; ssh-add' 
alias cat='bat'
alias pat='/bin/cat'

# Networking
alias me="echo $(ifconfig $WIFI | grep "inet " | cut -b 9- | cut -d " " -f 2)"
alias myip="curl ipinfo.io/ip"
alias ports="netstat -tulpn"

alias chbackground="feh --randomize --bg-fill ~/wallpapers/*"
alias newpwn="cp ~/stuff/templates/pwntemplate.py .; mv ./pwntemplate.py"
alias newangr="cp ~/stuff/templates/angrtemplate.py .; mv ./angrtemplate.py"
alias rz="rizin"

# Git Stuff
git config --global alias.lmao '!git add . && git commit -m "$(curl -s https://whatthecommit.com/index.txt)" && git push'

# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

# Checks if a tmux session is already running
if tmux has-session 2>/dev/null; then
    echo "A tmux session is running."

    if tmux list-sessions | grep -q "(attached)"; then
        echo "The tmux session is attached."
    else
        # Attach to the existing session
        tmux attach-session
    fi
else
    echo "No tmux session found. Creating a new session..."
    tmux new-session -s mysession
fi

