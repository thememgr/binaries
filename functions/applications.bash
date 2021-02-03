#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : applications.bash
# @Created     : Wed, Aug 05, 2020, 02:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : functions for installed apps
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TMPPATH="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH:."

export PATH="$(echo $TMPPATH | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"

#trap '' err exit SIGINT SIGTERM
export WHOAMI="${USER}"
export SUDO_PROMPT="$(printf "\n\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m" && echo)"

TMP="${TMP:-/tmp}"
TEMP="${TEMP:-/tmp}"

APPNAME="${APPNAME:-applications}"

devnull() {
  "$@" >/dev/null 2>/dev/null
  return $?
}

# fail if git is not installed

if ! command -v "git" >/dev/null 2>&1; then
  echo -e "\n\n\t\t\033[0;31mGit is not installed\033[0m\n"
  exit 1
fi

##################################################################################################

case "$(uname -s)" in
Darwin) alias dircolors=gdircolors ;;
esac

##################################################################################################

# Set Main Repo for dotfiles
DOTFILESREPO="${DOTFILESREPO:-https://github.com/dfmgr}"

# Set other Repos
DFMGRREPO="${DFMGRREPO:-https://github.com/dfmgr}"
PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
DEVENVMGRREPO="${DEVENVMGR:-https://github.com/devenvmgr}"
ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
SYSTEMMGRREPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}"
WALLPAPERMGRREPO="${WALLPAPERMGRREPO:-https://github.com/wallpapermgr}"

##################################################################################################

NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
ORANGE="\033[0;33m"
LIGHTRED='\033[1;31m'
BG_GREEN="\[$(tput setab 2 2>/dev/null)\]"
BG_RED="\[$(tput setab 9 2>/dev/null)\]"
ICON_INFO="[ ℹ️ ]"
ICON_GOOD="[ ✔ ]"
ICON_WARN="[ ❗ ]"
ICON_ERROR="[ ✖ ]"
ICON_QUESTION="[ ❓ ]"

##################################################################################################

printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t$ICON_INFO $1\n" 3; }
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_error() { printf_color "\t\t$ICON_ERROR $1 $2\n" 1; }
printf_warning() { printf_color "\t\t$ICON_WARN $1\n" 3; }
printf_question() { printf_color "\t\t$ICON_QUESTION $1? " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_execute_error() { printf_color "\t\t$ICON_WARN $1 $2\n" 1; }
printf_execute_result() {
  if [ "$1" -eq 0 ]; then printf_execute_success "$2"; else printf_execute_error "$2"; fi
  return "$1"
}

printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }
printf_not_found() { if ! cmd_exists "$1"; then printf_exit "The $1 command is not installed"; fi; }

##################################################################################################

printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
  exit 1
}

##################################################################################################

printf_help() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  echo ""
  printf_color "\t\t$msg\n" "$color"
  echo ""
  exit 0
}

##################################################################################################

printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}

##################################################################################################

printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_custom "$color" "$line"
  done
  set +o pipefail
}

##################################################################################################

printf_newline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_color "\t\t$line\n" "$color"
  done
  set +o pipefail
}

##################################################################################################

printf_custom_question() {
  local custom_question
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
}

##################################################################################################

printf_read_question() {
  printf_question "$1 is not installed Would you like install it"
}

##################################################################################################

printf_head() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  local msg="$*"
  shift
  printf_color "
\t\t##################################################
\t\t$msg
\t\t##################################################\n" "$color"
}

##################################################################################################

