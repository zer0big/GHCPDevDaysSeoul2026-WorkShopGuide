# 레슨 0 - 사전 준비 및 설정

Copilot CLI를 설치하고 로그인한 뒤, 빈 실습 폴더에서 첫 요청을 보낼 준비를 합니다.

**이 레슨에서 할 일**

- 필요한 계정과 도구를 확인합니다.
- Copilot CLI를 설치하고 로그인합니다.
- 실습 폴더를 만들고 신뢰하도록 설정합니다.
- 세션에서 사용할 모델을 선택합니다.

---

## 0-1. 준비물

| 항목 | 필수 여부 | 확인 방법 |
| --- | --- | --- |
| GitHub 계정 | 필수 | [가입](https://github.com/signup) |
| 활성화된 Copilot 플랜 (Free 포함) | 필수 | [플랜 비교](https://github.com/features/copilot/plans) |
| Git | 필수 | `git --version` |
| PowerShell 7 (Windows만) | 필수 | `$PSVersionTable.PSVersion` 가 7.x |
| GitHub CLI (`gh`) | 권장 (레슨 3·8·9에서 사용) | `gh --version` |
| 웹 브라우저 | 필수 | 퀴즈 확인용 |

> **조직 계정(Copilot Business / Enterprise)** 으로 참여하면 관리자가 조직 설정에서 **Copilot CLI 정책**을 켜 두어야 합니다. 레슨 9의 `/delegate`(클라우드 에이전트)는 플랜과 조직 정책에 따라 사용이 제한될 수 있습니다.

---

## 0-2. PowerShell 7 설치 (Windows)

Copilot CLI는 Windows에서 **PowerShell 6 이상**이 필요합니다. 기본 탑재된 Windows PowerShell 5.1에서는 오류가 발생하므로 PowerShell 7을 사용합니다.

```powershell
PS> winget install --id Microsoft.PowerShell --source winget
```

설치 후 **새 터미널**을 열고 PowerShell 7로 전환해 버전을 확인합니다.

```powershell
PS> pwsh
PS> $PSVersionTable.PSVersion
```

`Major` 가 `7` 이면 정상입니다. 이후 모든 Windows 명령은 이 PowerShell 7 창에서 실행합니다.

> Windows Terminal을 쓴다면 설정에서 기본 프로필을 **PowerShell**(검은 아이콘, 7.x)로 바꿔 두면 편합니다. 파란 아이콘의 **Windows PowerShell**은 5.1입니다.

---

## 0-3. Git, GitHub CLI 설치

이미 설치되어 있으면 건너뜁니다.

**Windows**

```powershell
PS> winget install --id Git.Git -e --source winget
PS> winget install --id GitHub.cli -e --source winget
```

**macOS**

```bash
$ brew install git gh
```

**Linux**: 배포판 패키지 관리자로 `git`을 설치하고, `gh`는 [GitHub CLI 설치 안내](https://github.com/cli/cli#installation)를 따릅니다.

설치 후 터미널을 새로 열고 GitHub CLI에 로그인합니다.

```bash
gh auth login
```

질문에는 `GitHub.com` → `HTTPS` → `Login with a web browser` 순으로 선택합니다.

---

## 0-4. Copilot CLI 설치

환경에 맞는 방법 **하나만** 선택합니다.

| 환경 | 명령 |
| --- | --- |
| Windows (권장) | `winget install GitHub.Copilot` |
| macOS / Linux (Homebrew) | `brew install --cask copilot-cli` |
| macOS / Linux (스크립트) | `curl -fsSL https://gh.io/copilot-install \| bash` |
| 모든 OS (npm, Node.js 22 이상) | `npm install -g @github/copilot` |

설치 후 **터미널을 새로 열고** 확인합니다.

```bash
copilot --version
```

---

## 0-5. 사전 점검 스크립트 실행

키트 저장소 폴더에서 실행합니다.

```powershell
# Windows
PS> pwsh -ExecutionPolicy Bypass -File .\scripts\check-prereqs.ps1
```

```bash
# macOS / Linux
$ bash ./scripts/check-prereqs.sh
```

모든 필수 항목이 `[ OK ]` 이면 다음 단계로 진행합니다.

---

## 0-6. 실습 폴더 만들기

시스템 폴더에 파일이 생기지 않도록 **홈 폴더 아래**에 실습 폴더를 만듭니다. 스크립트를 쓰거나 직접 만들어도 됩니다.

**스크립트 사용**

```powershell
# Windows
PS> pwsh -ExecutionPolicy Bypass -File .\scripts\new-workspace.ps1
```

```bash
# macOS / Linux
$ bash ./scripts/new-workspace.sh
```

**직접 만들기 (Windows)**

```powershell
PS> Set-Location $HOME
PS> New-Item -ItemType Directory -Path space-quiz -Force
PS> Set-Location space-quiz
PS> Get-Location
```

**직접 만들기 (macOS / Linux)**

```bash
$ mkdir -p ~/space-quiz && cd ~/space-quiz && pwd
```

`Get-Location` 또는 `pwd` 결과가 `...\space-quiz` 또는 `.../space-quiz` 인지 확인합니다. `C:\Windows\System32\...` 가 보이면 잘못된 위치입니다.

> 이미 `space-quiz` 폴더가 있고 이전 실습 파일이 남아 있다면, 폴더 이름을 `space-quiz-2` 처럼 바꿔서 새로 시작합니다.

---

## 0-7. Copilot CLI 실행, 로그인, 폴더 신뢰

실습 폴더에서 실행합니다.

```bash
copilot
```

1. 로그인하지 않았다면 안내에 따라 입력창에 `/login`을 입력하고 브라우저에서 인증합니다.
2. 폴더 신뢰 질문이 나오면 **2번**(이 폴더를 계속 신뢰)을 선택합니다. 이 폴더와 하위 폴더에서 Copilot이 파일을 읽고, 수정하고, 실행할 수 있게 됩니다.
3. 언제든 `/`를 입력하면 사용 가능한 명령 목록이, `/help`를 입력하면 전체 도움말이 표시됩니다.

---

## 0-8. 모델 선택

```text
copilot> /model
```

목록에서 **강사가 안내한 모델**을 선택하고 Enter를 누릅니다. 안내가 없다면 **Auto**를 선택합니다. 선택할 수 있는 모델은 플랜, 조직 정책, CLI 버전에 따라 다릅니다.

---

## 체크포인트

- [ ] `copilot`이 `space-quiz` 폴더에서 실행 중이다.
- [ ] 로그인되어 있고 폴더를 신뢰했다.
- [ ] `/model`로 모델을 선택했다.

다음: [레슨 1 - 퀴즈 만들기](01-build.md)

---

참고: [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli), [Install PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows)
