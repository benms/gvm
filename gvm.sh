export GOPATH=$HOME/go
export GVM_DIR=$GOPATH/my
export GVM_VER_DEFAULT=1.17.10
export GO_VER=${GO_VER:-$GVM_VER_DEFAULT}
export GOROOT=$GVM_DIR/$GO_VER/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GO_DOWNLOAD_URL=https://go.dev/dl/

gvm_install() {
  FILE=go$1.linux-amd64.tar.gz
  PATH_DIR_INST=$GVM_DIR/$1
  PATH_ARCH=$GVM_DIR/$FILE
  if ! [[ -f "$PATH_ARCH" ]];then
    URL=$GO_DOWNLOAD_URL$FILE
    curl -L --output $PATH_ARCH $URL
  fi
  mkdir -p $PATH_DIR_INST
  tar -C $PATH_DIR_INST -xvf $PATH_ARCH
  rm $PATH_ARCH
  echo "Successfully fetched Go version $1"
}

gvm_use() {
  export GO_VER=$1
  source ~/.$(gvm_get_shell_name)rc
  go version && echo "Applied Go version" || echo "Not applied Go version"
}

gvm_ls() {
  ls -1 $GVM_DIR
}

gvm_ls_remote() {
 curl -s $GO_DOWNLOAD_URL| grep "class=\"download\"" | grep linux-amd64 | awk 'match($0, /go[1-9]\.[0-9a-z]+\.?[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'|less
}

gvm_rm() {
 gvm_use $GVM_VER_DEFAULT
 rm -rf $GVM_DIR/$1
}

gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

gvm() {
 available_list_of_commands="use ls ls-remote rm"
 if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "GVM help:"
  echo " - use <go-version> - use the version"
  echo " - ls - list available installed versions that you can switch through the command use"
  echo " - ls-remote - list available versions for installation"
  echo " - rm <go-version> - remove installed go version"
  return 0
 fi
 if [[ $available_list_of_commands =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
  sub_cmd=$(echo "$1" | sed -r 's/[-]+/_/g')
  gvm_$sub_cmd $2
 else
  echo "Command not found"
 fi
}
