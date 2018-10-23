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
ABBR_FG_BADGE_GIT="${ABBR_FG_BADGE_GIT:-yellow}"
ABBR_BG_BADGE_GIT="${ABBR_BG_BADGE_GIT:-black}"
ABBR_FG_BADGE_GIT_UNTRACKED="${ABBR_FG_BADGE_GIT_UNTRACKED:-red}"
ABBR_FG_BADGE_GIT_DIRTY="${ABBR_FG_BADGE_GIT_DIRTY:-red}"
ABBR_FG_BADGE_PYTHON_VENV="${ABBR_FG_BADGE_PYTHON_VENV:-blue}"
ABBR_BG_BADGE_PYTHON_VENV="${ABBR_BG_BADGE_PYTHON_VENV:-yellow}"


##################
#    Sections

_abbr_section_retval () {
  local ret="$(print -nP '%?')"

  if [ "$ret" -eq "0" ]; then
    print -n "%{%F{$ABBR_FG_RETVAL_GOOD}%K{$ABBR_BG_RETVAL_GOOD}%} \u2713 "
  else
    print -n "%{%F{$ABBR_FG_RETVAL_BAD}%K{$ABBR_BG_RETVAL_BAD}%} $ret "
  fi

  print -n "%{%f%k%}"
}

_abbr_section_logon () {
  print -n "%{%F{$ABBR_FG_LOGON}%K{$ABBR_BG_LOGON}%} %m/%n %{%f%k%}"
}

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

_abbr_section_prompt () {
  if [[ $UID = 0 ]]; then
    print -n "%{%F{$ABBR_FG_PROMPT_ROOT}%K{$ABBR_BG_PROMPT_ROOT}%}#"
  else
    print -n "%{%F{$ABBR_FG_PROMPT_DEFAULT}%K{$ABBR_BG_PROMPT_DEFAULT}%}$"
  fi
}


##################
#     Badges

# git status
_abbr_badge_git () {
  if $(git branch >/dev/null 2>&1); then
    local branch="$(git rev-parse --abbrev-ref HEAD)"
    
    print -n "%{%F{$ABBR_FG_BADGE_GIT}%K{$ABBR_BG_BADGE_GIT}%} \u00b1$branch"

    # untracked
    [[ "$(git clean -n | wc -l)" -ne "0" ]] && print -n "%{%F{$ABBR_FG_BADGE_GIT_UNTRACKED}%}?%{%f%}"

    # dirty
    $(git diff-index --quiet HEAD) || print -n "%{%F{$ABBR_FG_BADGE_GIT_DIRTY}%}!%{%f%}"

    print -n " %{%f%k%}"
  fi
}

# python virtualenv
_abbr_badge_venv () {
  if [[ -n $VIRTUAL_ENV ]]; then
    local env_name="$(echo $VIRTUAL_ENV | rev | cut -d'/' -f1 | rev)"
    print -n "%{%F{$ABBR_FG_BADGE_PYTHON_VENV}%K{$ABBR_BG_BADGE_PYTHON_VENV}%} $env_name %{%f%k%}"
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

# Assemble badges
_abbr_badges () {
  _abbr_badge_git
  _abbr_badge_venv
}

# Render the prompt
_abbr_render () {
  PROMPT="%{%f%b%k%}$(_abbr_prompt)%{%f%b%k%} "
  RPROMPT="%{%f%b%k%}$(_abbr_badges)%{%f%b%k%}"
}

# Add render hook
_abbr_setup () {
  prompt_opts=(cr percent sp subst)
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd _abbr_render
}

# Run the setup
_abbr_setup

# vim: syntax=zsh
