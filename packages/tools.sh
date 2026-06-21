#!/usr/bin/env bash
# 유저 영역(~/.local/bin) CLI 도구 설치 — 대부분 sudo 불필요.
# 예외: tmux 는 시스템 패키지라 패키지 매니저(sudo) 필요.
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

echo "[0/5] Neovim 본체"
if [ -x "$BIN/nvim" ] || have nvim; then skip neovim; else
  tmp="$(mktemp -d)"; ( cd "$tmp"
    url=$(asset neovim/neovim 'nvim-linux-x86_64\.tar\.gz$')
    [ -z "$url" ] && url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -sSL -o nvim.tar.gz "$url" && tar -xzf nvim.tar.gz
    dir=$(find . -maxdepth 1 -type d -name 'nvim-linux*' | head -1)
    rm -rf "$HOME/.local/nvim-dist"; mv "$dir" "$HOME/.local/nvim-dist"
    ln -sf "$HOME/.local/nvim-dist/bin/nvim" "$BIN/nvim"
  ); rm -rf "$tmp"
  [ -x "$BIN/nvim" ] && ok neovim || echo "  ✗ neovim 설치 실패"
fi

echo "[1/5] 스크립트 기반 도구"
if have starship; then skip starship; else
  curl -sS https://starship.rs/install.sh | sh -s -- -b "$BIN" -y >/dev/null && ok starship; fi
if have zoxide; then skip zoxide; else
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null && ok zoxide; fi
if have fzf; then skip fzf; else
  [ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null 2>&1
  ~/.fzf/install --bin >/dev/null 2>&1
  ln -sf ~/.fzf/bin/fzf "$BIN/fzf"; ln -sf ~/.fzf/bin/fzf-tmux "$BIN/fzf-tmux"; ok fzf; fi
# Claude Code (네이티브 설치 -> ~/.local/bin/claude, 백그라운드 자동 업데이트)
if [ -x "$BIN/claude" ] || have claude; then skip claude; else
  curl -fsSL https://claude.ai/install.sh | bash >/dev/null 2>&1 \
    && ok claude || echo "  ✗ claude 설치 실패 (인증은 첫 실행 시 'claude' 로)"; fi

echo "[2/5] GitHub 릴리스 바이너리"
getbin fd      sharkdp/fd            'x86_64-unknown-linux-gnu\.tar\.gz$'  fd
getbin bat     sharkdp/bat           'x86_64-unknown-linux-gnu\.tar\.gz$'  bat
getbin eza     eza-community/eza     'x86_64-unknown-linux-gnu\.tar\.gz$'  eza
getbin lazygit jesseduffield/lazygit 'Linux_x86_64\.tar\.gz$'              lazygit
getbin delta   dandavison/delta      'x86_64-unknown-linux-gnu\.tar\.gz$'  delta
getbin btop    aristocratos/btop     'x86_64-unknown-linux-musl\.tar\.gz$' btop
getbin rg      BurntSushi/ripgrep    'x86_64-unknown-linux-musl\.tar\.gz$' rg
getbin jq      jqlang/jq             'linux-amd64$'                        jq

echo "[3/5] tmux (시스템 패키지 — sudo 필요할 수 있음)"
if have tmux; then skip tmux; else
  if   have apt-get; then sudo apt-get update -qq && sudo apt-get install -y tmux >/dev/null && ok tmux
  elif have dnf;     then sudo dnf install -y tmux >/dev/null && ok tmux
  elif have apk;     then sudo apk add tmux >/dev/null && ok tmux
  elif have pacman;  then sudo pacman -S --noconfirm tmux >/dev/null && ok tmux
  elif have brew;    then brew install tmux >/dev/null && ok tmux
  else echo "  ✗ tmux: 패키지 매니저를 못찾음 — 수동 설치 필요"
  fi
fi

echo "[4/5] Nerd Font (JetBrainsMono)"
FONTDIR="$HOME/.local/share/fonts"
if fc-list 2>/dev/null | grep -qi 'JetBrainsMono Nerd'; then skip "Nerd Font"; else
  mkdir -p "$FONTDIR"; tmp="$(mktemp -d)"; ( cd "$tmp"
    url=$(asset ryanoasis/nerd-fonts 'JetBrainsMono\.tar\.xz$')
    curl -sSL -o jbm.tar.xz "$url" && tar -xJf jbm.tar.xz && cp -f ./*.ttf "$FONTDIR/" 2>/dev/null
  ); rm -rf "$tmp"; fc-cache -f >/dev/null 2>&1; ok "Nerd Font"
fi

echo "도구 설치 완료."
echo "참고: Ghostty(터미널)는 데스크탑에서 별도 설치 (snap install ghostty 등). 서버에선 불필요."
echo "참고: claude 는 첫 실행 시 'claude' 명령으로 로그인 (Pro/Max/Team/Console 계정 필요)."
