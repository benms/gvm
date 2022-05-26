setup() {
    #DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    PATH="$GVM_DIR:$PATH"
    GO_VER="1.17.10"
}

@test "can run curl install script" {
    run $(curl -o- $INSTALL_URL | zsh)
    assert_success
    assert [ -d $GVM_DIR ]
    assert [ -e $GVM_DIR/.gvm.sh ]
}

@test "can run gvm install" {
    run gvm install $GO_VER
    assert_success
}