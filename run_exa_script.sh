#!/bin/bash

show_hidden=false
path="."

# Check if the first argument is -a (for showing hidden files)
if [[ "$1" == "-a" ]]; then
  show_hidden=true
  shift  # Remove the -a option from the arguments
fi

if [ $# -gt 0 ]; then
  path="$1"
fi

function run_exa_command() {
  local exa_options="-lgh --group-directories-first --icons --octal-permissions"
  if $show_hidden; then
    exa_options="-a $exa_options"
  fi

  exa_command="exa $exa_options '$path'"

  $exa_command
}

run_exa_command
