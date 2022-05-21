# add to .zshrc or .zshrc
# export GVM_DIR="$HOME/.gvm"
# [ -s "$GVM_DIR/gvm.sh" ] && \. "$GVM_DIR/gvm.sh"  # This loads gvm

# create dir - mkdir -p ~/.gvm
# create dir - chmod +x ~/.gvm/gvm.sh


# export GVM_DIR=~/.gvm
export GVM_VER_DEFAULT=1.17.10
export GO_VER=${GO_VER:-$GVM_VER_DEFAULT}
export GVM_VERS_DIR=$GVM_DIR/versions
export GVM_VENDORS_DIR_NAME=vendors
if ! [[ -z "$GO_VER" ]]; then
  export GOROOT=$GVM_VERS_DIR/$GO_VER/go
  export GOPATH=$GVM_VERS_DIR/$GO_VER/$GVM_VENDORS_DIR_NAME
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi
export GO_DOWNLOAD_URL=https://go.dev/dl/

__gvm_install() {
  local FILE=go$1.linux-amd64.tar.gz
  PATH_DIR_INST=$GVM_VERS_DIR/$1
  PATH_ARCH=$GVM_VERS_DIR/$FILE
  if ! [[ -f "$PATH_ARCH" ]];then
    URL=$GO_DOWNLOAD_URL$FILE
    curl -L --output $PATH_ARCH $URL
  fi
  mkdir -p $PATH_DIR_INST
  tar -C $PATH_DIR_INST -xvf $PATH_ARCH
  mkdir -p $PATH_DIR_INST/$1/$GVM_VENDORS_DIR_NAME
  rm $PATH_ARCH
  echo "Successfully installed Go version $1"
}

__gvm_use() {
  if [[ "$1" == "${__gvm_get_current_version}" ]]; then
    echo "Go version is already $1"
    return 1
  fi
  export GO_VER=$1
  __gvm_reload_shell
  go version && echo "Applied Go version" || echo "Not applied Go version"
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
  # local VER="${__gvm_get_current_version}"
  # echo "Version - ${__gvm_get_current_version} - $VER - $GO_VER"
  if [[ -z "$VERS" ]]; then
    VERS="$GO_VER"
  fi
  if [[ "$VERS" = "${__gvm_get_current_version}" ]]; then
    echo "You deleted current version, now you should switch to another version"
  fi
  echo "Remove dir - $GVM_VERS_DIR/$VERS"
  rm -rf $GVM_VERS_DIR/$VERS/ 2>/dev/null || echo "Golang version not found"
}

__gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

__gvm_get_current_version() {
  return "$(go version | awk '{print substr($3,3)}')"
}

__gvm_info() {
  env | grep 'GO\|GVM'
  go version 2>/dev/null || echo "Golang is not installed"
}

gvm() {
 local all_commands="use ls ls-remote rm info install"
 local commands_with_versions="use rm install"

 if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "GVM help:"
  echo " - use <go-version> - use the version"
  echo " - info - show info about current version"
  echo " - ls - list available installed versions that you can switch through the command use"
  echo " - ls-remote - list available versions for installation"
  echo " - install <go-version> - install go version"
  echo " - rm <go-version> - remove installed go version"
  return 0
 elif [[ $commands_with_versions =~ (^|[[:space:]])$1($|[[:space:]]) ]] && [[ -z "$2" ]]; then
  echo "You should select Golang"
  return 1
    elif [[ $all_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
  sub_cmd=$(echo "$1" | sed -r 's/[-]+/_/g')
  __gvm_$sub_cmd $2
 else
  echo "Command not found"
 fi
}
