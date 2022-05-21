#Install script

if [ -z "${BASH_VERSION}" ] || [ -n "${ZSH_VERSION}" ]; then
  # shellcheck disable=SC2016
  nvm_echo >&2 'Error: the install instructions explicitly say to pipe the install script to `bash`; please follow them'
  exit 1
fi

__gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

export RC_FILE="$HOME/.$(__gvm_get_shell_name)rc"
export GVM_DIR=$HOME/.gvm
export SHELL_URL=https://raw.githubusercontent.com/benms/gvm/main/gvm.sh

echo "export GVM_DIR=\"\$HOME/.gvm\"" >> $RC_FILE
echo "[ -s \"\$GVM_DIR/gvm.sh\" ] && \. \"\$GVM_DIR/gvm.sh\"" >> $RC_FILE

mkdir -p $GVM_DIR
curl -L --output $GVM_DIR/gvm.sh $SHELL_URL
chmod +x $GVM_DIR/gvm.sh
mkdir -p $GVM_DIR/versions
touch $GVM_DIR/.gvmrc
