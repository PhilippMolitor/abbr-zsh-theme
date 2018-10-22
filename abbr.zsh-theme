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
  local retval="$(print -nP '%?')"
  
  if [ "$retval" -eq "0" ]; then
    echo -n "%F{white}%K{green} \u2713 "
  else
    echo -n "%F{white}%K{red} $(printf "%03d" "$retval") "
  fi

  echo -n "%f"
}

_abbr_section_logon () {
  echo -n "%F{white} %m/%n %f%k"
}

_abbr_section_pwd () {
  local p="$(print -nP '%/')"

  echo -n "%F{black}%K{cyan} $(
    [[ $p == $HOME/* || $p == $HOME ]] && p="${p#${HOME}}" && echo -n '~'
  
    for d in ${(s:/:)p}; do
      [[ "${d:0:1}" == "." ]] && echo -n "/${d:0:2}" || echo -n "/${d:0:1}"
    done

    [[ "${d:0:1}" == "." ]] && echo -n "${d:2}" || echo -n "${d:1}"
  ) %f%k"
}

_abbr_section_prompt () {
  if [[ $UID = 0 ]]; then
    echo "%F{white}%K{black} # "
  else
    echo "%F{black}%K{cyan} $ "
  fi
}


##################
#     Prompt

_abbr_prompt () {
  echo -n "$(_abbr_section_retval)"
  echo -n "$(_abbr_section_logon)"
  echo -n "$(_abbr_section_pwd)"
  echo -n "$(_abbr_section_prompt)"
}


##################
#    ZSH vars

PROMPT="%f%b%k$(_abbr_prompt)%f%b%k"
RPROMPT=''

# vim: syntax=zsh
