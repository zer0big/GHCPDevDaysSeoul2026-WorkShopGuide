# 레슨 9 - 작업 사이클을 신뢰하게 된 뒤 위임하기

`/delegate`는 작업을 GitHub의 **Copilot 클라우드 에이전트**에게 넘깁니다. 클라우드 에이전트가 브랜치를 만들고 Draft PR을 열어 백그라운드에서 작업하므로, 그동안 나는 다른 일을 할 수 있습니다. 결과는 PR로 돌아오고, **검토하고 병합하는 것은 사람**입니다.

이번에는 **공유 가능한 미션 리포트 기능**을 위임하고, 완성된 PR을 검토한 뒤 병합합니다.

> **사전 조건**: `/delegate`를 사용할 수 있는 Copilot 플랜이 필요합니다. 조직 계정은 관리자 정책에 따라 제한될 수 있습니다. 사용할 수 없으면 이 레슨은 읽기로 대신하고 [레슨 10](10-review.md)으로 넘어갑니다.

> 이 레슨의 명령은 별도 안내가 없으면 **Copilot CLI 입력창**에 입력합니다. 터미널에서 실행하는 명령은 "터미널에서"라고 표시합니다.

---

## 9-1. 원래 프로젝트 폴더를 최신 `main`으로 맞추기

**새 터미널**을 열고, 워크트리가 아닌 **원래 프로젝트 폴더**로 이동합니다.

```powershell
# Windows
cd "$HOME\space-quiz"
git status
```

```bash
# macOS / Linux
cd ~/space-quiz
git status
```

같은 터미널에서, 레슨 4의 첫 번째 이슈 변경이 미커밋 상태로 남아 있으면 **임시 보관**합니다. 작업은 삭제되지 않습니다.

```bash
git stash push -m "Save local work before delegation"
```

터미널에서 `main`으로 이동하고 최신 코드를 받습니다.

```bash
git switch main
git pull --ff-only
git status
```

**`On branch main` 과 `working tree clean`** 이 보이면 터미널에서 Copilot CLI를 실행합니다.

```bash
copilot
```

## 9-2. 새 기능 위임

```text
/delegate 우주 퀴즈에 공유 가능한 ‘미션 리포트’ 기능을 추가해 주세요. 퀴즈가 끝나면 점수, 정답률에 따른 등급 칭호, 가장 오래 걸린 문항을 담은 간결한 요약 카드를 표시해 주세요. 결과를 짧은 텍스트로 클립보드에 복사하는 버튼도 추가해 주세요. 외부 의존성 없이 단일 index.html 파일에서 구현하고, 키보드만으로 모든 기능을 사용할 수 있도록 해 주세요. 기존 퀴즈 기능은 유지하고, PR 설명에 변경 사항과 테스트 결과를 정리해 주세요.
```

Enter를 누른 뒤 다음 순서로 진행합니다.

| 순서 | 화면에서 확인할 것 | 다음 행동 |
| --- | --- | --- |
| 1 | 위임 시작 메시지와 **PR 링크·에이전트 세션 링크** | 9-3의 `!gh pr list` 실행 |
| 2 | 링크 대신 `Session not found` 등 오류 | 같은 요청을 반복하지 말고 1분 뒤 `!gh pr list` 로 PR 생성 여부 확인 |

## 9-3. 위임한 작업 확인

**9-2에서 PR 링크가 표시된 직후** 실행합니다.

```text
!gh pr list
```

`[WIP] Add mission report ...` 처럼 **Draft** 또는 **[WIP]** 로 표시된 PR을 찾아 **PR 번호(N)를 기록**합니다. 이 번호는 9-4~9-6에서 사용합니다.

### 기다리는 동안 할 일: 검토 체크리스트 만들기

위임 작업은 클라우드에서 진행되므로 로컬 CLI는 비어 있어도 정상입니다. 그동안 9-5에서 직접 테스트할 체크리스트를 Copilot에게 미리 받아 둡니다.

1. `Ctrl+N` 으로 새 세션을 엽니다.
2. 새 세션 입력창에 다음을 입력합니다. (`N` 은 기록한 PR 번호)

   ```text
   PR #N(미션 리포트)의 현재 변경 내용을 확인해, 내가 브라우저에서 직접 테스트할 검토 체크리스트를 기능·접근성·회귀 항목으로 나눠 만들어 주세요. 파일은 변경하지 마세요.
   ```

3. 받은 체크리스트를 9-5 로컬 테스트에서 사용합니다.

### 진행 상황 확인

- GitHub 저장소의 **Agents** 탭에서 해당 세션을 열면 진행 로그를 볼 수 있습니다. 목록에는 클라우드 작업(구름 아이콘)과 로컬 세션(터미널 아이콘)이 함께 표시되며, 로컬 세션의 **Needs attention** 은 위임 작업과 관계없습니다.
- 구현 커밋이 먼저 올라오고, 이후 자체 검증·PR 설명 정리 등 마무리 단계가 더 걸릴 수 있습니다. 커밋 진행은 다음으로 확인합니다.

  ```text
  !git fetch origin
  !git log origin/copilot/add-mission-report-feature --oneline -5
  ```

  (브랜치 이름은 `!gh pr list` 결과의 브랜치를 사용합니다.)
- 작업이 끝나면 PR 제목에서 `[WIP]` 가 빠지고 리뷰 요청 알림이 옵니다. 그때 9-4로 진행합니다.
- 로그가 같은 단계에서 오래 멈춰 있으면 Agents 탭에서 세션을 중지한 뒤 9-4로 진행합니다. **세션이 끝나거나 중지되기 전에는 병합하지 않습니다.**

## 9-4. 완성된 PR 검토

작업 완료 안내가 나오면 PR 페이지를 엽니다.

```text
!gh pr view N --web
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
!gh pr ready N
```

병합하고 작업 브랜치를 정리합니다.

```text
!gh pr merge N --squash --delete-branch
```

| 옵션 | 의미 |
| --- | --- |
| `--squash` | PR의 변경을 하나의 커밋으로 합쳐 병합 |
| `--delete-branch` | 병합 후 작업 브랜치 삭제 |

최종 상태를 확인합니다.

```text
!gh pr view N --json state
!git status --short --branch
```

`{"state":"MERGED"}` 가 나오면 완료입니다.

---

## 체크포인트

- [ ] 위임한 PR을 직접 검토·테스트했다.
- [ ] PR이 `MERGED` 상태다.

다음: [레슨 10 - 복습 및 다음 단계](10-review.md)

---

참고: [Delegating tasks to Copilot](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/delegate-tasks-to-cca)
