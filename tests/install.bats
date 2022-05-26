setup() {
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    GVM_DIR="$HOME/.gvm"
    PATH="$GVM_DIR:$PATH"
    GO_VER="1.17.10"
}

@test "can run curl install script" {
    [ $(curl -o- $INSTALL_URL | bash) ]
    [ -d $GVM_DIR ]
    [ -d $GVM_DIR/versions ]
    [ -e $GVM_DIR/gvm.sh ]
    [ -e $GVM_DIR/.gvmrc ]
}

@test "can run gvm install" {
    echo "PATH - $PATH"
    run gvm install $GO_VER
    [ $status -eq 0 ]
}