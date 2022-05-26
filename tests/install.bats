setup() {
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    GVM_DIR="$HOME/.gvm"
    GO_VER="1.17.10"

    source "$GVM_DIR/gvm.sh"
}

@test "gvm dir exists" {
    [ -d "$GVM_DIR" ]
}

@test "gvm version dir exists" {
    [ -d "$GVM_DIR/versions" ]
}

@test "gvm script exists" {
    [ -e "$GVM_DIR/gvm.sh" ]
}

@test "gvmrc file exists" {
    [ -e "$GVM_DIR/.gvmrc" ]
}

@test "can run gvm install" {
    echo "PATH - $PATH, GVM_DIR - $GVM_DIR"
    run gvm install $GO_VER
    [ $status -eq 0 ]
}