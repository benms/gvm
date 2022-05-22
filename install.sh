#Install script

__gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

__gvm_reload_shell() {
  source ~/.$(__gvm_get_shell_name)rc
}

export RC_FILE="$HOME/.$(__gvm_get_shell_name)rc"
export GVM_DIR=$HOME/.gvm
export SHELL_URL=https://raw.githubusercontent.com/benms/gvm/main/gvm.sh

echo "#-begin-GVM-block-" >> $RC_FILE
echo "export GVM_DIR=\"\$HOME/.gvm\"" >> $RC_FILE
echo "[ -s \"\$GVM_DIR/gvm.sh\" ] && \. \"\$GVM_DIR/gvm.sh\"" >> $RC_FILE
echo "#-end-GVM-block-" >> $RC_FILE

mkdir -p $GVM_DIR
curl -L --output $GVM_DIR/gvm.sh $SHELL_URL
chmod +x $GVM_DIR/gvm.sh
mkdir -p $GVM_DIR/versions
touch $GVM_DIR/.gvmrc
__gvm_reload_shell