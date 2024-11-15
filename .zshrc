### zsh

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# update automatically without asking
zstyle ':omz:update' mode auto      

# oh-my-zsh plugins
plugins=(
  git
  colored-man-pages
  git-auto-fetch
  safe-paste
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Path mods
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

### aliases

# misc
alias src="omz reload"
alias history="history | fzf"
alias joke='curl -s -H "Accept: application/json" https://v2.jokeapi.dev/joke/Programming\?blacklistFlags\=nsfw,religious,political,racist,sexist,explicit | jq ".joke, .setup, .delivery | select(.)"'
alias dadjoke='echo -n "$(tput setaf 2)\""; curl -s -H "User-Agent: https://github.com/roryhen" -H "Accept: text/plain" https://icanhazdadjoke.com | \cat; echo "\"$(tput sgr0)"'
alias kvim='NVIM_APPNAME="nvim-ks" nvim'
function path() { echo $PATH | tr ':' '\n' }
function tomp4() { ffmpeg -i "$1" -vcodec libx264 -crf 28 "$2" }

# git
alias githistory="git log --format=reference -p --follow --"
alias ghas='gh auth switch'
function gswb() { 
  local BRANCHES=$(git for-each-ref --format='%(refname:lstrip=1)' | sed -E 's/^remotes\/|heads\///')
  local BRANCH=$(echo "$BRANCHES" | fzf)
  git switch "$(echo "$BRANCH" | sed -E 's/^origin\///')"
}

# web
alias lsport="lsof -iTCP -sTCP:LISTEN -n -P"
alias awsts='aws sts get-caller-identity'
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

### apps

# bat config
export BAT_THEME="base16"
export BAT_STYLE=snip

# https://starship.rs
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height=40% --reverse"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# mise
eval "$(mise activate zsh)"

# https://github.com/jeffreytse/zsh-vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
