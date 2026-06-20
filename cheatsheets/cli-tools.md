# 🛠 CLI 도구 치트시트

## eza (ls 대체)
```bash
ll              # 자세히 (별칭)
la              # 숨김 포함
lt              # 트리
eza --tree --level=3
eza -l --sort=modified    # 수정시간순
```

## bat (cat 대체)
```bash
bat file.ts            # 컬러+줄번호 (별칭 cat)
bat -A file            # 공백/특수문자 표시
bat -r 10:20 file      # 10~20줄만
bat -l json file       # 언어 강제 지정
```

## fd (find 대체)
```bash
fd 키워드               # 이름에 키워드 든 파일
fd -e ts               # 확장자 ts
fd -H 키워드            # 숨김파일 포함
fd -t d 키워드          # 폴더만
fd 키워드 -x 명령       # 찾은 것마다 명령 실행
```

## ripgrep / rg (grep 대체, 내용 검색)
```bash
rg "검색어"            # 하위 전체에서 내용 검색
rg -i "검색어"         # 대소문자 무시
rg -t ts "검색어"      # ts 파일만
rg -l "검색어"         # 파일명만
rg "검색어" -A 3 -B 3  # 앞뒤 3줄 같이
```

## delta (git diff 예쁘게 — 자동 적용됨)
```bash
git diff               # delta가 자동으로 꾸며줌
git log -p             # 커밋별 변경
# 보는 중: n/N 으로 다음/이전 변경 점프
```

## btop (시스템 모니터)
```bash
btop                   # 실행
# q 종료 / m 메모리 / 마우스도 됨 / Esc 메뉴
```

## jq (JSON 다루기)
```bash
cat data.json | jq .            # 예쁘게
jq '.key' data.json             # 특정 키
jq '.items[].name' data.json    # 배열 순회
curl -s URL | jq '.'            # API 응답 보기
```
