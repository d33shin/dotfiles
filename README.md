# dotfiles

키보드 중심 터미널 개발환경. 어느 기계서나 `clone` + `install.sh` 하면 동일하게 재현됩니다.

**스택:** Ghostty · tmux · Neovim · bash + starship · fzf · zoxide · lazygit
**개발:** TypeScript · Bun · Svelte (LSP/포매팅 구성됨)

## 새 기계에 설치

```bash
git clone https://github.com/d33shin/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh           # 설정 링크 + 도구 설치
exec bash              # 셸 다시 로드
```

- `./install.sh --links` : 설정 링크만 (도구 설치 생략)
- 기존 설정 파일은 `*.bak.<시간>` 으로 백업됩니다.
- **sudo 불필요** — 모든 도구는 `~/.local/bin` 에 설치됩니다.
- **Ghostty**(GUI 터미널)는 데스크탑에서 별도 설치 (`snap install ghostty`). 서버에선 불필요.

## 구조

```
dotfiles/
├── install.sh            # 심볼릭 링크 + 도구 설치
├── nvim/                 # Neovim 설정 (lazy.nvim)
├── tmux/tmux.conf
├── ghostty/config        # 데스크탑 전용
├── bash/dotfiles.bashrc  # 프롬프트/별칭/fzf/zoxide
├── cheatsheets/          # 소프트웨어별 치트시트
├── bin/cheat             # 치트시트 뷰어
└── packages/tools.sh     # CLI 도구 다운로드
```

## 치트시트

```bash
cheat                 # 메뉴에서 고르기
cheat start-here      # 시작 가이드
cheat nvim            # 특정 도구
```

수록: `start-here` `nvim` `tmux` `ghostty` `shell` `fzf` `zoxide` `lazygit` `cli-tools`

## 주요 단축키 (요약)

| | |
|---|---|
| nvim leader | `Space` |
| 파일 찾기 / 내용 검색 | `Space ff` / `Space fg` |
| 파일 트리 | `Space e` |
| 저장 | `Space s` |
| git (lazygit) | `Space gg` |
| 진단 목록 | `Space xx` |
| 터미널 토글 | `Ctrl+/` |
| 창/패널 이동 | `Ctrl+h/j/k/l` |
| tmux prefix | `Ctrl+b` |
| tmux 스크롤 | `Alt+u` |
| 셸 히스토리 / 파일 | `Ctrl+R` / `Ctrl+T` |
| 폴더 점프 | `z 이름` |

자세한 건 `cheat`.
