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
#  Author: ... Phil's Lab <http://phils-lab.io>                                 
#  


##################
#    Sections

_abbr_section_retval () {
  local ret="$(print -nP '%?')"

  if [ "$ret" -eq "0" ]; then
    print -n "%{%F{white}%K{green}%} \u2713 "
  else
    print -n "%{%F{white}%K{red}%} $ret "
  fi

  print -n "%{%f%}"
}

_abbr_section_logon () {
  print -n "%{%F{white}%} %m/%n %{%f%k%}"
}

_abbr_section_pwd () {
  local p="$(print -nP '%/')"

  print -n "%{%F{black}%K{cyan}%} "
  
  [[ $p == $HOME/* || $p == $HOME ]] && p=${p#${HOME}} && print -n '~'

  for d in ${(s:/:)p}; do
    [[ "${d:0:1}" == "." ]] && print -n "/${d:0:2}" || print -n "/${d:0:1}"
  done

  [[ "${d:0:1}" == "." ]] && print -n "${d:2}" || print -n "${d:1}"

  print -n " %{%f%k%}"
}

_abbr_section_prompt () {
  if [[ $UID = 0 ]]; then
    print -n "%{%F{white}%K{black}%} # "
  else
    print -n "%{%F{black}%K{cyan}%} $ "
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
