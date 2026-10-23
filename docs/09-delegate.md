# 레슨 9 - 작업 사이클을 신뢰하게 된 뒤 위임하기

`/delegate`는 작업을 GitHub의 **Copilot 클라우드 에이전트**에게 넘깁니다. 클라우드 에이전트가 브랜치를 만들고 Draft PR을 열어 백그라운드에서 작업하므로, 그동안 나는 다른 일을 할 수 있습니다. 결과는 PR로 돌아오고, **검토하고 병합하는 것은 사람**입니다.

이번에는 **공유 가능한 미션 리포트 기능**을 위임하고, 완성된 PR을 검토한 뒤 병합합니다.

> **사전 조건**: `/delegate`를 사용할 수 있는 Copilot 플랜이 필요합니다. 조직 계정은 관리자 정책에 따라 제한될 수 있습니다. 사용할 수 없으면 이 레슨은 읽기로 대신하고 [레슨 10](10-review.md)으로 넘어갑니다.

---

## 9-1. 원래 프로젝트 폴더를 최신 `main`으로 맞추기

**새 터미널**을 열고, 워크트리가 아닌 **원래 프로젝트 폴더**로 이동합니다.

```powershell
# Windows
PS> cd "$HOME\space-quiz"
PS> git status
```

```bash
# macOS / Linux
$ cd ~/space-quiz
$ git status
```

레슨 4의 첫 번째 이슈 변경이 미커밋 상태로 남아 있으면 **임시 보관**합니다. 작업은 삭제되지 않습니다.

```bash
git stash push -m "Save local work before delegation"
```

`main`으로 이동하고 최신 코드를 받습니다.

```bash
git switch main
git pull --ff-only
git status
```

**`On branch main` 과 `working tree clean`** 이 보이면 Copilot CLI를 실행합니다.

```bash
copilot
```

## 9-2. 새 기능 위임

```text
/delegate 우주 퀴즈에 공유 가능한 ‘미션 리포트’ 기능을 추가해 주세요. 퀴즈가 끝나면 점수, 정답률에 따른 등급 칭호, 가장 오래 걸린 문항을 담은 간결한 요약 카드를 표시해 주세요. 결과를 짧은 텍스트로 클립보드에 복사하는 버튼도 추가해 주세요. 외부 의존성 없이 단일 index.html 파일에서 구현하고, 키보드만으로 모든 기능을 사용할 수 있도록 해 주세요. 기존 퀴즈 기능은 유지하고, PR 설명에 변경 사항과 테스트 결과를 정리해 주세요.
```

위임이 시작되면 PR과 에이전트 세션 링크가 표시됩니다. `Ctrl+N`으로 새 세션을 열어 다른 작업을 계속합니다.

## 9-3. 위임한 작업 확인

```text
copilot> !gh pr list
```

미션 리포트 PR을 찾아 **PR 번호(N)를 기록**합니다. 작업 중에는 **Draft** 또는 **[WIP]** 로 표시됩니다.

> 위임 직후 `Session not found`가 나와도 같은 요청을 바로 반복하지 말고, 먼저 `!gh pr list`로 PR이 생성됐는지 확인합니다.

기다리는 동안 파일을 바꾸지 않는 작업을 요청해 봅니다.

```text
위임한 미션 리포트 기능의 검토 체크리스트를 만들어 주세요. 파일은 변경하지 마세요.
```

## 9-4. 완성된 PR 검토

작업 완료 안내가 나오면 PR 페이지를 엽니다.

```text
copilot> !gh pr view N --web
```

- 병합 대상이 `main`인가
- 요청과 무관한 변경이 없는가
- PR 설명에 변경 사항과 테스트 결과가 있는가

> **Ready for review는 검토할 준비가 됐다는 뜻이지, 테스트 통과를 보장하지 않습니다.**

## 9-5. 로컬에서 실행해 확인

PR 브랜치로 이동한 뒤 퀴즈를 엽니다. **한 줄씩** 실행합니다.

```text
!gh pr checkout N
!start index.html
```

(macOS는 `!open index.html`, Linux는 `!xdg-open index.html`)

- [ ] 점수, 등급 칭호, 가장 오래 걸린 문항이 표시된다.
- [ ] 결과 복사 버튼을 누른 뒤 메모장에 붙여넣으면 요약 텍스트가 나온다.
- [ ] 기존 퀴즈 기능이 정상이다.
- [ ] `Tab`으로 버튼에 이동하고 `Enter` 또는 `Space`로 실행할 수 있다.

문제가 있으면 PR에 구체적인 수정 요청을 남기고, 수정 후 다시 확인합니다.

## 9-6. PR 병합

PR이 아직 **Draft** 라면 초안 상태를 해제합니다.

```text
copilot> !gh pr ready N
```

병합하고 작업 브랜치를 정리합니다.

```text
copilot> !gh pr merge N --squash --delete-branch
```

| 옵션 | 의미 |
| --- | --- |
| `--squash` | PR의 변경을 하나의 커밋으로 합쳐 병합 |
| `--delete-branch` | 병합 후 작업 브랜치 삭제 |

최종 상태를 확인합니다.

```text
copilot> !gh pr view N --json state
copilot> !git status --short --branch
```

`{"state":"MERGED"}` 가 나오면 완료입니다.

---

## 체크포인트

- [ ] 위임한 PR을 직접 검토·테스트했다.
- [ ] PR이 `MERGED` 상태다.

다음: [레슨 10 - 복습 및 다음 단계](10-review.md)

---

참고: [Delegating tasks to Copilot](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/delegate-tasks-to-cca)
