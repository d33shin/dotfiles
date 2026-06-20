#!/usr/bin/env bash
# 새 기계 원코드 설치:
#   curl -sSL https://raw.githubusercontent.com/d33shin/dotfiles/master/bootstrap.sh | bash
set -e
DOT="$HOME/dotfiles"
if [ -d "$DOT/.git" ]; then
  echo "== 기존 dotfiles 업데이트 =="
  git -C "$DOT" pull --ff-only
else
  echo "== dotfiles 클론 =="
  git clone https://github.com/d33shin/dotfiles "$DOT"
fi
cd "$DOT"
bash install.sh
