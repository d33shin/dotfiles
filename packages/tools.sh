#!/usr/bin/env bash
# 유저 영역(~/.local/bin) CLI 도구 설치 — sudo 불필요.
# 이미 설치된 건 건너뜀. 여러 번 돌려도 안전.
set -uo pipefail

BIN="$HOME/.local/bin"; mkdir -p "$BIN"
ARCH="$(uname -m)"   # x86_64 가정
have() { command -v "$1" >/dev/null 2>&1; }
ok()   { echo "  ✓ $1"; }
skip() { echo "  - $1 (이미 설치됨)"; }

# GitHub 최신 릴리스에서 패턴 맞는 자산 URL 찾기
asset() {
  curl -sSL "https://api.github.com/repos/$1/releases/latest" \
   | grep -o '"browser_download_url": *"[^"]*"' | sed 's/.*"\(http[^"]*\)"/\1/' \
   | grep -iE "$2" | head -1
}
# name repo asset-regex binary-name
getbin() {
  local name=$1 repo=$2 re=$3 bn=$4
  if have "$bn"; then skip "$name"; return; fi
  local tmp; tmp="$(mktemp -d)"; ( cd "$tmp"
    local url; url=$(asset "$repo" "$re")
    [ -z "$url" ] && { echo "  ✗ $name: URL 못찾음"; exit 1; }
    local f="${url##*/}"; curl -sSL -o "$f" "$url"
    case "$f" in
      *.tar.gz|*.tgz) tar -xzf "$f" ;; *.tar.bz2|*.tbz) tar -xjf "$f" ;;
      *.tar.xz) tar -xJf "$f" ;; *.zip) unzip -qo "$f" ;;
    esac
    local found; found=$(find . -type f -name "$bn" ! -name '*.tar*' | head -1)
    [ -z "$found" ] && { echo "  ✗ $name: 바이너리 못찾음"; exit 1; }
    install -m755 "$found" "$BIN/$bn"; echo "  ✓ $name"
  ); rm -rf "$tmp"
}

echo "[1/3] 스크립트 기반 도구"
if have starship; then skip starship; else
  curl -sS https://starship.rs/install.sh | sh -s -- -b "$BIN" -y >/dev/null && ok starship; fi
if have zoxide; then skip zoxide; else
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null && ok zoxide; fi
if have fzf; then skip fzf; else
  [ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null 2>&1
  ~/.fzf/install --bin >/dev/null 2>&1
  ln -sf ~/.fzf/bin/fzf "$BIN/fzf"; ln -sf ~/.fzf/bin/fzf-tmux "$BIN/fzf-tmux"; ok fzf; fi

echo "[2/3] GitHub 릴리스 바이너리"
getbin fd      sharkdp/fd            'x86_64-unknown-linux-gnu\.tar\.gz$'  fd
getbin bat     sharkdp/bat           'x86_64-unknown-linux-gnu\.tar\.gz$'  bat
getbin eza     eza-community/eza     'x86_64-unknown-linux-gnu\.tar\.gz$'  eza
getbin lazygit jesseduffield/lazygit 'Linux_x86_64\.tar\.gz$'              lazygit
getbin delta   dandavison/delta      'x86_64-unknown-linux-gnu\.tar\.gz$'  delta
getbin btop    aristocratos/btop     'x86_64-linux-musl\.tar\.gz$'         btop
getbin rg      BurntSushi/ripgrep    'x86_64-unknown-linux-musl\.tar\.gz$' rg
getbin jq      jqlang/jq             'linux-amd64$'                        jq

echo "[3/3] Nerd Font (JetBrainsMono)"
FONTDIR="$HOME/.local/share/fonts"
if fc-list 2>/dev/null | grep -qi 'JetBrainsMono Nerd'; then skip "Nerd Font"; else
  mkdir -p "$FONTDIR"; tmp="$(mktemp -d)"; ( cd "$tmp"
    url=$(asset ryanoasis/nerd-fonts 'JetBrainsMono\.tar\.xz$')
    curl -sSL -o jbm.tar.xz "$url" && tar -xJf jbm.tar.xz && cp -f ./*.ttf "$FONTDIR/" 2>/dev/null
  ); rm -rf "$tmp"; fc-cache -f >/dev/null 2>&1; ok "Nerd Font"
fi

echo "도구 설치 완료."
echo "참고: Ghostty(터미널)는 데스크탑에서 별도 설치 (snap install ghostty 등). 서버에선 불필요."
