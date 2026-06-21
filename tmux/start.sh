#!/usr/bin/env bash
# 기본 tmux 레이아웃: "claude" 윈도우에 패널 3개 (좌/중 bash, 우 claude)
# 사용법:
#   t                 -> 기본 프로젝트(~/projects/nullkinetic) 열기
#   t ~/projects/foo  -> 다른 앱 디렉터리로 열기
# 세션 이름은 디렉터리 이름에서 자동으로 만들어짐 (앱마다 별도 세션).

root="${1:-$HOME/projects/nullkinetic}"
root="${root%/}"                       # 끝 슬래시 제거
session="$(basename "$root")"          # 폴더명을 세션 이름으로

if ! tmux has-session -t "$session" 2>/dev/null; then
  tmux new-session  -d -s "$session" -n claude -c "$root"
  tmux split-window -h -t "$session:claude" -c "$root"
  tmux split-window -h -t "$session:claude" -c "$root"

  # 가로 3분할 균등 배치
  tmux select-layout -t "$session:claude" even-horizontal

  # 오른쪽 패널에서 claude 실행
  tmux send-keys -t "$session:claude.2" 'claude' C-m

  # 왼쪽 패널에 포커스
  tmux select-pane -t "$session:claude.0"
fi

exec tmux attach -t "$session"
