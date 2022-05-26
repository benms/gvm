setup() {
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    GVM_DIR="$HOME/.gvm"
    PATH="$GVM_DIR:$PATH"
    GO_VER="1.17.10"
}

@test "can run curl install script" {
    [ $(curl -o- $INSTALL_URL | $(command -v bash)) ]
}

@test "gvm dir exists" {
    [ -d $GVM_DIR ]
}

@test "gvm version dir exists" {
    [ -d $GVM_DIR/versions ]
}

@test "gvm script exists" {
    [ -e $GVM_DIR/gvm.sh ]
}

@test "gvmrc file exists" {
    [ -e $GVM_DIR/.gvmrc ]
}

@test "can run gvm install" {
    echo "PATH - $PATH"
    run gvm install $GO_VER
    [ $status -eq 0 ]
}