# GitHub Copilot CLI 첫걸음 핸즈온 키트

빈 폴더에서 시작해 **Space Quiz**(우주 퀴즈) 웹페이지를 만들고, GitHub에 게시하고, 이슈를 병렬로 구현하고, 풀 리퀘스트(PR)로 병합한 뒤, 마지막으로 클라우드 에이전트에게 새 기능을 위임합니다. 모든 과정을 **터미널을 벗어나지 않고** GitHub Copilot CLI로 진행합니다.

- 소요 시간: 약 90분
- 대상: Copilot CLI를 처음 사용하는 분 (개발 경험 없어도 됩니다)
- 결과물: 내 GitHub 계정의 공개 저장소 `space-quiz-workshop-demo` (이름은 바꿔도 됩니다)

> 이 키트 저장소는 **안내서**입니다. 실습 프로젝트는 이 저장소 안이 아니라, 홈 폴더 아래 별도 폴더(`space-quiz`)에서 진행합니다. 레슨 3에서 그 폴더를 새 Git 저장소로 만들기 때문입니다.

---

## 1. 시작하기

**모든 참가자는 [레슨 0 - 사전 준비 및 설정](docs/00-prerequisites.md)부터 순서대로 진행합니다.** 도구 설치, 키트 받기, 사전 점검, 실습 폴더 만들기가 모두 레슨 0에 있습니다.

> Git, PowerShell 7(Windows), Copilot CLI가 이미 설치되어 있다면 [0-5. 키트 받기](docs/00-prerequisites.md#0-5-키트-받기-clone)부터 시작해도 됩니다.

---

## 2. 레슨 순서

| 레슨 | 주제 | 하는 일 | 시간 |
| --- | --- | --- | --- |
| [0. 사전 준비 및 설정](docs/00-prerequisites.md) | 설정 | 설치, 로그인, 폴더 신뢰, 모델 선택 | 10분 |
| [1. 퀴즈 만들기](docs/01-build.md) | 빌드 | 한 번의 요청으로 퀴즈 생성, 한 가지만 수정 | 10분 |
| [2. 프로젝트 지침](docs/02-project-instructions.md) | 지침 | `/init`으로 작업 규칙 기록 | 5분 |
| [3. 프로젝트 게시](docs/03-publish.md) | 게시 | 첫 커밋, GitHub 공개 저장소에 푸시 | 10분 |
| [4. 이슈 병렬 작업](docs/04-issues-and-sessions.md) | 구현 | 이슈 3개 생성, 1번 구현, `/diff` 검토, `/worktree` | 15분 |
| [5. 편집 전에 계획](docs/05-plan-mode.md) | 계획 | `/plan`으로 2번 이슈 계획 후 구현 | 10분 |
| [6. 컨텍스트 관리](docs/06-context.md) | 컨텍스트 | `/context`, `/compact`, `/clear` | 5분 |
| [7. 세션 재개와 원격](docs/07-resume-and-remote.md) | 재개 | `copilot --resume`, `/resume`, `/remote`(선택) | 5분 |
| [8. PR 생성·검토·병합](docs/08-pull-request.md) | 검토 | `/pr create`, `/pr agentmerge` | 10분 |
| [9. 작업 위임](docs/09-delegate.md) | 위임 | `/delegate`로 클라우드에 새 기능 위임 후 병합 | 10분 |
| [10. 복습](docs/10-review.md) | 복습 | 정리, 실습 리소스 정리, 다음 학습 | - |

## 3. 함께 보는 자료

| 문서 | 용도 |
| --- | --- |
| [PROMPTS.md](PROMPTS.md) | 레슨별 프롬프트 모음 (복사해서 붙여넣기) |
| [CHEATSHEET.md](CHEATSHEET.md) | 슬래시 명령·단축키 한 장 요약 |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | 자주 발생하는 오류와 해결 방법 |

## 4. 표기 규칙

모든 코드 블록은 복사 버튼으로 그대로 붙여 넣어 실행할 수 있습니다. 어디에서 실행하는지는 블록 위 문장이나 블록 첫 줄 주석으로 표시합니다.

| 표시 | 입력하는 곳 |
| --- | --- |
| `# Windows (PowerShell 7)` | PowerShell 7 터미널 |
| `# macOS / Linux` | 기본 터미널 (bash, zsh) |
| 레슨 1~9에서 별도 안내가 없는 명령 | Copilot CLI 입력창 (`copilot` 실행 후) |
| "터미널에서"라고 안내한 명령 | PowerShell 7 또는 기본 터미널 |
| `!` 로 시작하는 명령 | Copilot CLI 입력창에서 셸 명령을 바로 실행 (`!git status` 등) |

## 5. 이 실습에서 지킬 세 가지

1. **실습 폴더(`space-quiz`)에서만 `copilot`을 실행합니다.** 홈 폴더나 `C:\Windows\System32` 같은 시스템 폴더에서 실행하지 않습니다.
2. **승인 요청은 읽고 나서 선택합니다.** `2. Yes, and approve ... for the rest of the running session`은 그 세션 동안 해당 도구를 다시 묻지 않고 사용하게 합니다.
3. **자동 승인 옵션은 쓰지 않습니다.** `--allow-all-tools`, `/yolo`, `COPILOT_ALLOW_ALL` 등은 실습에서 사용하지 않습니다.

## 6. 출처

- 원본 워크숍: [GitHub Copilot CLI 첫걸음 - Copilot Workshops](https://github-samples.github.io/copilot-workshops/ko-kr/first-steps/copilot-cli/) (James Montemagno 원작, MIT License)
- 공식 문서: [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli), [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
- 자세한 고지는 [NOTICE.md](NOTICE.md)를 참고합니다.
