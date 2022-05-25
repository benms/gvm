#!/usr/bin/env bash
# Linter: https://www.shellcheck.net/

__gvm_get_shell_name() {
  echo "$SHELL" | awk '{n=split($1,A,"/"); print A[n]}'
}

__gvm_reload_shell() {
  # shellcheck source=/dev/null
  source "$HOME/.$(__gvm_get_shell_name)rc"
}

export RC_FILE
RC_FILE="$HOME/.$(__gvm_get_shell_name)rc"
export GVM_DIR="$HOME/.gvm"
export SHELL_URL=https://raw.githubusercontent.com/benms/gvm/main/gvm.sh

{
  printf "#-begin-GVM-block-\n"
  printf "export GVM_DIR=\"\$HOME/.gvm\"\n"
  printf "[ -s \"\$GVM_DIR/gvm.sh\" ] && \. \"\$GVM_DIR/gvm.sh\"\n"
  printf "#-end-GVM-block-\n"
} >> "$RC_FILE"

mkdir -p "$GVM_DIR"
curl -L --output "$GVM_DIR/gvm.sh" "$SHELL_URL"
chmod +x "$GVM_DIR/gvm.sh"
mkdir -p "$GVM_DIR/versions"
touch "$GVM_DIR/.gvmrc"

echo "GVM Installation finished"
