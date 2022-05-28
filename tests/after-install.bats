setup() {
    GVM_DIR="$HOME/.gvm"
    SH_NAME=$(echo $SHELL | awk '{n=split($1,A,"/"); print A[n]}')
    SH_RC="$HOME/.${SH_NAME}rc"
    WRONG_VERSION="123"

    echo "Debug line: SH_NAME - $SH_NAME, GO_INSTALL_VER - $GO_INSTALL_VER, SH_RC - $SH_RC"
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

@test "Begin block($BEGIN_BLOCK) exists in RC file" {
    run grep "$BEGIN_BLOCK" $SH_RC
    [ "$status" -eq 0 ]
    [ "$output" == "$BEGIN_BLOCK" ]
}

@test "End block($END_BLOCK) exists in RC file" {
    run grep "$END_BLOCK" $SH_RC
    [ "$status" -eq 0 ]
    [ "$output" == "$END_BLOCK" ]
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
    run command -v gvm
    [ "$output" == "gvm" ]
}

@test "can't install wrong version $WRONG_VERSION" {
    run gvm install $WRONG_VERSION
    [ $status -eq 1 ]
    ERR_MSG="Go version $WRONG_VERSION not found in repo"
    [ "$output" == "$ERR_MSG" ]
}

@test "can run gvm install $GO_INSTALL_VER" {
    run gvm install $GO_INSTALL_VER
    [ $status -eq 0 ]
}

@test "got error message when try install $GO_INSTALL_VER again" {
    run gvm install $GO_INSTALL_VER
    [ $status -eq 1 ]
    ERR_MSG="Go verion $GO_INSTALL_VER is already exists"
    [ "$output" == "$ERR_MSG" ]
}

@test "Can't use wrong version $WRONG_VERSION" {
    run gvm use $WRONG_VERSION
    [ $status -eq 1 ]
    expect_msg="Can't use Go version $WRONG_VERSION because it's not found in installed list"
    [ "$output" == "$expect_msg" ]
}

@test "Can use version $GO_INSTALL_VER" {
    run gvm use $GO_INSTALL_VER
    [ $status -eq 0 ]
    expect_msg="Applied Go version $GO_INSTALL_VER"
    actual_msg=$(echo $output| tail -n1)
    echo "expect_msg - $expect_msg"
    echo "actual_msg - $actual_msg"
    [[ -n $(echo "$actual_msg" | grep "$expect_msg") ]]
}

@test "Can use default version $GO_INSTALL_VER" {
    run gvm default $GO_INSTALL_VER
    [ $status -eq 0 ]
    last_msg=$(echo "$output"| tail -n1)
    expect_msg="Set default version to $GO_INSTALL_VER"
    [ "$last_msg" == "$expect_msg" ]
}

@test ".gvmrc content should be $GO_INSTALL_VER" {
    content=$(cat "$GVM_DIR/.gvmrc"| tail -n1)
    [ "$content" == "$GO_INSTALL_VER" ]
}

@test "can run gvm ls" {
    run gvm ls
    [ $status -eq 0 ]
}

@test "can run gvm info" {
    run gvm ls
    [ $status -eq 0 ]
}

@test "can run $rm $GO_INSTALL_VER" {
    run gvm rm $GO_INSTALL_VER
    [ $status -eq 0 ]
}

@test "Got error when try rm wrong version $WRONG_VERSION" {
    run gvm rm $WRONG_VERSION
    [ $status -eq 1 ]
    [ "$output" == "Go version $WRONG_VERSION not found" ]
}

@test "can run gvm ls and expected count of lines eq 1" {
    run gvm ls
    [ $status -eq 0 ]
    [ "$(echo $output| wc -l)" -eq 1 ]
}

@test "can run uninstall application" {
    run gvm-application no-preserve-uninstall
    [ $status -eq 0 ]
    [ "$(echo $output| wc -l)" -eq 1 ]
}

@test "command v gvm status should be 1" {
    run command -v gvm
    [ "$status" -eq 1 ]
}