autoload -U modify-current-argument
autoload -U split-shell-arguments

function _split_shell_arguments_under()
{
 local -a reply
 integer REPLY2
 split-shell-arguments
 #have to duplicate some of modify-current-argument to get the word
 #_under_ the cursor, not after.
 setopt localoptions noksharrays multibyte
 if (( REPLY > 1 )); then
   if (( REPLY & 1 )); then
     (( REPLY-- ))
   fi
 fi
 REPLY=${reply[$REPLY]}
}


function replace_multiple_dots() {
  local dots=$LBUFFER[-2,-1]
  #local -a reply

  if [[ $dots =~ "^[ //']?\.$" ]]; then
    _split_shell_arguments_under
    #echo "\n**$REPLY**\n"
    #echo "\n$(realpath $REPLY.)\n"
    zle -M "$(realpath ${(Q)${~REPLY}}. 2> /dev/null | head -n1 || echo 1>&2 "No such path")"
    #REALPATH=( ${(Q)${~REPLY}}(N:A) )
    # zle -M "${REALPATH:-Path not found: $REPLY}"
    LBUFFER=$LBUFFER'./'
  fi
  zle self-insert
}

zle -N replace_multiple_dots
bindkey "." replace_multiple_dots


