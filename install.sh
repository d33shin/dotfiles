#!/usr/bin/env bash
# dotfiles 설치: 설정 심볼릭 링크 + CLI 도구 설치.
# 여러 번 돌려도 안전(idempotent). 기존 파일은 .bak 으로 백업.
#
# 사용법:
#   ./install.sh           # 설정 링크 + 도구 설치 전부
#   ./install.sh --links   # 설정 링크만 (도구 설치 건너뜀)
set -uo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "dotfiles 경로: $DOT"

link() { # src(저장소 안), dst(홈)
  local src="$DOT/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then rm -f "$dst"
  elif [ -e "$dst" ]; then mv "$dst" "$dst.bak.$(date +%s)"; echo "  백업: $dst -> .bak"; fi
  ln -s "$src" "$dst"
  echo "  링크: $dst -> $src"
}

echo "== 1) 설정 심볼릭 링크 =="
link nvim                 "$HOME/.config/nvim"
link tmux/tmux.conf       "$HOME/.tmux.conf"
link ghostty/config       "$HOME/.config/ghostty/config"
link cheatsheets          "$HOME/.config/cheatsheets"
link bin/cheat            "$HOME/.local/bin/cheat"
chmod +x "$DOT/bin/cheat" "$DOT/packages/tools.sh" 2>/dev/null

echo "== 2) ~/.bashrc 에 dotfiles 연결 =="
MARK="# >>> dotfiles bashrc >>>"
if ! grep -qF "$MARK" "$HOME/.bashrc" 2>/dev/null; then
  {
    echo ""
    echo "$MARK"
    echo "[ -f \"$DOT/bash/dotfiles.bashrc\" ] && source \"$DOT/bash/dotfiles.bashrc\""
    echo "# <<< dotfiles bashrc <<<"
  } >> "$HOME/.bashrc"
  echo "  추가됨"
else
  echo "  이미 연결됨"
fi

echo "== 3) git delta 설정 =="
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictStyle zdiff3
echo "  완료"

if [ "${1:-}" != "--links" ]; then
  echo "== 4) CLI 도구 설치 =="
  bash "$DOT/packages/tools.sh"
else
  echo "== 4) 도구 설치 건너뜀(--links) =="
fi

echo ""
echo "✅ 완료! 새 터미널을 열거나  exec bash  실행."
echo "   nvim 첫 실행 시 플러그인/LSP가 자동 설치됩니다 (:Lazy, :Mason 으로 확인)."
echo "   치트시트:  cheat   또는  cheat start-here"
