# ===== dotfiles dev env =====
# ~/.bashrc 에서 이 파일을 source 함.
export PATH="$HOME/.local/bin:$PATH"

# starship 프롬프트
command -v starship >/dev/null && eval "$(starship init bash)"
# zoxide (스마트 cd) -> `z 폴더이름`
command -v zoxide  >/dev/null && eval "$(zoxide init bash)"

# fzf 키바인딩 (Ctrl+R 히스토리, Ctrl+T 파일, Alt+C 폴더)
[ -f ~/.fzf/shell/key-bindings.bash ] && source ~/.fzf/shell/key-bindings.bash
[ -f ~/.fzf/shell/completion.bash ]   && source ~/.fzf/shell/completion.bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# 최신 CLI 별칭
command -v eza >/dev/null && {
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l  --icons --group-directories-first --git'
  alias la='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
}
command -v bat >/dev/null && alias cat='bat --paging=never'
command -v nvim >/dev/null && { alias vim='nvim'; alias vi='nvim'; }
command -v lazygit >/dev/null && alias lg='lazygit'
# ===== end dotfiles dev env =====
