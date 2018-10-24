#          __       __              
#         /\ \     /\ \             
#     __  \ \ \____\ \ \____  _ __  
#   /'__`\ \ \ '__`\\ \ '__`\/\`'__\
#  /\ \L\.\_\ \ \L\ \\ \ \L\ \ \ \/ 
#  \ \__/.\_\\ \_,__/ \ \_,__/\ \_\ 
#   \/__/\/_/ \/___/   \/___/  \/_/ 
#  
#  ABBR ZSH theme
#
#  Author: ... Philipp Molitor <http://phils-lab.io>                                 
#  Git: ...... https://github.com/philslab/abbr-zsh-theme
#


##################
#    Variables

ABBR_FG_RETVAL_GOOD="${ABBR_FG_RETVAL_GOOD:-white}"
ABBR_BG_RETVAL_GOOD="${ABBR_BG_RETVAL_GOOD:-green}"
ABBR_FG_RETVAL_BAD="${ABBR_FG_RETVAL_BAD:-yellow}"
ABBR_BG_RETVAL_BAD="${ABBR_BG_RETVAL_BAD:-black}"
ABBR_FG_LOGON="${ABBR_FG_LOGON:-black}"
ABBR_BG_LOGON="${ABBR_BG_LOGON:-cyan}"
ABBR_FG_PWD="${ABBR_FG_PWD:-white}"
ABBR_BG_PWD="${ABBR_BG_PWD:-none}"
ABBR_FG_PROMPT_ROOT="${ABBR_FG_PROMPT_ROOT:-red}"
ABBR_BG_PROMPT_ROOT="${ABBR_BG_PROMPT_ROOT:-none}"
ABBR_FG_PROMPT_DEFAULT="${ABBR_BG_LOGON}"
ABBR_BG_PROMPT_DEFAULT="${ABBR_BG_PROMPT_DEFAULT:-none}"
ABBR_FG_BADGE_PYTHON_VENV="${ABBR_FG_BADGE_PYTHON_VENV:-blue}"
ABBR_BG_BADGE_PYTHON_VENV="${ABBR_BG_BADGE_PYTHON_VENV:-yellow}"
ABBR_FG_BADGE_RUST="${ABBR_FG_BADGE_RUST:-white}"
ABBR_BG_BADGE_RUST="${ABBR_BG_BADGE_RUST:-blue}"
ABBR_FG_BADGE_GIT="${ABBR_FG_BADGE_GIT:-yellow}"
ABBR_BG_BADGE_GIT="${ABBR_BG_BADGE_GIT:-black}"
ABBR_FG_BADGE_GIT_UNTRACKED="${ABBR_FG_BADGE_GIT_UNTRACKED:-red}"
ABBR_FG_BADGE_GIT_DIRTY="${ABBR_FG_BADGE_GIT_DIRTY:-red}"


##################
#    Sections

# return value of last command
_abbr_section_retval () {
  local ret="$(print -nP '%?')"

  if [ "$ret" -eq "0" ]; then
    print -n "%{%F{$ABBR_FG_RETVAL_GOOD}%K{$ABBR_BG_RETVAL_GOOD}%} \u2713 "
  else
    print -n "%{%F{$ABBR_FG_RETVAL_BAD}%K{$ABBR_BG_RETVAL_BAD}%} $ret "
  fi

  print -n "%{%f%k%}"
}

# logon information: hostname/username
_abbr_section_logon () {
  print -n "%{%F{$ABBR_FG_LOGON}%K{$ABBR_BG_LOGON}%} %m/%n %{%f%k%}"
}

# current working directory, abbreviated (the magic part)
_abbr_section_pwd () {
  local p="$(print -nP '%/')"

  print -n "%{%F{$ABBR_FG_PWD}%K{$ABBR_BG_PWD}%} "
  
  [[ $p == $HOME/* || $p == $HOME ]] && p=${p#${HOME}} && print -n '~'

  for d in ${(s:/:)p}; do
    [[ "${d:0:1}" == "." ]] && print -n "/${d:0:2}" || print -n "/${d:0:1}"
  done

  [[ "${d:0:1}" == "." ]] && print -n "${d:2}" || print -n "${d:1}"

  print -n "%{%f%k%}"
}

# prompt end, $ for user, # for root
_abbr_section_prompt () {
  if [[ $UID = 0 ]]; then
    print -n "%{%F{$ABBR_FG_PROMPT_ROOT}%K{$ABBR_BG_PROMPT_ROOT}%}#"
  else
    print -n "%{%F{$ABBR_FG_PROMPT_DEFAULT}%K{$ABBR_BG_PROMPT_DEFAULT}%}$"
  fi
}


##################
#     Badges

# python virtualenv
_abbr_badge_venv () {
  if [[ -n $VIRTUAL_ENV ]]; then
    local env_name="$(echo $VIRTUAL_ENV | rev | cut -d'/' -f1 | rev)"
    print -n "%{%F{$ABBR_FG_BADGE_PYTHON_VENV}%K{$ABBR_BG_BADGE_PYTHON_VENV}%} $env_name %{%f%k%}"
  fi
}

# rust / cargo
_abbr_badge_rust () {
  local p="$(print -nP '%/')"

  while [[ $p != "" ]] && [[ $p != "/" ]]; do
    if [[ -f "$p/Cargo.toml" ]]; then
      local rust_version="$(rustc --version | cut -d' ' -f2)"

      print -n "%{%F{$ABBR_FG_BADGE_RUST}%K{$ABBR_BG_BADGE_RUST}%} $rust_version %{%f%k%}"
      return
    fi

    p="${${p%/}%/*}"
  done
}

# git status
_abbr_badge_git () {
  if $(git branch >/dev/null 2>&1); then
    print -n "%{%F{$ABBR_FG_BADGE_GIT}%K{$ABBR_BG_BADGE_GIT}%} \u00b1"

    # branch
    print -n "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    # untracked
    [[ "$(git clean -n 2>/dev/null | wc -l)" -ne "0" ]] && print -n "%{%F{$ABBR_FG_BADGE_GIT_UNTRACKED}%}?%{%f%}"

    # dirty
    $(git diff-index --quiet HEAD >/dev/null 2>&1) || print -n "%{%F{$ABBR_FG_BADGE_GIT_DIRTY}%}!%{%f%}"

    print -n " %{%f%k%}"
  fi
}


##################
#    Rendering

# assemble prompt components
_abbr_prompt () {
  _abbr_section_retval
  _abbr_section_logon
  _abbr_section_pwd
  _abbr_section_prompt
}

# assemble badges
_abbr_badges () {
  _abbr_badge_venv
  _abbr_badge_rust
  _abbr_badge_git
}

# render the prompt
_abbr_render () {
  PROMPT="%{%f%b%k%}$(_abbr_prompt)%{%f%b%k%} "
  RPROMPT="%{%f%b%k%}$(_abbr_badges)%{%f%b%k%}"
}

# add render hook
_abbr_setup () {
  prompt_opts=(cr percent sp subst)
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd _abbr_render
}

# run the setup
_abbr_setup

# vim: syntax=zsh
