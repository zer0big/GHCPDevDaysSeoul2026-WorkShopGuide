#Requires -Version 6.0
<#
.SYNOPSIS
  지정한 폴더를 Copilot CLI 의 신뢰 폴더(trustedFolders)에 추가합니다. (Windows / PowerShell 7)

.DESCRIPTION
  /worktree 실행 시 "The queued prompt ... is waiting" 상태로 멈추는 경우 등에 사용하는 우회 방법입니다.
  - 공식 문서상 신뢰 폴더는 config.json 의 trustedFolders 배열에 저장되며, 이 배열을 편집해 추가할 수 있습니다.
  - config.json 은 CLI 가 자동 관리하는 파일이므로 실행 전 모든 Copilot CLI 세션을 종료해야 합니다.
  - 수정 전에 config.json.bak 으로 백업합니다.
  - COPILOT_ALLOW_ALL=true 처럼 모든 도구 권한을 자동 허용하는 방법보다 범위가 좁습니다.

.PARAMETER Path
  신뢰할 폴더. 기본값은 현재 폴더.

.EXAMPLE
  Set-Location "$HOME\space-quiz"
  pwsh -ExecutionPolicy Bypass -File <키트 경로>\scripts\add-trusted-folder.ps1

.LINK
  https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli
#>
param(
    [string] $Path = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

# 1. 실행 중인 Copilot CLI 확인
$running = Get-Process -Name 'copilot' -ErrorAction SilentlyContinue
if ($running) {
    Write-Host '[FAIL] 실행 중인 Copilot CLI 가 있습니다. 모든 세션에서 /exit 로 종료한 뒤 다시 실행하세요.' -ForegroundColor Red
    exit 1
}

# 2. 대상 폴더 확인
if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    Write-Host "[FAIL] 폴더가 없습니다: $Path" -ForegroundColor Red
    exit 1
}
$folder = (Resolve-Path -LiteralPath $Path).Path

$systemRoot = $env:SystemRoot
if ($systemRoot -and $folder.StartsWith($systemRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    Write-Host "[FAIL] 시스템 폴더는 신뢰 폴더로 추가하지 않습니다: $folder" -ForegroundColor Red
    exit 1
}
if ($folder.TrimEnd('\', '/') -eq $HOME.TrimEnd('\', '/')) {
    Write-Host "[FAIL] 홈 폴더 전체는 신뢰 폴더로 추가하지 않습니다. 실습 폴더를 지정하세요." -ForegroundColor Red
    exit 1
}

# 3. config.json 위치 (COPILOT_HOME 지원)
$copilotHome = if ($env:COPILOT_HOME) { $env:COPILOT_HOME } else { Join-Path $HOME '.copilot' }
$configPath = Join-Path $copilotHome 'config.json'

if (Test-Path -LiteralPath $configPath) {
    $raw = Get-Content -LiteralPath $configPath -Raw
    $config = if ([string]::IsNullOrWhiteSpace($raw)) { [pscustomobject]@{} } else { $raw | ConvertFrom-Json }
    Copy-Item -LiteralPath $configPath -Destination "$configPath.bak" -Force
    Write-Host "[ OK ] 백업: $configPath.bak" -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Path $copilotHome -Force | Out-Null
    $config = [pscustomobject]@{}
}

# 4. trustedFolders 에 추가
$trusted = @()
if ($config.PSObject.Properties.Name -contains 'trustedFolders') {
    $trusted = @($config.trustedFolders | Where-Object { $_ })
}
if ($trusted -contains $folder) {
    Write-Host "[ OK ] 이미 신뢰 폴더입니다: $folder" -ForegroundColor Green
    exit 0
}
$trusted += $folder
$config | Add-Member -NotePropertyName 'trustedFolders' -NotePropertyValue $trusted -Force

$config | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $configPath -Encoding utf8NoBOM

# 5. 결과 확인
Write-Host "[ OK ] 추가했습니다: $folder" -ForegroundColor Green
Write-Host '현재 trustedFolders:'
(Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json).trustedFolders | ForEach-Object { Write-Host "  $_" }
Write-Host ''
Write-Host '이제 copilot 을 실행하고 새 세션에서 /worktree 를 한 번만 시도하세요.'
