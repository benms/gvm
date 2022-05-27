setup() {
    GVM_DIR="$HOME/.gvm"
    GO_VER="1.17.10"
    SH_NAME=$(echo $SHELL | awk '{n=split($1,A,"/"); print A[n]}')
    SH_RC="$HOME/.${SH_NAME}rc"
    BEGIN_BLOCK="#-begin-GVM-block-"
    END_BLOCK="#-end-GVM-block-"

    echo "SH_NAME - $SH_NAME, GO_VER - $GO_VER, SH_RC - $SH_RC"

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

@test "Begin block($BEGIN_BLOCK) exists in $SH_RC file" {
    run grep "$BEGIN_BLOCK" $SH_RC
    [ "$status" -eq 0 ]
    [ "$output" == "$BEGIN_BLOCK" ]
}

@test "End block($END_BLOCK) exists in $SH_RC file" {
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
    result=$(command -v gvm)
    [ "$result" == "gvm" ]
}

@test "can run gvm install $GO_VER" {
    run gvm install $GO_VER
    [ $status -eq 0 ]
}

@test "can run gvm ls and expected count of lines eq 2" {
    run gvm ls
    [ $status -eq 0 ]
    [ "$(echo '$output'| wc -l)" -eq 2 ]
}

@test "can run gvm info" {
    run gvm ls
    [ $status -eq 0 ]
}

@test "can run $rm $GO_VER" {
    run gvm rm $GO_VER
    [ $status -eq 0 ]
}

@test "can run gvm ls and expected count of lines eq 1" {
    run gvm ls
    [ $status -eq 0 ]
    [ "$(echo '$output'| wc -l)" -eq 1 ]
}
