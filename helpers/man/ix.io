#!/usr/bin/env bash
#----------------
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  printf_color "\t\t$msg\n" "$color"
}
#----------------
printf_help "4" "Usage: command | ix.io or ix.io filename"
