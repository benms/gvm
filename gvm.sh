export GOMY=$HOME/go/my
export GOVERDEFAULT=1.17.10
export GOVER=${GOVER:-$GOVERDEFAULT}
export GOROOT=$GOMY/$GOVER/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go_fetch() {
  FILE=go$1.linux-amd64.tar.gz
  PATH_DIR_INST=$GOMY/$1
  PATH_ARCH=$GOMY/$FILE
  if ! [[ -f "$PATH_ARCH" ]];then
    URL=https://go.dev/dl/$FILE
    #wget -O $PATH_ARCH $URL
    curl -L --output $PATH_ARCH $URL
  fi
  mkdir -p $PATH_DIR_INST
  tar -C $PATH_DIR_INST -xvf $PATH_ARCH
  rm $PATH_ARCH
  echo "Successfully fetched Go version $1"
}

go_use() {
  export GOVER=$1
  source ~/.zshrc
  go version && echo "Applied Go version" || echo "Not applied Go version"
}

go_ls() {
  ls -1 $GOPATH/my
}

go_ls_remote() {
 curl -s https://go.dev/dl/| grep "class=\"download\"" | grep linux-amd64 | awk 'match($0, /go[1-9]\.[0-9a-z]+\.?[0-9]+/) { print substr( $0, RSTART, RLENGTH )}'|less
}

go_rm() {
 go_use $GOVERDEFAULT
 rm -rf $GOMY/$1
}

gvm() {
 sub_cmd=`echo "$1" | sed -r 's/[-]+/_/g'`
 go_$sub_cmd $2
}
