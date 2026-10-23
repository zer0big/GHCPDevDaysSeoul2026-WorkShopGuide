<#
.SYNOPSIS
  GitHub Copilot CLI 첫걸음 핸즈온 사전 점검 (Windows / PowerShell 7)

.DESCRIPTION
  실습에 필요한 도구가 설치되어 있는지 확인합니다. 아무것도 설치하거나 변경하지 않습니다.
  Windows PowerShell 5.1 에서도 실행되며, 이 경우 PowerShell 7 설치가 필요하다고 알려 줍니다.

.EXAMPLE
  pwsh -ExecutionPolicy Bypass -File .\scripts\check-prereqs.ps1
#>

$ErrorActionPreference = 'Continue'
$script:failCount = 0
$script:warnCount = 0

function Write-Result {
    param(
        [ValidateSet('OK', 'WARN', 'FAIL', 'INFO')] [string] $Status,
        [string] $Item,
        [string] $Detail = ''
    )
    $label = switch ($Status) {
        'OK'   { '[ OK ]' }
        'WARN' { '[WARN]' }
        'FAIL' { '[FAIL]' }
        'INFO' { '[INFO]' }
    }
    $color = switch ($Status) {
        'OK'   { 'Green' }
        'WARN' { 'Yellow' }
        'FAIL' { 'Red' }
        'INFO' { 'Cyan' }
    }
    if ($Status -eq 'FAIL') { $script:failCount++ }
    if ($Status -eq 'WARN') { $script:warnCount++ }
    Write-Host ("{0} {1}: {2}" -f $label, $Item, $Detail) -ForegroundColor $color
}

function Get-ToolVersion {
    param([string] $Command, [string[]] $Arguments = @('--version'))
    try {
        $output = & $Command @Arguments 2>&1 | Select-Object -First 1
        return ($output | Out-String).Trim()
    } catch {
        return ''
    }
}

Write-Host ''
Write-Host 'GitHub Copilot CLI 첫걸음 - 사전 점검' -ForegroundColor White
Write-Host '------------------------------------------------------------'

# 1. PowerShell 버전 (Copilot CLI는 Windows에서 PowerShell 6 이상 필요, 실습은 7 권장)
$psv = $PSVersionTable.PSVersion
if ($psv.Major -ge 7) {
    Write-Result OK 'PowerShell' "$psv"
} elseif ($psv.Major -ge 6) {
    Write-Result WARN 'PowerShell' "$psv (동작은 하지만 PowerShell 7 권장)"
} else {
    Write-Result FAIL 'PowerShell' "$psv (PowerShell 7 설치 후 pwsh 에서 다시 실행)"
}

# 2. Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Result OK 'Git' (Get-ToolVersion git)
    $gitName = (& git config --global user.name 2>$null)
    $gitMail = (& git config --global user.email 2>$null)
    if ([string]::IsNullOrWhiteSpace($gitName) -or [string]::IsNullOrWhiteSpace($gitMail)) {
        Write-Result WARN 'Git 작성자 정보' 'user.name / user.email 미설정 (레슨 3-0 참고)'
    } else {
        Write-Result OK 'Git 작성자 정보' "$gitName <$gitMail>"
    }
} else {
    Write-Result FAIL 'Git' '미설치: winget install --id Git.Git -e --source winget'
}

# 3. GitHub CLI
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Result OK 'GitHub CLI (gh)' (Get-ToolVersion gh)
    & gh auth status --hostname github.com *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Result OK 'gh 로그인' 'github.com 인증됨'
    } else {
        Write-Result WARN 'gh 로그인' '미로그인: gh auth login'
    }
} else {
    Write-Result WARN 'GitHub CLI (gh)' '미설치(권장): winget install --id GitHub.cli -e --source winget'
}

# 4. Copilot CLI
if (Get-Command copilot -ErrorAction SilentlyContinue) {
    Write-Result OK 'Copilot CLI' (Get-ToolVersion copilot)
} else {
    Write-Result FAIL 'Copilot CLI' '미설치: winget install GitHub.Copilot (설치 후 터미널 새로 열기)'
}

# 5. Node.js (npm 으로 Copilot CLI 를 설치하는 경우에만 필요)
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Result INFO 'Node.js (선택)' (Get-ToolVersion node)
} else {
    Write-Result INFO 'Node.js (선택)' '없음 - winget 설치 시 필요 없음'
}

# 6. 자동 승인 환경 변수 경고
if ($env:COPILOT_ALLOW_ALL) {
    Write-Result WARN 'COPILOT_ALLOW_ALL' '설정됨 - 실습 중에는 해제 권장: Remove-Item Env:COPILOT_ALLOW_ALL'
}

Write-Host '------------------------------------------------------------'
if ($script:failCount -gt 0) {
    Write-Host ("필수 항목 {0}개 실패. docs/00-prerequisites.md 를 참고해 설치 후 다시 실행하세요." -f $script:failCount) -ForegroundColor Red
    exit 1
} elseif ($script:warnCount -gt 0) {
    Write-Host ("필수 항목 통과, 경고 {0}개. 경고 항목도 가능하면 해결하세요." -f $script:warnCount) -ForegroundColor Yellow
    exit 0
} else {
    Write-Host '모든 항목 통과. 다음: scripts/new-workspace.ps1' -ForegroundColor Green
    exit 0
}