printf_result() {
  [ ! -z "$1" ] && EXIT="$1" || EXIT="$?"
  [ ! -z "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ ! -z "$3" ] && local FAIL="$3" || local FAIL="The previous command has failed"
  if [ "$EXIT" -eq 0 ]; then
    printf_success "$OK"
    exit 0
  else
    printf_error "$FAIL"
    exit 1
  fi
}

##################################################################################################

get_githost() {
  echo "$@" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" | awk -F. '{print $(NF-1) "."  $NF}' | sed 's#\..*##g'
}

get_username_repo() {
  unset protocol separator hostname username userrepo
  local url="$1"
  local exp="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+).git$"
  local url="$(echo $exp | 's/\.[^.]*$//')"
  if [[ $url =~ $exp ]]; then
    protocol=${BASH_REMATCH[1]}
    separator=${BASH_REMATCH[2]}
    hostname=${BASH_REMATCH[3]}
    username=${BASH_REMATCH[4]}
    userrepo=${BASH_REMATCH[5]}
  fi
}

##################################################################################################

notifications() {
  local title="$1"
  shift 1
  local msg="$*"
  shift
  cmd_exists notify-send && notify-send -u normal -i "notification-message-IM" "$title" "$msg" || return 0
}
##################################################################################################
setupcrontab() {
  local croncmd="logr"
  local additional='bash -c "am_i_online && '$2' &"'
}
addtocrontab() {
  [ "$1" = "--help" ] && printf_help "addtocrontab "0 0 1 * *" "echo hello""
  local frequency="$1"
  local command="am_i_online && && sleep $(expr $RANDOM \% 300) && $2"
  local job="$frequency $command"
  cat <(grep -F -i -v "$command" <(crontab -l)) <(echo "$job") | devnull2 crontab -
}
removecrontab() {
  crontab -l | grep -v -F "$command" | devnull2 crontab -
}
cron_updater() {
  [ "$*" = "--help" ] && printf_help "Usage: $APPNAME updater $APPNAME"
  if [[ "$USER" = "root" ]]; then
    if [ -z "$1" ] && [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $SYSUPDATEDIR/); do
        file="$(ls -A $SYSUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(basename $file)"
          sudo file=$file bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$SYSUPDATEDIR" ] && ls "$SYSUPDATEDIR"/* 1>/dev/null 2>&1; then
        file="$(ls -A $SYSUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(basename $file)"
          sudo file=$file bash -c "$file --cron $*"
        fi
      fi
    fi
  else
    if [ -z "$1" ] && [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
      for upd in $(ls $USRUPDATEDIR/); do
        file="$(ls -A $USRUPDATEDIR/$upd 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(basename $file)"
          sudo file=$file bash -c "$file --cron $*"
        fi
      done
    else
      if [ -d "$USRUPDATEDIR" ] && ls "$USRUPDATEDIR"/* 1>/dev/null 2>&1; then
        file="$(ls -A $USRUPDATEDIR/$1 2>/dev/null)"
        if [ -f "$file" ]; then
          appname="$(basename $file)"
          sudo file=$file bash -c "$file --cron $*"
        fi
      fi
    fi
  fi
}

##################################################################################################

mkd() {
  for d in "$@"; do [ -e "$d" ] || mkdir -p "$d"; done
  return 0
}

##################################################################################################

cmd_exists() {
  local args="$*"
  for cmd in $args; do
    unalias "$cmd" 2>/dev/null >&1
    if command -v $cmd; then return 0; else return 1; fi
    exitCode+=$?
  done
  exit $exitCode
}

die() { echo -e "$1" exit ${2:9999}; }
devnull1() {
  "$@" 1>/dev/null
  return $?
}
devnull2() {
  "$@" 2>/dev/null
  return $?
}
killpid() {
  devnull kill -9 "$(pidof "$1")"
  return $?
}
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1; }
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
getuser() { [ -z "$1" ] && cut -d: -f1 /etc/passwd | grep "$USER" || cut -d: -f1 /etc/passwd | grep "$1"; }
log() {
  mkdir -p "$HOME/.local/log"
  "$@" >"$HOME/.local/log/$APPNAME.log" 2>"$HOME/.local/log/$APPNAME.err"
  return $?
}
system_service_exists() {
  if sudo systemctl list-units --full -all | grep -Fq "$1"; then return 0; else return 1; fi
  setexitstatus
  set --
}
system_service_enable() {
  if system_service_exists; then execute "sudo systemctl enable -f $1" "Enabling service: $1"; fi
  setexitstatus
  set --
}
system_service_disable() {
  if system_service_exists; then execute "sudo systemctl disable --now $1" "Disabling service: $1"; fi
  setexitstatus
  set --
}

do_not_add_a_url() {
  regex="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
  string="$1"
  if [[ "$string" =~ $regex ]]; then
    printf_exit "Do not provide the full url" "only provide the username/repo"
  fi
}

is_online() {
  return_code() {
    if [ "$1" = 0 ]; then
      return 0
    else
      return 1
    fi
  }
  test_ping() {
    timeout 0.3 ping -c1 8.8.8.8 &>/dev/null
    local pingExit=$?
    return_code $pingExit
  }
  test_http() {
    curl -LSIs --max-time 1 http://1.1.1.1 | grep "HTTP/2 200" | head -n 1 &>/dev/null
    local httpExit=$?
    return_code $httpExit
  }
  test_ping || test_http
}

run_post() {
  local e="$1"
  local m="${e//devnull//}"
  #local m="$(echo $1 | sed 's#devnull ##g')"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}

if [[ "$OSTYPE" =~ ^darwin ]]; then
  printclip() { cmd_exists pbpaste && LC_CTYPE=UTF-8 tr -d "\n" | pbpaste || return 1; }
  putclip() { cmd_exists pbcopy && LC_CTYPE=UTF-8 tr -d "\n" | pbcopy || return 1; }
elif [[ "$OSTYPE" =~ ^linux ]]; then
  printclip() { cmd_exists xclip && xclip -o -s; }
  putclip() { cmd_exists xclip && xclip -i -sel c || return 1; }
fi

##################################################################################################

get_app_info() {
  local APPNAME="$1"
  local FILE="$(command -v $APPNAME)"
  if [ -f "$FILE" ]; then
    echo ""
    cat "$FILE" | grep "# @" | grep "  :" >/dev/null 2>&1 &&
      cat "$FILE" | grep "# @" | grep "  :" | sed 's/# @//g' | printf_newline "3" &&
      printf_green "$(cat $FILE | grep "##@Version" | sed 's/##@//g')" ||
      printf_red "File was found, however, No information was provided"
    echo ""
  else
    printf_red "File was not found"
  fi
  exit 0
}

##################################################################################################

#transmission-remote-cli() { cmd_exists transmission-remote-cli || cmd_exists transmission-remote || transmission; }

##################################################################################################

backupapp() {
  local filename count backupdir rmpre4vbackup
  [ ! -z "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ ! -z "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local logdir="$HOME/.local/log/backupapp"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local/backups/apps/}"
  local count="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ -e "$myappdir" ] && [ ! -d $myappdir/.git ]; then
    echo -e "#################################" >>"$logdir/$myappname.log"
    echo -e "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "# Backing up $myappdir" >>"$logdir/$myappname.log"
    echo -e "#################################\n" >>"$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>&1
    echo -e "\n#################################" >>"$logdir/$myappname.log"
    echo -e "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "#################################\n\n" >>"$logdir/$myappname.log"
    rm -Rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}

##################################################################################################

runapp() {
  local logdir="${LOGDIR:-$HOME/.local/log}"
  mkdir -p "$logdir"
  if [ "$1" = "--bg" ]; then
    local logname="$2"
    shift 2
    echo "#################################" >>"$logdir/$logname.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/$logname.log"
    echo "#################################" >>"$logdir/$logname.err"
    "$@" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err" &
  elif [ "$1" = "--log" ]; then
    local logname="$2"
    shift 2
    echo "#################################" >>"$logdir/$logname.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/$logname.log"
    echo "#################################" >>"$logdir/$logname.err"
    "$@" >>"$logdir/$logname.log" 2>>"$logdir/$logname.err"
  else
    echo "#################################" >>"$logdir/${APPNAME:-$1}.log"
    echo "$(date +'%A, %B %d, %Y')" >>"$logdir/${APPNAME:-$1}.log"
    echo "#################################" >>"$logdir/${APPNAME:-$1}.err"
    "$@" >>"$logdir/${APPNAME:-$1}.log" 2>>"$logdir/${APPNAME:-$1}.err"
  fi
}

##################################################################################################

cmd_exists() {
  local package=$1
  devnull2 unalias "$package"
  if devnull command -v "$package"; then return 0; else return 1; fi
}
perl_exists() {
  local package=$1
  if devnull perl -M$package -le 'print $INC{"$package/Version.pm"}'; then return 0; else return 1; fi
}
python_exists() {
  local package=$1
  if devnull $PYTHONVER -c "import $package"; then return 0; else return 1; fi
}

##################################################################################################

cmd_missing() { cmd_exists "$1" || MISSING+="$1 "; }
perl_missing() { perl_exists $1 || MISSING+="perl-$1 "; }
python_missing() { python_exists "$1" || MISSING+="$PYTHONVER-$1 "; }

##################################################################################################

rm_rf() { if [ -e "$1" ]; then devnull rm -Rf "$@"; fi; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
ln_rm() { devnull find "$1" -xtype l -delete; }
ln_sf() {
  [ -L "$2" ] && rm_rf "$2"
  devnull ln -sf "$@"
}
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
mkd() { devnull mkdir -p "$@"; }
replace() { find "$1" -not -path "$1/.git/*" -type f -exec sed -i "s#$2#$3#g" {} \; >/dev/null 2>&1; }
rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
countwd() { cat "$@" | wc-l | rmcomments; }
urlcheck() { devnull curl --config /dev/null --connect-timeout 3 --retry 3 --retry-delay 1 --output /dev/null --silent --head --fail "$1"; }
urlinvalid() { if [ -z "$1" ]; then
  printf_red "Invalid URL\n"
  exit 1
else
  printf_red "Can't find $1\n"
  exit 1
fi; }
urlverify() { urlcheck $1 || urlinvalid $1; }
symlink() { ln_sf "$1" "$2"; }

##################################################################################################

attemp_install_menus() {
  local prog="$1"
  if (dialog --timeout 10 --trim --cr-wrap --colors --title "install $1" --yesno "$prog in not installed! \nshould I try to install it?" 15 40); then
    sleep 2
    clear
    printf_custom "191" "\n\n\n\n\t\tattempting install of $prog\n\t\tThis could take a bit...\n\n\n"
    devnull pkmgr silent "$1"
    [ "$?" -ne 0 ] && dialog --timeout 10 --trim --cr-wrap --colors --title "failed" --msgbox "$1 failed to install" 10 41
    clear
  fi
}

##################################################################################################

custom_menus() {
  printf_custom_question "6" "Enter your custom program : "
  read custom
  printf_custom_question "6" "Enter any additional options [type file to choose] : "
  read opts
  if [ "$opts" = "file" ]; then opts="$(open_file_menus $custom)"; fi
  $custom $opts >/dev/null 2>&1 || clear
  printf_red "$custom is an invalid program"
}

##################################################################################################

run_prog_menus() {
  local prog="$1"
  shift 1
  local args="$*"
  if cmd_exists $prog; then
    devnull2 "$prog" "$@" || clear printf_red "An error has occured"
  else
    attemp_install_menus $prog &&
      devnull2 $prog $args || return 1
  fi
}

##################################################################################################

open_file_menus() {
  local prog="$1"
  shift 1
  local args="$*"
  if cmd_exists $prog; then
    local file=$(dialog --title "Play a file" --stdout --title "Please choose a file or url to play" --fselect "$HOME/" 14 48)
    [ -z "$FILE" ] && devnull2 "$prog" "$file" || clear
    printf_red "No file selected"
  else
    attemp_install_menus $prog &&
      devnull2 $prog $args || return 1
  fi
}

##################################################################################################

__getpythonver() {
  if [[ "$(python3 -V 2>/dev/null)" =~ "Python 3" ]]; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif [[ "$(python2 -V 2>/dev/null)" =~ "Python 2" ]]; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if [ "$(cmd_exists yay)" ] || [ "$(cmd_exists pacman)" ]; then PYTHONVER="python" && PIP="pip3"; fi
}
__getpythonver

##################################################################################################

__getphpver() {
  if cmd_exists php; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo $PHPVER
}

##################################################################################################

setexitstatus() {
  [ -z "$EXIT" ] || local EXIT="$?"
  local EXITSTATUS+="$EXIT"
  if [ -z "$EXITSTATUS" ] || [ "$EXITSTATUS" -ne 0 ]; then
    BG_EXIT="${BG_RED}"
    return 1
  else
    BG_EXIT="${BG_GREEN}"
    return 0
  fi
}

##################################################################################################

returnexitcode() {
  [ -z "$1" ] || EXIT=$1
  if [ "$EXIT" -gt 5 ]; then
    BG_EXIT="${BG_RED}"
    PS_SYMBOL=" ⁉️ "
    return $EXIT
  elif [ "$EXIT" -eq 0 ]; then
    BG_EXIT="${BG_GREEN}"
    PS_SYMBOL=" 😺 "
    return 0
  else
    BG_EXIT="${BG_RED}"
    PS_SYMBOL=" 😟 "
    return $EXIT
  fi
}

##################################################################################################

getexitcode() {
  EXIT="$?"
  if [ ! -z "$1" ]; then
    local PSUCCES="$1"
  elif [ ! -z "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ ! -z "$2" ]; then
    local PERROR="$2"
  elif [ ! -z "$ERROR" ]; then
    local PERROR="$ERROR"
  else
    local PERROR="Last command failed to complete"
  fi
  if [ "$EXIT" -eq 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_red "$PERROR"
  fi
  returnexitcode $EXIT
}

##################################################################################################

getlipaddr() {
  if cmd_exists route || cmd_exists ip; then
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      NETDEV="$(route get default | grep interface | awk '{print $2}')"
    else
      NETDEV="$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}')"
    fi
    if __cmd_exists ifconfig; then
      CURRIP4="$(/sbin/ifconfig $NETDEV | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1)"
      CURRIP6="$(/sbin/ifconfig "$NETDEV" | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
    else
      CURRIP4="$(ip addr | grep inet | grep -vE "127|inet6" | tr '/' ' ' | awk '{print $2}' | head -n 1)"
      CURRIP6="$(ip addr | grep inet6 | grep -v "::1/" -v | tr '/' ' ' | awk '{print $2}' | head -n 1)"
    fi
  else
    NETDEV="lo"
    CURRIP4="127.0.0.1"
    CURRIP6="::1"
  fi
}

##################################################################################################

git_clone() {
  local repo="$1"
  [ ! -z "$2" ] && local myappdir="$2" || local myappdir="$APPDIR"
  [ ! -d "$myappdir" ] || rm_rf "$myappdir"
  devnull git clone --depth=1 -q --recursive "$@"
}

##################################################################################################

git_update() {
  cd "$APPDIR" || exit 1
  local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  devnull git reset --hard &&
    devnull git pull --recurse-submodules -fq &&
    devnull git submodule update --init --recursive -q &&
    devnull git reset --hard -q
  if [ "$?" -ne "0" ]; then
    cd "$HOME" || exit 1
    backupapp "$APPDIR" "$APPNAME" && devnull rm_rf "$APPDIR" && git_clone "$repo" "$APPDIR"
  fi
}

##################################################################################################

check_app() {
  local MISSING=""
  for cmd in "$@"; do cmd_exists $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$cmd is not installed Would you like install it" [y/N]
    read -n 1 -s choice && echo
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr silent-install $miss" "Installing $miss" || return 1
      done
    else
      exit 1
    fi
  fi
}

##################################################################################################

check_pip() {
  local MISSING=""
  for cmd in "$@"; do cmd_exists $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$1 is not installed Would you like install it" [y/N]
    read -n 1 -s choice
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr pip $miss" "Installing $miss"
      done
    fi
  else
    return 1
  fi
}

##################################################################################################

check_cpan() {
  local MISSING=""
  for cmd in "$@"; do cmd_exists $cmd || MISSING+="$cmd "; done
  if [ ! -z "$MISSING" ]; then
    printf_question "$1 is not installed Would you like install it" [y/N]
    read -n 1 -s choice
    if [[ $choice == "y" || $choice == "Y" ]]; then
      for miss in $MISSING; do
        execute "pkmgr cpan $miss" "Installing $miss"
      done
    fi
  else
    return 1
  fi

}

##################################################################################################

git_clone() {
  local repo="$1"
  rm_rf "$2"
  devnull git clone --depth=1 -q --recursive "$@"
}

##################################################################################################

git_update() {
  local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
  devnull git reset --hard &&
    devnull git pull --recurse-submodules -fq &&
    devnull git submodule update --init --recursive -q &&
    devnull git reset --hard -q
  if [ "$?" -ne "0" ]; then
    cd "$HOME" || exit 1
    backupapp && devnull git_clone "$repo" $APPDIR
  fi
}

##################################################################################################
user_is_root() { if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then return 0; else return 1; fi; }

can_i_sudo() {
  (
    ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" >/dev/null)
    sudo -vn && sudo -ln
  ) 2>&1 | grep -v 'may not' >/dev/null
}

##################################################################################################

sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    sudo true &>/dev/null
    while true; do
      echo "$$" >"$HOME/.sudo"
      sudo -n true
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null 2>/dev/null &
  fi
}

##################################################################################################

sudoexit() {
  if can_i_sudo; then
    sudoask || printf_green "Getting privileges successfull continuing"
  else
    printf_red "Failed to get privileges\n"
  fi
}

##################################################################################################

requiresudo() {
  if can_i_sudo; then
    sudoask && sudoexit && sudo "$@" 2>/dev/null
  else
    printf_red "You dont have access to sudo\n\t\tPlease contact the syadmin for access"
    return 1
  fi
}

##################################################################################################

kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i"
    wait "$i" &>/dev/null
  done
}

##################################################################################################

execute() {
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
  local exitCode=0
  local cmdsPID=""
  set_trap "EXIT" "kill_all_subprocesses"
  eval "$CMDS" &>/dev/null 2>"$TMP_FILE" &
  cmdsPID=$!
  show_spinner "$cmdsPID" "$CMDS" "$MSG"
  wait "$cmdsPID" &>/dev/null
  exitCode=$?
  printf_execute_result $exitCode "$MSG"
  if [ $exitCode -ne 0 ]; then
    printf_execute_error_stream <"$TMP_FILE"
  fi
  rm -rf "$TMP_FILE"
  return $exitCode
}

##################################################################################################

show_spinner() {
  local -r FRAMES='/-\|'
  local -r NUMBER_OR_FRAMES=${#FRAMES}
  local -r CMDS="$2"
  local -r MSG="$3"
  local -r PID="$1"
  local i=0
  local frameText=""
  while kill -0 "$PID" &>/dev/null; do
    frameText="                [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
    printf "%s" "$frameText"
    sleep 0.2
    printf "\r"
  done
}

###################### setup folders - user ######################
user_installdirs() {
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    INSTALL_TYPE=user
    HOME="/usr/local/home/root"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    FONTDIR="$SHARE/fonts"
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  else
    INSTALL_TYPE=user
    HOME="${HOME}"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.config"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    FONTDIR="$SHARE/fonts"
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  export installtype="user_installdirs"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw}"
  DOWNLOADED_TO="${DOWNLOADED_TO:-$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME}"
}

###################### setup folders - system ######################
system_installdirs() {
  APPNAME="${APPNAME:-installer}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    BACKUPDIR="$HOME/.local/backups"
    BIN="/usr/local/bin"
    CONF="/usr/local/etc"
    SHARE="/usr/local/share"
    LOGDIR="/usr/local/log"
    STARTUP="/dev/null"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    COMPDIR="/etc/bash_completion.d"
    THEMEDIR="/usr/local/share/themes"
    ICONDIR="/usr/local/share/icons"
    FONTDIR="/usr/local/share/fonts"
    FONTCONF="/usr/local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
    WALLPAPERS="/usr/local/share/wallpapers"
    USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  else
    INSTALL_TYPE=system
    HOME="${HOME:-/home/$WHOAMI}"
    BACKUPDIR="${BACKUPS:-$HOME/.local/backups}"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.local/etc"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$HOME/.local/share/themes"
    ICONDIR="$HOME/.local/share/icons"
    FONTDIR="$HOME/.local/share/fonts"
    FONTCONF="$HOME/.local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="$HOME/.local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="$HOME/.local/share/CasjaysDev/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  export installtype="system_installdirs"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw}"
  DOWNLOADED_TO="${DOWNLOADED_TO:-$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME}"
}

user_installdirs
###################### dfmgr settings ######################
dfmgr_install() {
  export user_installdirs
  export SCRIPTS_PREFIX="dfmgr"
  export REPO="$DFMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$CONF"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/dfmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/dfmgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="dfmgr_install"
}

###################### devenv settings ######################
devenvmgr_install() {
  export user_installdirs
  export SCRIPTS_PREFIX="devenv"
  export REPO="$DEVENVMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$CONF"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/devenv"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/devenv"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="devenvmgr_install"
}
###################### dockermgr settings ######################
dockermgr_install() {
  export user_installdirs
  export SCRIPTS_PREFIX="dockermgr"
  export REPO="$DFMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$CONF"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/dockermgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/dockermgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="dockermgr_install"
}

###################### fontmgr settings ######################
fontmgr_install() {
  export system_installdirs
  export SCRIPTS_PREFIX="fontmgr"
  export REPO="$FONTMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SHARE/CasjaysDev/fontmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/fontmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/fontmgr"
  export FONTDIR="${FONTDIR:-$SHARE/fonts}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export FONTDIR="${FONTDIR:-$SHARE/fonts}"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  mkd "$FONTDIR" "$HOMEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="fontmgr_install"
}

###################### iconmgr settings ######################
iconmgr_install() {
  export system_installdirs
  export SCRIPTS_PREFIX="iconmgr"
  export REPO="$ICONMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/iconmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/iconmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/iconmgr"
  export ICONDIR="${ICONDIR:-$SHARE/icons}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ICONDIR="${ICONDIR:-$SHARE/icons}"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  mkd "$ICONDIR" "$HOMEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="iconmgr_install"
}

###################### pkmgr settings ######################
pkmgr_install() {
  export system_installdirs
  export SCRIPTS_PREFIX="pkmgr"
  export REPO="$PKMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/pkmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/pkmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/pkmgr"
  export REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/master"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="pkmgr_install"
}

###################### systemmgr settings ######################
systemmgr_install() {
  requiresudo "true"
  system_installdirs
  export SCRIPTS_PREFIX="systemmgr"
  export REPO="$SYSTEMMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export CONF="/usr/local/etc"
  export SHARE="/usr/local/share"
  export HOMEDIR="/usr/local/etc"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/systemmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/systemmgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="systemmgr_install"
}

###################### thememgr settings ######################
thememgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="thememgr"
  export REPO="$THEMEMGRREPO"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/thememgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/thememgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/thememgr"
  export THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="thememgr_install"
}

###################### wallpapermgr settings ######################
wallpapermgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="wallpapermgr"
  export REPO="${WALLPAPERMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/wallpapers"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/wallpapermgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/wallpapermgr"
  export WALLPAPERS="${WALLPAPERS:-$SHARE/wallpapers}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export ARRAY="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/array)"
  export LIST="$(cat /usr/local/share/CasjaysDev/scripts/helpers/$SCRIPTS_PREFIX/list)"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    export APPVERSION="$(cat $CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    export APPVERSION="N/A"
  fi
  mkd "$WALLPAPERS"
  mkd "$USRUPDATEDIR"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="wallpapermgr_install"
}

###################### create directories ######################
ensure_dirs() {
  if [[ $EUID -ne 0 ]] || [[ "$WHOAMI" != "root" ]]; then
    __mkd "$BIN"
    __mkd "$SHARE"
    __mkd "$LOGDIR"
    __mkd "$LOGDIR/dfmgr"
    __mkd "$LOGDIR/fontmg"
    __mkd "$LOGDIR/iconmgr"
    __mkd "$LOGDIR/systemmgr"
    __mkd "$LOGDIR/thememgr"
    __mkd "$LOGDIR/wallpapermgr"
    __mkd "$COMPDIR"
    __mkd "$STARTUP"
    __mkd "$BACKUPDIR"
    __mkd "$FONTDIR"
    __mkd "$ICONDIR"
    __mkd "$THEMEDIR"
    __mkd "$FONTCONF"
    __mkd "$CASJAYSDEVSHARE"
    __mkd "$CASJAYSDEVSAPPDIR"
    __mkd "$USRUPDATEDIR"
    __mkd "$SHARE/applications"
    __mkd "$SHARE/CasjaysDev/functions"
    __mkd "$SHARE/wallpapers/system"
    user_is_root && __mkd "$SYSUPDATEDIR"
  fi
  return 0
}

path_info() { echo "$PATH" | tr ':' '\n' | sort -u; }
###################### debug settings ######################
__debug() {
  $installtype
  printf_info "UserHomeDir:               $HOME"
  printf_info "UserBinDir:                $BIN"
  printf_info "UserConfDir:               $CONF"
  printf_info "UserShareDir:              $SHARE"
  printf_info "UserLogDir:                $LOGDIR"
  printf_info "UserStartDir:              $STARTUP"
  printf_info "SysConfDir:                $SYSCONF"
  printf_info "SysBinDir:                 $SYSBIN"
  printf_info "SysConfDir:                $SYSCONF"
  printf_info "SysShareDir:               $SYSSHARE"
  printf_info "SysLogDir:                 $SYSLOGDIR"
  printf_info "SysBackUpDir:              $BACKUPDIR"
  printf_info "ApplicationsDir:           $SHARE/applications"
  printf_info "IconDir:                   $ICONDIR"
  printf_info "ThemeDir                   $THEMEDIR"
  printf_info "FontDir:                   $FONTDIR"
  printf_info "FontConfDir:               $FONTCONF"
  printf_info "CompletionsDir:            $COMPDIR"
  printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
  printf_info "CASJAYSDEVSAPPDIR:         $CASJAYSDEVSAPPDIR"
  printf_info "USRUPDATEDIR:              $USRUPDATEDIR"
  printf_info "SYSUPDATEDIR:              $SYSUPDATEDIR"
  printf_info "DOTFILESREPO:              $DOTFILESREPO"
  printf_info "DevEnv Repo:               $DEVENVMGRREPO"
  printf_info "Package Manager Repo:      $PKMGRREPO"
  printf_info "Icon Manager Repo:         $ICONMGRREPO"
  printf_info "Font Manager Repo:         $FONTMGRREPO"
  printf_info "Theme Manager Repo         $THEMEMGRREPO"
  printf_info "System Manager Repo:       $SYSTEMMGRREPO"
  printf_info "Wallpaper Manager Repo:    $WALLPAPERMGRREPO"
  printf_info "InstallType:               $installtype"
  printf_info "Prefix:                    $SCRIPTS_PREFIX"
  printf_info "SystemD dir:               $SYSTEMDDIR"
  exit $?
}

##################################################################################################

os_support() {
  if [ -n "$1" ]; then
    OSTYPE="$(echo $1 | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" ;;
  mac* | darwin*) echo "MacOS" ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" ;;
  bsd*) echo "BSD" ;;
  solaris*) echo "Solaris" ;;
  *) echo "Unknown OS" ;;
  esac
}

supported_oses() {
  if [[ $# -eq 0 ]]; then return 1; fi
  for OSes in "$@"; do
    UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
    case "$1" in
    linux)
      if [[ "$UNAME" =~ ^linux ]]; then
        return 0
      else
        return 1
      fi
      ;;

    mac*)
      if [[ "$UNAME" =~ ^darwin ]]; then
        return 0
      else
        return 1
      fi
      ;;
    win*)
      if [[ "$UNAME" =~ ^ming ]]; then
        return 0
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
    esac
  done
}

unsupported_oses() {
  for OSes in "$@"; do
    if [[ "$(echo $1 | tr '[:upper:]' '[:lower:]')" =~ $(os_support) ]]; then
      printf_red "\t\t$(os_support $OSes) is not supported\n"
      exit
    fi
  done
}

if_os_id() {
  unset distroname distroversion distro_id distro_version
  if [ -f "$(command -v lsb_release 2>/dev/null)" ]; then
    local distroname="$(lsb_release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    local distroversion="$(lsb_release -a 2>/dev/null | grep 'Release' | awk '{print $2}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
  elif [ -f "$(command -v lsb-release 2>/dev/null)" ]; then
    local distroname="$(lsb-release -a 2>/dev/null | grep 'Distributor ID' | awk '{print $3}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
    local distroversion="$(lsb-release -a 2>/dev/null | grep 'Release' | awk '{print $2}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')"
  elif [ -f "/etc/os-release" ]; then
    local distroname=$(grep ID_LIKE= /etc/os-release | sed 's#ID_LIKE=##' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
    local distroversion=$(grep ID_LIKE= /etc/os-release | sed 's#VERSION_ID=##' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
  elif [ -f "/etc/redhat-release" ]; then
    local distroname=$(cat /etc/redhat-release | awk '{print $1}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
    local distroversion=$(cat /etc/redhat-release | awk '{print $4}' | tr '[:upper:]' '[:lower:]' | sed 's#"##g')
  else
    return 1
  fi
  for id_like in "$@"; do
    case "$1" in
    arch* | arco*)
      if [[ $distroname =~ ^arco ]] || [[ "$distroname" =~ ^arch ]]; then
        distro_id=Arch
        distro_version="$distroversion"
        return 0
      else
        return 1
      fi
      ;;
    RHEL* | rhel* | Fedora | fedora | CentOS | centos)
      if [[ "$distroname" =~ "scientific" ]] || [[ "$distroname" =~ "redhat" ]] || [[ "$distroname" =~ "centos" ]] ||
        [[ "$distroname" =~ "casjay" ]] || [[ "$distroname" =~ "fedora" ]]; then
        distro_id=RHEL
        distro_version="$distroversion"
      else
        return 1
      fi
      ;;
    Debian* | debian* | Ubuntu* | ubuntu* | Mint* | mint*)
      if [[ "$distroname" =~ "kali" ]] || [[ "$distroname" =~ "parrot" ]] || [[ "$distroname" =~ "debian" ]] || [[ "$distroname" =~ "raspbian" ]] ||
        [[ "$distroname" =~ "ubuntu" ]] || [[ "$distroname" =~ "mint" ]] || [[ "$distroname" =~ "elementary" ]] || [[ "$distroname" =~ "kde" ]]; then
        distro_id=Debian
        distro_version="$distroversion"
      else
        return 1
      fi
      ;;
    esac
  done
}

###################### help ######################

__help() {
  #----------------
  printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
  printf_help() {
    test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
    local msg="$*"
    shift
    printf_color "\t\t$msg\n" "$color"
  }
  #----------------
  printf "\n"
  if [ -f "$SCRIPTSFUNCTDIR/helpers/man/$APPNAME" ] && [ -s "$SCRIPTSFUNCTDIR/helpers/man/$APPNAME" ]; then
    source "$SCRIPTSFUNCTDIR/helpers/man/$APPNAME"
  else
    printf_help "1" "There is no man page for this app in: "
    printf_help "1" "$SCRIPTSFUNCTDIR/helpers/man/$APPNAME"
  fi
  printf "\n"
  exit 0
}

__options() {
  [ "$1" = "--vdebug" ] && shift 1 && __vdebug "$@"
  [ "$1" = "--debug" ] && __debug
  [ "$1" = "--help" ] && __help
  [ "$1" = "--version" ] && get_app_info "$APPNAME"
}

##################################################################################################

run_install_init() {
  if urlcheck "$REPO/$1/raw/master/install.sh"; then
    printf_yellow "Initializing the installer from"
    printf_purple "$REPO/$1"
    bash -c "$(curl -LSs $REPO/$1/raw/master/install.sh)"
    getexitcode "$1 has been installed"
  else
    urlinvalid "$REPO/$1/raw/master/install.sh"
  fi
  echo ""
}

run_install_list() {
  if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)" ]; then
    file="$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)"
    if [ -f "$file" ]; then
      printf_green "Information about $1:"
      printf_green "$(bash -c "$file --version")"
    else
      printf_exit "File was not found is it installed?"
      exit
    fi
  else
    declare -a LSINST="$(ls "$USRUPDATEDIR/" 2>/dev/null)"
    if [ -z "$LSINST" ]; then
      printf_red "No dotfiles are installed"
      exit
    else
      for df in ${LSINST[*]}; do
        printf_green "$df"
      done
    fi
  fi
}

run_install_version() {
  if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A $USRUPDATEDIR/$1 2>/dev/null)" ]; then
    file="$(ls -A $USRUPDATEDIR/$1 2>/dev/null)"
    if [ -f "$file" ]; then
      printf_green "Information about $1: \n$(bash -c "$file --version")"
    fi
  elif [ -f "$(command -v $1 2>/dev/null)" ]; then
    printf_green "$(bash -c "$1 --version 2>/dev/null")"
  else
    printf_exit "File was not found is it installed?"
  fi
  printf_green "scripts version is $(cat ${SCRIPTSFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}/version.txt)\n"
  exit
}

##################################################################################################
__vdebug() {
  if [ -f ./applications.debug ]; then . ./applications.debug; fi
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  printf_custom "4" "APP:$APPNAME - ARGS:$*"
  printf_custom "4" "FUNCTIONSDir:$DIR"
  for path in USER:$USER HOME:$HOME PREFIX:$SCRIPTS_PREFIX REPO:$REPO REPORAW:$REPORAW CONF:$CONF SHARE:$SHARE \
    HOMEDIR:$HOMEDIR APPDIR:$APPDIR USRUPDATEDIR:$USRUPDATEDIR SYSUPDATEDIR:$SYSUPDATEDIR; do
    printf_custom "4" $path
  done
}
##################################################################################################

# end
