# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME=agnoster

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugin configuration
ZSH_COLORIZE_STYLE=dracula

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  colorize
  colored-man-pages
  git-auto-fetch
  git
  node
  safe-paste
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Path mods
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"

# Aliases
alias cat="ccat"
alias src="omz reload"
alias pn="pnpm"
alias pdx="pnpm dlx"
alias pex="pnpm exec"
alias lsport="lsof -iTCP -sTCP:LISTEN -n -P"
alias githistory="git log --format=reference -p --follow --"
alias ncfg="nvim ~/.config/nvim"
alias joke='curl -s -H "Accept: application/json" https://v2.jokeapi.dev/joke/Programming\?blacklistFlags\=nsfw,religious,political,racist,sexist,explicit | jq ".joke, .setup, .delivery | select(.)"'
alias dadjoke='echo -n "$(tput setaf 2)\""; curl -s -H "User-Agent: https://github.com/roryhen" -H "Accept: text/plain" https://icanhazdadjoke.com | cat; echo "\"$(tput sgr0)"'
alias nvim-ks='NVIM_APPNAME="nvim-ks" nvim'

# Functions
function path() { echo $PATH | tr ':' '\n' }
function gswb() { 
  local BRANCHES=$(git for-each-ref --format='%(refname:lstrip=1)' | sed -E 's/^remotes\/|heads\///')
  local BRANCH=$(echo "$BRANCHES" | fzf)
  git switch "$(echo "$BRANCH" | sed -E 's/^origin\///')"
}
function pdev() {
  local PORT="${1:-3000}"
  pnpm --color dev -p $PORT |
    tee /dev/tty | {
      grep -q "Ready in " && open "http://localhost:$PORT"
      cat >/dev/null
    }
}
function killport() { 
  local PORT="$1"
  local PORTS="$(lsof -iTCP -sTCP:LISTEN -n -P)"
  local PID=$(echo "$PORTS" | grep -Eo "[0-9]+.*$PORT" | cut -d ' ' -f 1)
  kill -9 "$PID" && echo "Process $PID running on port $PORT stopped" 
}
function tomp4() { ffmpeg -i "$1" -vcodec libx264 -crf 28 "$2" }
function crawlsitemap() {
  # check if empty arg  
  if [[  -z "$1"  ]]; then 
    echo "Please provide a url"
    return
  fi
  # fetch sitemap
  curl -s "$1" | 
    # extract url
    sed -En 's/<loc>(.*)<\/loc>/\1/p' |
    # pass back to curl to print status (-P to spawn multiple processes)
    xargs -P10 -I {} curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" {} |
    # color line if status other than 200
    GREP_COLOR='01;31' grep -E --color '^[45]\d\d.*|$' | 
    GREP_COLOR='01;32' grep -E --color '^3\d\d.*|$'
}

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height=40% --reverse"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# mise
eval "$(mise activate zsh)"

# https://spaceship-prompt.sh
source /opt/homebrew/opt/spaceship/spaceship.zsh
