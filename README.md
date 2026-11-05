# 덩굴숲

앙리 루소의 정글을 헤치며 마술적 사실주의의 기적을 찾아다니는 2D 웹게임.
같이 들어온 사람과 위치와 말이 실시간으로 보이고, 앵무새는 숲에서 들은 말을 기억했다가 따라 한다.
기적을 발견하면 멕시코 봉헌화(레타블로) 형식의 카드가 그림첩에 한 장씩 모인다.

## 파일

| 파일 | 내용 |
|---|---|
| `index.html` | 게임 전체 |
| `config.js` | Supabase 연결 정보 (비워두면 혼자 하는 버전) |
| `supabase.sql` | 앵무새 기억용 테이블. Supabase SQL Editor에서 한 번 실행 |
| `assets/` | 그림 파일 (없으면 색으로 그림) |

## 그림 넣기

`assets/`에 아래 이름의 png를 넣으면 바로 바뀐다. 없는 파일은 기본 색으로 그려진다.
한 칸은 28px. 픽셀 아트는 28px 그대로 그리거나 56px(2배)로 그려도 선명하게 축소된다.

| 파일 | 크기 | 쓰이는 곳 |
|---|---|---|
| `floor.png` | 28×28 | 공터 바닥 |
| `bush.png` | 28×28 | 덤불 칸 바닥 (위에 잎이 덮임) |
| `leaf.png` | 14×10 | 잎 한 장. 덤불 한 칸에 5장씩 흩어지고 사람 주위로 벌어진다 |
| `tree.png` | 45×45 | 나무 위에서 본 모습. 칸보다 크게 그려진다 |
| `water.png` | 28×28 | 물 |
| `ruin.png` | 28×28 | 기적의 자리 돌 제단 (2×2칸) |
| `player.png` | 28×28 | 사람 (모두 공통) |
| `parrot.png` | 20×20 | 앵무새 |

투명 배경 png로 그리면 된다. 색만 바꾸고 싶으면 `index.html`의 `COLORS`를 고치면 된다.

## 실행

- 내 컴퓨터: 폴더에서 `npx serve` 후 브라우저로 열기 (또는 VS Code Live Server)
- GitHub Pages: 저장소 Settings → Pages → Branch를 `main` / `root`로 저장. 잠시 후 `https://jynsol.github.io/jungle/`에서 열린다

## 멀티플레이 켜기 (Supabase)

1. Supabase에서 프로젝트를 하나 만든다
2. SQL Editor에 `supabase.sql`을 붙여넣고 Run
3. Project Settings → API에서 Project URL과 anon key를 복사해 `config.js`에 넣는다

위치와 채팅은 저장되지 않고 그 자리에 있는 사람끼리만 주고받는다. 앵무새가 배운 말만 `parrot_lines` 테이블에 남는다.
그림첩과 내 위치, 이름은 각자 브라우저에 저장된다.

## 조작

- 이동: WASD·방향키, 휴대폰은 화면을 누른 채 끌기
- 말하기: Enter
- 덤불 속으로 그냥 걸어 들어가면 헤치고 지나간다
