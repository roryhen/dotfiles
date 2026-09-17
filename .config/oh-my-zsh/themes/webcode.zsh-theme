# webcode.zsh-theme

webcode_git_prompt_status() {
  local status_text line index_status worktree_status
  local has_staged=false has_modified=false has_deleted=false
  local has_renamed=false has_unmerged=false has_untracked=false
  local has_ahead=false has_behind=false has_diverged=false has_stashed=false
  local -a status_lines

  status_text=$(__git_prompt_git status --porcelain -b 2> /dev/null) || return
  status_lines=(${(@f)status_text})

  if [[ ${status_lines[1]} == '## '* ]]; then
    if [[ ${status_lines[1]} == *' diverged '* ]]; then
      has_diverged=true
    elif [[ ${status_lines[1]} == *' ahead '* ]]; then
      has_ahead=true
    elif [[ ${status_lines[1]} == *' behind '* ]]; then
      has_behind=true
    fi
  fi

  for line in $status_lines[2,-1]; do
    index_status=${line[1]}
    worktree_status=${line[2]}

    if [[ $index_status == \? && $worktree_status == \? ]]; then
      has_untracked=true
      continue
    fi

    if [[ $index_status == U || $worktree_status == U ]]; then
      has_unmerged=true
    elif [[ $index_status == R ]]; then
      has_staged=true
      has_renamed=true
    elif [[ -n $index_status && $index_status != ' ' ]]; then
      has_staged=true
    fi

    case $worktree_status in
      M) has_modified=true ;;
      D) has_deleted=true ;;
    esac
  done

  __git_prompt_git rev-parse --verify refs/stash &> /dev/null && has_stashed=true

  local git_status=''
  [[ $has_untracked == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_UNTRACKED
  [[ $has_deleted == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_DELETED
  [[ $has_modified == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_MODIFIED
  [[ $has_renamed == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_RENAMED
  [[ $has_staged == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_STAGED
  [[ $has_unmerged == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_UNMERGED
  [[ $has_stashed == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_STASHED
  [[ $has_ahead == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_AHEAD
  [[ $has_behind == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_BEHIND
  [[ $has_diverged == true ]] && git_status+=$ZSH_THEME_GIT_PROMPT_DIVERGED

  [[ -n $git_status ]] && print -n " $git_status"
}

PROMPT='%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info)$(webcode_git_prompt_status) %(?.%{$fg[blue]%}.%{$fg[red]%})❯%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%} on %{$fg_bold[yellow]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_CLEAN=''

ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✕"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}⇢"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}?"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}↓"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%}↕"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[cyan]%}⚑"

# Right prompt
webcode_tool_version() {
  local tool=$1 search_dir=$2 project_dir='' version

  while [[ $search_dir != / ]]; do
    if [[ $tool == node && ( -e $search_dir/package.json || -e $search_dir/.node-version || -e $search_dir/.nvmrc || -e $search_dir/mise.toml || -e $search_dir/.tool-versions ) ]]; then
      project_dir=$search_dir
      break
    elif [[ $tool == deno && ( -e $search_dir/deno.json || -e $search_dir/deno.jsonc || -e $search_dir/mise.toml || -e $search_dir/.tool-versions ) ]]; then
      project_dir=$search_dir
      break
    elif [[ $tool == python && ( -e $search_dir/pyproject.toml || -e $search_dir/requirements.txt || -e $search_dir/setup.py || -e $search_dir/.python-version || -e $search_dir/mise.toml || -e $search_dir/.tool-versions ) ]]; then
      project_dir=$search_dir
      break
    fi
    search_dir=${search_dir:h}
  done

  [[ -z $project_dir ]] && return

  if (( $+commands[mise] )); then
    version=$(cd "$project_dir" && mise current "$tool" 2> /dev/null)
    version=${version%%$'\n'*}
  fi

  if [[ -z $version ]] && (( $+commands[$tool] )); then
    version=$($tool --version 2> /dev/null)
    version=${version%%$'\n'*}
    version=${version##* }
  fi
  [[ -n $version ]] && print -r -- "$version"
}

webcode_aws_status() {
  local cache_key=${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-default}}
  local now=$EPOCHSECONDS

  if [[ $webcode_aws_cache_key != $cache_key || $(( now - webcode_aws_cache_time )) -ge 60 ]]; then
    webcode_aws_cache_key=$cache_key
    webcode_aws_cache_time=$now
    webcode_aws_cache_value=''

    if (( $+commands[aws] )) && aws sts get-caller-identity --output text >/dev/null 2>&1; then
      webcode_aws_cache_value=" %{$fg[yellow]%}󰸏%{$reset_color%}"
    fi
  fi

  print -n -- "$webcode_aws_cache_value"
}

webcode_colima_status() {
  local now=$EPOCHSECONDS colima_status runtime runtime_line
  local -a colima_lines

  if (( now - webcode_colima_cache_time >= 5 )); then
    webcode_colima_cache_time=$now
    webcode_colima_cache_value=''

    if (( $+commands[colima] )); then
      colima_status=$(colima status 2>&1)
      colima_lines=(${(@f)colima_status})
      runtime_line=${(M)colima_lines:#*'runtime: '*}
      runtime=${runtime_line##*'runtime: '}
      runtime=${runtime%%\"*}
      [[ -n $runtime ]] && webcode_colima_cache_value=" %{$fg[cyan]%}󰡨 $runtime%{$reset_color%}"
    fi
  fi

  print -n -- "$webcode_colima_cache_value"
}

webcode_right_prompt() {
  local project_dir=$PWD
  local node_version=$(webcode_tool_version node "$project_dir")
  local deno_version=$(webcode_tool_version deno "$project_dir")
  local python_version=$(webcode_tool_version python "$project_dir")
  local tool_status=''

  [[ -n $node_version ]] && tool_status+=" %{$fg[green]%}󰎙 $node_version%{$reset_color%}"
  [[ -n $deno_version ]] && tool_status+=" %{$fg[magenta]%} $deno_version%{$reset_color%}"
  [[ -n $python_version ]] && tool_status+=" %{$fg[blue]%} $python_version%{$reset_color%}"

  print -n -- "$tool_status$(webcode_aws_status)$(webcode_colima_status)"
}

RPROMPT='$(webcode_right_prompt)'
