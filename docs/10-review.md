# 레슨 10 - 복습 및 다음 단계

터미널을 벗어나지 않고 퀴즈를 만들고, 검토하고, 게시하고, 세션을 병렬로 실행하고, 계획을 세우고, 세션을 재개하고, PR을 병합하고, 새 작업을 위임했습니다.

## 10-1. 완료한 작업

| 레슨 | 사용한 명령 | 익힌 원칙 |
| --- | --- | --- |
| 0 | `copilot`, `/login`, `/model` | 신뢰하는 실습 폴더에서만 실행한다 |
| 1 | 한 번의 상세 요청, 범위 한정 수정 | 승인 요청은 읽고 선택한다 |
| 2 | `/init` | 반복할 규칙은 지침으로 기록한다 |
| 3 | `git commit`, `gh repo create` | 첫 커밋이 비교의 기준선이다 |
| 4 | 사이드 패널, `/diff`, `/worktree` | 검토 후 기록하고, 병렬 작업은 격리한다 |
| 5 | `/plan` | 편집 전에 접근 방식을 합의한다 |
| 6 | `/context`, `/compact`, `/clear` | 에이전트가 보는 것을 관리한다 |
| 7 | `copilot --resume`, `/resume`, `/remote` | 대화를 다시 설명하지 않고 이어간다 |
| 8 | `/pr create`, `/pr agentmerge` | 셸 안에서 PR 사이클을 끝낸다 |
| 9 | `/delegate`, `gh pr merge` | 신뢰가 쌓이면 위임하고, 병합은 사람이 결정한다 |

> **한 문장 요약**: 작게 요청하고, 검토하고, 기록한다. 신뢰가 쌓이면 위임한다.

## 10-2. 실습 리소스 정리 (선택)

실습 저장소를 계속 보관해도 됩니다. 정리하려면 다음을 참고합니다.

- **레슨 4의 임시 보관 변경 삭제**: 실습 폴더에서 `git stash list`로 확인 후 `git stash drop`
- **워크트리 목록 확인**: `git worktree list` (필요 없으면 `git worktree remove <경로>`)
- **GitHub 저장소 삭제**: 브라우저에서 저장소 **Settings → General → Danger Zone → Delete this repository**
- **로컬 실습 폴더 삭제**: `space-quiz` 폴더를 파일 탐색기에서 직접 삭제

> 삭제는 되돌릴 수 없습니다. 삭제 대상 이름을 한 번 더 확인합니다.

## 10-3. 계속 학습하기

- [Copilot CLI 설치 (macOS, Windows, Linux)](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)
- [Copilot CLI best practices](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-best-practices)
- [Copilot 모범 사례](https://docs.github.com/en/copilot/get-started/best-practices)
- 같은 Space Quiz를 다른 도구로: [Copilot app 첫걸음](https://github-samples.github.io/copilot-workshops/ko-kr/first-steps/copilot-app/), [VS Code 첫걸음](https://github-samples.github.io/copilot-workshops/ko-kr/first-steps/vscode/)
- 심화 과정: [실전 Copilot CLI 워크숍](https://github-samples.github.io/copilot-workshops/ko-kr/real-world-development/cli/)
