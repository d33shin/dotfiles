# 📁 zoxide 치트시트 (스마트 cd)

> 한번 방문한 폴더는 짧은 키워드로 점프. `cd` 대체.

## 기본
| 명령 | 동작 |
|------|------|
| `z 키워드` | 가장 자주/최근 간 매칭 폴더로 이동 |
| `z foo bar` | 여러 조각으로 좁히기 |
| `z` | 홈으로 |
| `z -` | 직전 폴더로 |
| `zi 키워드` | **fzf로 후보 골라서** 이동 (interactive) |

## 예시
```bash
z coin          # ~/projects/coin-community 같은 곳으로 점프
z nvim          # ~/.config/nvim 으로
zi proj         # proj 매칭되는 폴더들 fzf로 고르기
```

## 동작 원리
- 폴더를 `cd`/`z`로 방문할수록 점수가 쌓임 (frecency)
- 그래서 **자주 가는 곳일수록 짧게** 쳐도 맞음
- 처음엔 비어 있으니, 평소처럼 다니다 보면 똑똑해짐

## 팁
- 매칭이 틀리면 더 구체적으로: `z coin comm`
- 어디로 갈지 확인만: `zoxide query 키워드`
- 목록 보기: `zoxide query -l`
