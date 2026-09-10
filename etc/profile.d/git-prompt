
build_prompt () {
  PS1="${VIRTUAL_ENV_PROMPT:-}"'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h '
  toplevel=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ "$toplevel"  = "" ]
  then
    w=$(pwd | sed "s:^$HOME:~:" | xargs basename)
    PS1+="\[\033[01;34m\]$w"
  else
    project=$(basename "$toplevel")
    w=$(pwd | sed "s:^$toplevel:$project:")
    PS1+="\[\e[34m\]$w"
    branch=$(git symbolic-ref --short -q HEAD 2> /dev/null ||
    git rev-parse -q --short HEAD 2> /dev/null)
    [[ $branch ]] &&  PS1+=" \[\e[95m\]($branch)"
  fi

  PS1+=' \[\033[01;32m\]\$\[\e[0m\] '
}
PROMPT_COMMAND=build_prompt
