setup() {
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    GVM_DIR="$HOME/.gvm"
    GO_VER="1.17.10"

    [ -s "$GVM_DIR/gvm.sh" ] && \. "$GVM_DIR/gvm.sh" || echo "GVM sh not found"
}

@test "gvm dir exists" {
    [ -d "$GVM_DIR" ]
}

@test "gvm version dir exists" {
    [ -d "$GVM_DIR/versions" ]
}

@test "gvm script exists" {
    cat $GVM_DIR/gvm.sh
    [ -e "$GVM_DIR/gvm.sh" ]
}

@test "gvmrc file exists" {
    [ -e "$GVM_DIR/.gvmrc" ]
}

@test "curl to https://raw.githubusercontent.com/benms/gvm/main/gvm.sh should have status code 404" {
    result=$(curl -I https://raw.githubusercontent.com/benms/gvm/main/gvm.sh | tee | grep -i http/2 | awk '{print $2}')
    [ "$result" == "404" ]
}

@test "check command v gvm" {
    result=$(command -v gvm)
    [ "$result" == "gvm" ]
}

@test "can run gvm install" {
    run gvm install $GO_VER
    [ $status -eq 0 ]
}