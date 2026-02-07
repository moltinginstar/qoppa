#!/usr/bin/env sh
set -eu

QOPPA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/qoppa"
mkdir -p "$QOPPA_DIR"

curl -fsSL https://raw.githubusercontent.com/moltinginstar/qoppa/main/qoppa.zsh \
  -o "$QOPPA_DIR/qoppa.zsh"

cat << EOF

Add this to your ~/.zshrc:

  source "$QOPPA_DIR/qoppa.zsh"

EOF
