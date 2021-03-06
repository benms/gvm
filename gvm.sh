#!/usr/bin/env bash
# Linter: https://www.shellcheck.net/

__gvm_init_vars() {
  __gvm_init_machine
  __gvm_init_os
  # export GVM_DIR=~/.gvm
  export GO_VER
  export GVM_RC_FILE=.gvmrc
  GO_VER=${GO_VER:-$(__gvm_get_root_version)}
  export GVM_VERS_DIR=$GVM_DIR/versions
  export GVM_VENDORS_DIR_NAME=vendors
  if [[ -n "$GO_VER" ]]; then
    export GOROOT="$GVM_VERS_DIR/$GO_VER/go"
    export GOPATH"=$GVM_VERS_DIR/$GO_VER/$GVM_VENDORS_DIR_NAME"
    export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
  fi
  export GO_DOWNLOAD_URL=https://go.dev/dl/
}

__gvm_init_machine() {
  export GVM_MCN
  GVM_MCN=$(uname -m)
  export GVM_MCN_ARCH
  GVM_MCN_ARCH="$GVM_MCN"
  if [[ "$GVM_MCN" == "x86_64" ]]; then
    GVM_MCN_ARCH="amd64"
  fi
}

__gvm_init_os() {
  export GVM_OS
  GVM_OS=$(uname)
  GVM_OS=$(echo "$GVM_OS" | awk '{print tolower($0)}')
}

__gvm_install() {
  local FILE=go${1}.${GVM_OS}-${GVM_MCN_ARCH}.tar.gz
  local PATH_DIR_INST=$GVM_VERS_DIR/$1
  local PATH_ARCH=$GVM_DIR/$FILE
  if [[ -d "$PATH_DIR_INST" ]]; then
    echo "Go verion $1 is already exists"
    return 1
  fi
  local URL=$GO_DOWNLOAD_URL$FILE
  local STATUS_CODE
  STATUS_CODE=$(curl -LIs "$URL" | tee | grep -i http/2 | awk '{print $2}'| tail -n1)
  if [[ "$STATUS_CODE" -eq 404 ]]; then
    echo "Go version $1 not found in repo"
    return 1
  elif [[ "$STATUS_CODE" -ge 400 ]]; then
    echo "Repo connection error"
    return 1
  fi
  echo "Downloading archive:"
  curl -L --output "$PATH_ARCH" "$URL"
  mkdir -p "$PATH_DIR_INST"
  echo "Extracting archive:"
  tar -C "$PATH_DIR_INST" -xvf "$PATH_ARCH"
  mkdir -p "$PATH_DIR_INST/$GVM_VENDORS_DIR_NAME"
  if [[ "$GVM_OS" == "linux" ]]; then
    printf "\n\nSHA 256 sum of archive:\n"
    sha256sum "$PATH_ARCH"
  fi
  rm "$PATH_ARCH"
  printf "\nSuccessfully installed Go version %s\n" "$1"
}

__gvm_install_files() {
  mkdir -p "$GVM_DIR/versions"
  touch "$GVM_DIR/$GVM_RC_FILE"
}

__gvm_get_dir_version() {
  head -n1 "$1/$GVM_RC_FILE"
}

__gvm_get_root_version() {
  __gvm_get_dir_version "$GVM_DIR"
}

__gvm_use() {
  if [[ -z "$1" ]]; then
    export GO_VER
    GO_VER="$(__gvm_get_dir_version "$PWD")"
  elif [[ "$1" == "$(__gvm_get_current_version)" ]]; then
    echo "Go version is already $1"
    return 1
  elif [[ ! -d "$GVM_VERS_DIR/$1" ]]; then
    echo "Can't use Go version $1 because it's not found in installed list"
    return 1
  else
    export GO_VER="$1"
  fi
  __gvm_reload_shell || echo "Can't reload shell"
  go version && echo "Applied Go version $1" || echo "Not applied Go version $1"
}

__gvm_default() {
  __gvm_use "$1"
  echo "$1" >"$GVM_DIR/$GVM_RC_FILE"
  echo "Set default version to $1"
}

__gvm_reload_shell() {
  local RC_FILE
  RC_FILE="$HOME/.$(__gvm_get_shell_name)rc"
  # shellcheck source=/dev/null
  [ -f "$RC_FILE" ] && source "$RC_FILE"
}

__gvm_ls() {
  echo "GVM Installed versions:"
  find "${GVM_VERS_DIR}" -maxdepth 1 -mindepth 1 -type d -execdir basename '{}' ';' | awk '{printf "\t"$0"\n"}' |sort -Vr
}

__gvm_ls_remote() {
  echo "Loading available for installing versions..."
  curl -s "$GO_DOWNLOAD_URL" | grep "class=\"download\"" | grep linux-amd64 | awk 'match($0, /go[1-9]\.[0-9a-z]+\.?[0-9]+/) { print substr( $0, RSTART, RLENGTH )}' | sort -Vr | awk '{printf "\t"substr($0,3)"\n"}' | less -X
}

