# 문제 해결

## 1. Windows PowerShell(5.1)에서 오류가 납니다

Copilot CLI는 Windows에서 PowerShell 6 이상이 필요합니다. PowerShell 7을 설치하고 `pwsh`로 전환합니다.

```powershell
winget install --id Microsoft.PowerShell --source winget
pwsh
$PSVersionTable.PSVersion   # Major 가 7 이면 정상
```

## 2. 실습 폴더가 `C:\Windows\System32\...` 아래에 생겼습니다

관리자 권한 터미널은 기본 위치가 시스템 폴더일 수 있습니다. 홈 폴더로 이동한 뒤 다시 만듭니다.

```powershell
Set-Location $HOME
New-Item -ItemType Directory -Path space-quiz -Force
Set-Location space-quiz
Get-Location
```

시스템 폴더에 잘못 만든 `space-quiz` 폴더는 내용 확인 후 직접 삭제합니다.

## 3. `copilot` 명령을 찾을 수 없습니다

- 설치 직후라면 **터미널을 닫고 새로 엽니다** (PATH 갱신).
- `winget list GitHub.Copilot` 으로 설치 여부를 확인합니다.
- 조직 계정이라면 관리자가 Copilot CLI 정책을 꺼 두었을 수 있습니다.

## 4. 사이드 패널에 Issues, Pull requests 탭이 비활성화됨

여러 GitHub 계정이나 GitHub Enterprise 호스트를 함께 쓰는 환경에서 발생할 수 있습니다. CLI를 종료하고 터미널에서 호스트를 지정한 뒤 다시 실행합니다.

**Windows (PowerShell)**

```powershell
$env:COPILOT_GH_HOST = 'https://github.com'
$env:GH_HOST = 'github.com'
copilot
```

**macOS / Linux**

```bash
export COPILOT_GH_HOST='https://github.com'
export GH_HOST='github.com'
copilot
```

`gh auth status`로 github.com에 로그인되어 있는지도 확인합니다.

## 5. /worktree가 queued prompt is waiting 상태로 멈춤

`The queued prompt "/worktree" is waiting...` 이 계속 표시되는 경우입니다. 현재 저장소 폴더가 신뢰 폴더로 저장되지 않았을 가능성이 있습니다.

> `COPILOT_ALLOW_ALL=true`는 폴더를 신뢰시키지만 **모든 도구 권한을 자동 허용**하므로 사용하지 않습니다.

범위를 좁힌 방법은 신뢰 폴더 목록(`config.json`의 `trustedFolders`)에 실습 폴더만 추가하는 것입니다.

1. 모든 Copilot CLI 세션을 `/exit`로 **완전히 종료**합니다.
2. 실습 폴더에서 키트의 스크립트를 실행합니다. (수정 전 `config.json.bak`으로 백업합니다.)

   ```powershell
   # Windows
   Set-Location "$HOME\space-quiz"
   pwsh -ExecutionPolicy Bypass -File <키트 경로>\scripts\add-trusted-folder.ps1
   ```

   ```bash
   # macOS / Linux
   cd ~/space-quiz
   bash <키트 경로>/scripts/add-trusted-folder.sh
   ```

3. `copilot`을 실행하고 새 세션에서 `/worktree`를 **한 번만** 시도합니다.

참고: [Configuring GitHub Copilot CLI - trusted directories](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli)

## 6. `/init`만 입력했더니 `Command input required`가 나옵니다

요청을 함께 입력합니다.

```text
/init 이 프로젝트에 맞는 간결한 작업 규칙을 작성해 주세요.
```

## 7. 커밋할 때 이름·이메일 오류가 납니다

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## 8. `gh repo create`에서 이름이 이미 있다고 나옵니다

이전 실습 저장소가 남아 있는 경우입니다. 저장소 이름을 `space-quiz-workshop-demo-2` 처럼 바꿔서 다시 요청합니다.

## 9. 이슈 번호가 #1, #2, #3이 아닙니다

같은 저장소를 재사용했거나 순서가 바뀐 경우입니다. `!gh issue list`로 **"퀴즈 문항 순서를 실행마다 섞기"** 이슈의 실제 번호를 확인하고, 레슨 5·8의 `#2`를 그 번호로 바꿉니다.

## 10. `/delegate` 직후 `Session not found`가 나옵니다

같은 요청을 바로 반복하지 않습니다. 먼저 PR이 만들어졌는지 확인합니다.

```text
!gh pr list
```

PR이 있으면 위임은 시작된 것입니다. PR도 없다면 플랜·조직 정책상 클라우드 에이전트 사용 가능 여부를 확인합니다.

## 11. `git pull --ff-only`가 실패합니다 (레슨 9)

로컬 `main`에 원격에 없는 커밋이나 미커밋 변경이 있는 경우입니다.

```bash
git status
git stash push -m "Save local work before delegation"   # 미커밋 변경이 있으면
git switch main
git pull --ff-only
```

## 12. 브라우저가 열리지 않습니다

파일 탐색기(Finder)에서 실습 폴더의 `index.html`을 더블클릭해 엽니다. 워크트리 세션이라면 워크트리 폴더의 `index.html`을 열어야 변경 사항이 보입니다. 현재 폴더는 `!pwd` (Windows는 `!Get-Location`)로 확인합니다.

## 13. 스크립트 실행이 차단됩니다 (Windows)

`-ExecutionPolicy Bypass`를 붙여 실행합니다. 이 옵션은 해당 실행에만 적용되며 시스템 설정을 바꾸지 않습니다.

```powershell
pwsh -ExecutionPolicy Bypass -File .\scripts\check-prereqs.ps1
```

인터넷에서 받은 zip을 푼 경우에는 `Unblock-File .\scripts\*.ps1`도 함께 실행합니다.
