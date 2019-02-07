# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
unsetopt no_match

# Load the alias file
source $HOME/.aliases

# Turn wine debugging off to improve wine/steam performance
export WINEDBG=-all

source $HOME/.envvars

# A more elegant solution to ensure that ssh-agent is running
# and only one instance at a time
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(ssh-agent)"
fi

# Source virtualenv
if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
    source /usr/local/bin/virtualenvwrapper.sh
fi

export PYTHONSTARTUP=~/.pythonrc

# Fix dir_colors based on https://github.com/seebi/dircolors-solarized
if [ -f "$HOME/.dircolors/dircolors.ansi-dark" ]
then
    eval `dircolors "$HOME/.dircolors/dircolors.ansi-dark"`
fi
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit
 
# Fix the home issue when launching bash for WSL via terminator 
if [ -t 1 ]
then
    cd
fi
