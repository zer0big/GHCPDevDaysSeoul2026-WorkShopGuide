# Copilot CLI 치트시트

## 시작과 종료

| 입력 | 위치 | 동작 |
| --- | --- | --- |
| `copilot` | 터미널 | 대화형 세션 시작 (현재 폴더 기준) |
| `copilot --resume` | 터미널 | 이전 세션 목록에서 골라 재개 |
| `/login` | CLI | GitHub 로그인 |
| `/exit`, `/quit` (또는 `Ctrl+C` 두 번) | CLI | 세션 종료 |
| `/help`, `/` | CLI | 도움말, 명령 목록 |

## 이번 실습에서 쓰는 슬래시 명령

| 명령 | 레슨 | 동작 |
| --- | --- | --- |
| `/model` | 0 | 사용할 모델 선택 |
| `/init <요청>` | 2 | 프로젝트 지침(`.github/copilot-instructions.md`) 생성 |
| `/diff` | 4, 8 | 현재 변경 사항 검토 |
| `/worktree` | 4 | 별도 폴더·브랜치(워크트리)에서 작업 |
| `/plan <요청>` | 5 | 코드 수정 전에 구현 계획 수립 |
| `/context` | 6 | 컨텍스트 사용량 확인 |
| `/compact` | 6 | 대화 기록 요약 (맥락 유지, 공간 확보) |
| `/clear` | 6 | 새 대화 시작 (파일은 되돌리지 않음) |
| `/resume` | 7 | CLI 안에서 세션 전환 |
| `/remote` | 7 (선택) | 로컬 세션을 다른 기기에서 접속 |
| `/pr create` | 8 | 현재 브랜치로 PR 생성 |
| `/pr agentmerge` | 8 | 검사·피드백 확인 후 병합 |
| `/delegate <요청>` | 9 | 클라우드 에이전트에게 작업 위임 (Draft PR 생성) |

## 키보드

| 키 | 동작 |
| --- | --- |
| `Shift+Tab` | 모드 전환 (일반 / Plan 등) |
| `←` (입력창이 빈 상태) | 사이드 패널 열기 |
| `Tab` (사이드 패널) | Sessions / Issues / Pull requests 탭 이동 |
| `↑` `↓` (사이드 패널) | 항목 선택 |
| `Enter` (사이드 패널) | 항목 전체 내용 보기 |
| `c` (사이드 패널) | 선택한 이슈·PR을 채팅에 첨부 |
| `n` (Sessions 탭) | 새 세션 만들기 |
| `o` (Pull requests 탭) | GitHub에서 PR 열기 |
| `Ctrl+N` | 새 세션 |
| `Esc` | 현재 화면 닫기, 진행 중인 작업 취소 |

## 셸 명령 바로 실행

입력창에서 `!`로 시작하면 셸 명령을 실행합니다.

```text
!git status
!git log --oneline -1
!gh issue list
!gh pr list
!start index.html        (Windows)
!open index.html         (macOS)
!xdg-open index.html     (Linux)
```

## 도구 승인 선택지

| 선택 | 의미 |
| --- | --- |
| `1. Yes` | 이번 한 번만 허용 |
| `2. Yes, and approve ... for the rest of the running session` | 이 세션 동안 그 도구를 다시 묻지 않고 허용 (어떤 방식으로든 사용 가능) |
| `3. No, and tell Copilot what to do differently (Esc)` | 취소하고 다른 방법 지시 |

> 키 배치와 명령은 CLI 버전에 따라 바뀔 수 있습니다. 화면 하단 안내와 `/help`를 우선합니다.

참고: [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli), [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
