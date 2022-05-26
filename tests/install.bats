setup() {
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    PATH="$GVM_DIR:$PATH"
    GO_VER="1.17.10"
    GVM_DIR="$HOME/.gvm"
}

@test "can run curl install script" {
    [ ! $(curl -o- $INSTALL_URL | bash) ]
    [ -d $GVM_DIR ]
    [ -e $GVM_DIR/.gvm.sh ]
}

@test "can run gvm install" {
    run gvm install $GO_VER
    [ "$status" -eq 0 ]
}