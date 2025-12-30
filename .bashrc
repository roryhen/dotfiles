### bash

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export CLICOLOR=1

# Path mods
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

### aliases

# files
alias ll='ls -a'

# misc
alias src='source ~/.bashrc'
alias history='history | fzf'
alias joke='curl -s -H "Accept: application/json" https://v2.jokeapi.dev/joke/Programming\?blacklistFlags\=nsfw,religious,political,racist,sexist,explicit | jq ".joke, .setup, .delivery | select(.)"'
alias dadjoke='echo -n "$(tput setaf 2)\""; curl -s -H "User-Agent: https://github.com/roryhen" -H "Accept: text/plain" https://icanhazdadjoke.com | \cat; echo "\"$(tput sgr0)"'
function path() { echo "$PATH" | tr ':' '\n'; }
function tomp4() { ffmpeg -i "$1" -vcodec libx264 -crf 28 "$2"; }
alias kvim='NVIM_APPNAME="kvim" nvim'
alias vim='NVIM_APPNAME="vim" nvim'

# git
alias gst='git status'
alias grs='git restore'
alias grst='git restore --staged'
alias gbd='git branch --delete'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gpf="git fetch && git pull --ff-only"
alias gpra="git pull --rebase --autostash"
alias gsta='git stash push'
alias glog='git log --oneline --decorate --graph'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias ghist="git log --format=reference -p --follow --"
alias ghas='gh auth switch'
function gswb() {
  local BRANCHES=""
  local BRANCH=""
  BRANCHES=$(git for-each-ref --format='%(refname:lstrip=1)' | sed -E 's/^remotes\/|heads\///')
  BRANCH=$(echo "$BRANCHES" | fzf)
  git switch "$(echo "$BRANCH" | sed -E 's/^origin\///')"
}
alias trimbranch='echo "$(git branch --show-current)" | cut -c 1-36'

# web
alias lsport='lsof -iTCP -sTCP:LISTEN -n -P'
alias awsts='aws sts get-caller-identity'
function pdev() {
  local PORT="${1:-3000}"
  pnpm --color dev -p "$PORT" |
    tee /dev/tty | {
    grep -q "Ready in " && open "http://localhost:$PORT"
    cat >/dev/null
  }
}
function killport() {
  local PORT="$1"
  local PORTS=""
  local PID=""
  PORTS="$(lsof -iTCP -sTCP:LISTEN -n -P)"
  PID=$(echo "$PORTS" | grep -Eo "[0-9]+.*$PORT" | cut -d ' ' -f 1)
  kill -9 "$PID" && echo "Process $PID running on port $PORT stopped"
}
function crawlsitemap() {
  # check if empty arg
  if [[ -z "$1" ]]; then
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
function curltime() {
  curl -so /dev/null -w "\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

### apps

# fzf
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--height=40% --reverse"

# mise
eval "$(mise activate bash)"

# https://starship.rs
eval "$(starship init bash)"
