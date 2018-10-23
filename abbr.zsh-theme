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

ABBR_FG_RETVAL_GOOD="white"
ABBR_BG_RETVAL_GOOD="green"
ABBR_FG_RETVAL_BAD="yellow"
ABBR_BG_RETVAL_BAD="black"

ABBR_FG_LOGON="black"
ABBR_BG_LOGON="cyan"

ABBR_FG_PWD="white"
ABBR_BG_PWD="none"

ABBR_FG_PROMPT_ROOT="red"
ABBR_BG_PROMPT_ROOT="none"
ABBR_FG_PROMPT_DEFAULT="$ABBR_BG_LOGON"
ABBR_BG_PROMPT_DEFAULT="none"


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
#    Rendering

# assemble prompt components
_abbr_prompt () {
  _abbr_section_retval
  _abbr_section_logon
  _abbr_section_pwd
  _abbr_section_prompt
}

# Render the prompt
_abbr_render () {
  PROMPT="%{%f%b%k%}$(_abbr_prompt)%{%f%b%k%} "
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
