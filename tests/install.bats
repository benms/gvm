setup() {
    #DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    INSTALL_URL="https://raw.githubusercontent.com/benms/gvm/main/install.sh"
    PATH="$GVM_DIR:$PATH"
}

@test "can run curl install script" {
    run curl -o- $INSTALL_URL | zsh
    assert_output 'Welcome to our project!'
}