__gvm_rm() {
  local VERS="${1:?}"
  if [[ "$VERS" = "$(__gvm_get_current_version)" ]]; then
    echo "You deleted current version, now you should switch to another version"
  fi
  local RM_DIR
  RM_DIR="$GVM_VERS_DIR/$VERS/"
  RM_DIR="${RM_DIR:?}"
  if [[ ! -d  "$RM_DIR" ]]; then
    echo "Go version $1 not found"
    return 1
  fi
  sudo rm -rf "$RM_DIR" 2>/dev/null && echo "Successfully removed Golang version $VERS" || echo "Golang version not found"
}

__gvm_has_cmd() {
  type "${1-}" >/dev/null 2>&1
}

__gvm_get_shell_name() {
  basename "$SHELL" #cat /proc/$$/cmdline
}

__gvm_get_current_version() {
  if [[ $(__gvm_has_cmd "go") ]]; then
    go version | awk '{print substr($3,3)}'
  fi
}

__gvm_info() {
  printf "Env vars:\n"
  env | grep --color=never 'GO\|GVM' | awk -F '=' '{printf "%-25s %s\n", $1,$2}'
  printf "\nDefault version info:\n"
  cat "$GVM_DIR/$GVM_RC_FILE"
  printf "\nRunning version info:\n"
  go version 2>/dev/null || echo "Golang is not installed"
}

gvm-application() {
  local all_commands="no-preserve-uninstall"
  if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    printf "GVM application help:\n"
    printf " - no-preserve-uninstall - uninstall gvm application\n"
    return 0
  elif [[ $all_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
    sudo rm -rf "$GVM_DIR" 2>/dev/null || echo "Can't remove $GVM_DIR, probably it's already deleted"
    local SHELL_RC_FILE
    local begin_line
    local end_line
    SHELL_RC_FILE="$HOME/.$(__gvm_get_shell_name)rc"
    begin_line=$(grep -n "#-begin-GVM-block-" "$SHELL_RC_FILE" | awk -F ':' '{print $1}' | head -n1)
    end_line=$(grep -n "#-end-GVM-block-" "$SHELL_RC_FILE" | awk -F ':' '{print $1}' | head -n1)
    if [[ -z "$begin_line" ]] || [[ -z "$end_line" ]]; then
      echo "Not found block in shell rc file"
      return 1
    fi
    sed "${begin_line},${end_line}d" "$SHELL_RC_FILE" >"${SHELL_RC_FILE}_new"
    mv "${SHELL_RC_FILE}_new" "${SHELL_RC_FILE}"
    __gvm_reload_shell
    echo "Application gvm successfully uninstalled"
  else
    echo "Command not found"
    return 1
  fi
}

gvm() {
  local all_commands="use ls ls-remote rm info install default"
  local commands_with_versions="default rm install"
  local HELP_GO_VERS="1.17.10"

  if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    __gvm_help_title
    printf "Golang version manager\n"
    printf "\nOptions:\n"
    printf "  -h, --help\t\t\tShow this message and exit\n"
    printf "\nUsage Examples:\n"
    printf "   Install Golang version %s\n" "$HELP_GO_VERS"
    printf "   $ gvm install %s\n" "$HELP_GO_VERS"
    printf "\n   Set and use Golang version %s as default\n" "$HELP_GO_VERS"
    printf "   $ gvm default %s\n" "$HELP_GO_VERS"
    printf "\n   Use Golang version %s (works only for current terminal session)\n" "$HELP_GO_VERS"
    printf "   $ gvm use %s\n" "$HELP_GO_VERS"
    printf "\n   Show installed Golang versions available for switching\n"
    printf "   $ gvm ls\n"
    printf "\n   Show all versions that can be installed from go.dev repo\n"
    printf "   $ gvm ls-remote\n"
    printf "\n   Remove installed version\n"
    printf "   $ gvm rm %s\n" "$HELP_GO_VERS"
    printf "\nCommands:\n"
    printf "  use <version>\t\t\tuse the version\n"
    printf "  default <version>\t\tset default the version\n"
    printf "  info\t\t\t\tshow info about current version\n"
    printf "  ls\t\t\t\tlist available installed versions that you can switch through the command use\n"
    printf "  ls-remote\t\t\tlist available versions for installation\n"
    printf "  install <version>\t\tinstall go version\n"
    printf "  rm <version>\t\t\tremove installed go version\n"
    return 0
  elif [[ $commands_with_versions =~ (^|[[:space:]])$1($|[[:space:]]) ]] && [[ -z "$2" ]]; then
    echo "You should select Golang version"
    return 1
  elif [[ $all_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
    sub_cmd=$(echo "$1" | sed -r 's/[-]+/_/g')
    "__gvm_$sub_cmd" "$2"
  else
    __gvm_no_such_command "$1"
  fi
}

__gvm_help_title() {
  echo "Usage: gvm [OPTIONS] COMMAND [ARGS]..."
}

__gvm_no_such_command() {
  __gvm_help_title
  printf "Try 'gvm -h' for help\n"
  printf "\nError: No such command '%s'\n" "$1"
}

__gvm_init_vars
