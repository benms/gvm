#!/usr/bin/env bash
# Linter: https://www.shellcheck.net/

export RC_FILE
RC_FILE=$HOME/.$(basename "$0")rc
export GVM_DIR="$HOME/.gvm"
export SHELL_URL=https://raw.githubusercontent.com/benms/gvm/main/gvm.sh

if [[ -f "$RC_FILE" ]]; then
{
  printf "#-begin-GVM-block-\n"
  printf "export GVM_DIR=\"\$HOME/.gvm\"\n"
  printf "[ -s \"\$GVM_DIR/gvm.sh\" ] && \. \"\$GVM_DIR/gvm.sh\"\n"
  printf "#-end-GVM-block-\n"
} >> "$RC_FILE"
fi

if [[ ! $(command -v curl) ]]; then
  echo "Can't install GVM. Please install curl."
  return 1
fi

mkdir -p "$GVM_DIR"
curl -L --output "$GVM_DIR/gvm.sh" "$SHELL_URL"
mkdir -p "$GVM_DIR/versions"
touch "$GVM_DIR/.gvmrc"

echo "GVM Installation finished"
