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

@test "curl to $GVM_SH_URL should have status code $EXPECT_DOWNLOAD_STATUS_CODE" {
    result=$(curl -I $GVM_SH_URL | tee | grep -i http/2 | awk '{print $2}')
    [ "$result" == "$EXPECT_DOWNLOAD_STATUS_CODE" ]
}

@test "curl to $INSTALL_URL should have status code $EXPECT_DOWNLOAD_STATUS_CODE" {
    result=$(curl -I $INSTALL_URL | tee | grep -i http/2 | awk '{print $2}')
    [ "$result" == "$EXPECT_DOWNLOAD_STATUS_CODE" ]
}

@test "check command v gvm" {
    result=$(command -v gvm)
    [ "$result" == "gvm" ]
}

@test "can run gvm install $GO_VER" {
    run gvm install $GO_VER
    [ $status -eq 0 ]
}

@test "can run gvm ls" {
    run gvm ls
    [ $status -eq 0 ]
}

@test "can run gvm info" {
    run gvm ls
    [ $status -eq 0 ]
}

@test "can run $rm $GO_VER" {
    run gvm rm $GO_VER
    [ $status -eq 0 ]
}
