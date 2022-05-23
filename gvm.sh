__gvm_install() {
  local FILE=go$1.linux-amd64.tar.gz
  PATH_DIR_INST=$GVM_VERS_DIR/$1
  PATH_ARCH=$GVM_DIR/$FILE
  if [[ ! -f "$PATH_ARCH" ]];then
    URL=$GO_DOWNLOAD_URL$FILE
    curl -L --output $PATH_ARCH $URL
  fi
  mkdir -p $PATH_DIR_INST
  tar -C $PATH_DIR_INST -xvf $PATH_ARCH
  mkdir -p $PATH_DIR_INST/$GVM_VENDORS_DIR_NAME
  rm $PATH_ARCH
  echo "Successfully installed Go version $1"
}

__gvm_install_files() {
  mkdir -p $GVM_DIR/versions
  touch $GVM_DIR/$GVM_RC_FILE
}

__gvm_get_dir_version() {
  head -n1 $1/$GVM_RC_FILE
}

__gvm_get_root_version() {
  __gvm_get_dir_version $GVM_DIR
}

__gvm_use() {
  if [[ -z "$1" ]]; then
    export GO_VER="$(__gvm_get_dir_version $PWD)"
  elif [[ "$1" == "$(__gvm_get_current_version)" ]]; then
    echo "Go version is already $1"
    return 1
  else
    export GO_VER=$1
  fi
  __gvm_reload_shell
  go version && echo "Applied Go version $1" || echo "Not applied Go version $1"
}

__gvm_default() {
  __gvm_use $1
  echo "$1" > $GVM_DIR/$GVM_RC_FILE
  echo "Set default version to $1"
}

__gvm_reload_shell() {
  source ~/.$(__gvm_get_shell_name)rc
}

__gvm_ls() {
  ls -1 $GVM_VERS_DIR
}

__gvm_ls_remote() {
 curl -s $GO_DOWNLOAD_URL| grep "class=\"download\"" | grep linux-amd64 | awk 'match($0, /go[1-9]\.[0-9a-z]+\.?[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'|less
}

__gvm_rm() {
  local VERS="$1"
  if [[ "$VERS" = "$(__gvm_get_current_version)" ]]; then
    echo "You deleted current version, now you should switch to another version"
  fi
  rm -rf $GVM_VERS_DIR/$VERS/ 2>/dev/null || echo "Golang version not found"
  echo "Successfully removed Golang version $VERS"
}

__gvm_has_cmd() {
  type "${1-}" >/dev/null 2>&1
}

__gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

__gvm_get_current_version() {
  if [[ $(__gvm_has_cmd "go") ]]; then
    go version | awk '{print substr($3,3)}'
  fi
}

__gvm_info() {
  echo "--- Env vars ---"
  env | grep --color=never 'GO\|GVM'
  echo "--- Version info ---"
  go version 2>/dev/null || echo "Golang is not installed"
}

gvm-application() {
  local all_commands="no-preserve-uninstall"
  if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "GVM application help:"
  echo " - no-preserve-uninstall - uninstall gvm application"
  return 0
 elif [[ $all_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
  sudo rm -rf $GVM_DIR 2>/dev/null || echo "Can't remove $GVM_DIR, probably it's already deleted"
  local SHELL_RC_FILE=~/.$(__gvm_get_shell_name)rc
  local begin_line=$(grep -n "#-begin-GVM-block-" $SHELL_RC_FILE| awk -F ':' '{print $1}'| head -n1)
  local end_line=$(grep -n "#-end-GVM-block-" $SHELL_RC_FILE| awk -F ':' '{print $1}'| head -n1)
  if [[ -z "$begin_line" ]] || [[ -z "$end_line" ]]; then
    echo "Not found block in shell rc file"
    return 0
  fi
  sed "${begin_line},${end_line}d" $SHELL_RC_FILE > ${SHELL_RC_FILE}_new; mv ${SHELL_RC_FILE}_new ${SHELL_RC_FILE}
  __gvm_reload_shell
  echo "Application gvm successfully uninstalled"
 else
  echo "Command not found"
 fi
}

gvm() {
 local all_commands="use ls ls-remote rm info install default"
 local commands_with_versions="default rm install"

 if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  __gvm_help_title
  echo "Golang version manager"
  echo "\nOptions:"
  echo "  -h, --help\t\t\tShow this message and exit"
  echo "\nUsage Examples:"
  echo "   Install Golang version 1.17.10"
  echo "   $ gvm install 1.17.10"
  echo "\n   Set and use Golang version 1.17.10 as default"
  echo "   $ gvm default 1.17.10"
  echo "\n   Use Golang version 1.18.2 (works only for current terminal session)"
  echo "   $ gvm use 1.18.2"
  echo "\n   Show installed Golang versions available for switching"
  echo "   $ gvm ls"
  echo "\n   Show all versions that can be installed from go.dev repo"
  echo "   $ gvm ls-remote"
  echo "\n   Remove installed version"
  echo "   $ gvm rm 1.18.2"
  echo "\nCommands:"
  echo "  use <version>\t\tuse the version"
  echo "  default <version>\t\tset default the version"
  echo "  info\t\t\t\tshow info about current version"
  echo "  ls\t\t\t\tlist available installed versions that you can switch through the command use"
  echo "  ls-remote\t\t\tlist available versions for installation"
  echo "  install <version>\t\tinstall go version"
  echo "  rm <version>\t\tremove installed go version"
  return 0
 elif [[ $commands_with_versions =~ (^|[[:space:]])$1($|[[:space:]]) ]] && [[ -z "$2" ]]; then
  echo "You should select Golang"
  return 1
 elif [[ $all_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
  sub_cmd=$(echo "$1" | sed -r 's/[-]+/_/g')
  __gvm_$sub_cmd $2
 else
  __gvm_no_such_command $1
 fi
}

__gvm_help_title() {
  echo "Usage: gvm [OPTIONS] COMMAND [ARGS]..."
}

__gvm_no_such_command() {
  __gvm_help_title
  echo "Try 'gvm -h' for help"
  echo "\nError: No such command '$1'"
}

# export GVM_DIR=~/.gvm
export GVM_RC_FILE=.gvmrc
export GO_VER=${GO_VER:-$(__gvm_get_root_version)}
export GVM_VERS_DIR=$GVM_DIR/versions
export GVM_VENDORS_DIR_NAME=vendors
if ! [[ -z "$GO_VER" ]]; then
  export GOROOT=$GVM_VERS_DIR/$GO_VER/go
  export GOPATH=$GVM_VERS_DIR/$GO_VER/$GVM_VENDORS_DIR_NAME
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi
export GO_DOWNLOAD_URL=https://go.dev/dl/