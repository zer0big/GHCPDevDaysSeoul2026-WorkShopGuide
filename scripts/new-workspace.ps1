#Requires -Version 6.0
<#
.SYNOPSIS
  홈 폴더 아래에 실습 폴더(space-quiz)를 만듭니다. (Windows / PowerShell 7)

.DESCRIPTION
  - 시스템 폴더(C:\Windows\System32 등)에 실습 파일이 생기지 않도록 $HOME 아래에 만듭니다.
  - 이미 파일이 있는 폴더는 건드리지 않고, 다른 이름을 쓰도록 안내합니다.
  - 아무것도 삭제하지 않습니다.

.PARAMETER Name
  실습 폴더 이름. 기본값 space-quiz

.EXAMPLE
  pwsh -ExecutionPolicy Bypass -File .\scripts\new-workspace.ps1
  pwsh -ExecutionPolicy Bypass -File .\scripts\new-workspace.ps1 -Name space-quiz-2
#>
param(
    [ValidatePattern('^[A-Za-z0-9._-]+$')]
    [string] $Name = 'space-quiz'
)

$ErrorActionPreference = 'Stop'

$workspace = Join-Path $HOME $Name

if (Test-Path -LiteralPath $workspace) {
    $existing = Get-ChildItem -LiteralPath $workspace -Force -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "[WARN] $workspace 폴더가 이미 있고 비어 있지 않습니다." -ForegroundColor Yellow
        Write-Host "       기존 파일은 그대로 둡니다. 새로 시작하려면 다른 이름을 지정하세요:" -ForegroundColor Yellow
        Write-Host "       pwsh -ExecutionPolicy Bypass -File .\scripts\new-workspace.ps1 -Name $Name-2"
        exit 1
    }
    Write-Host "[ OK ] 빈 폴더가 이미 있습니다: $workspace" -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Path $workspace | Out-Null
    Write-Host "[ OK ] 실습 폴더를 만들었습니다: $workspace" -ForegroundColor Green
}

# 상위 폴더가 Git 저장소 안이면 레슨 3의 git init 이 혼동될 수 있으므로 경고
if (Get-Command git -ErrorAction SilentlyContinue) {
    & git -C $workspace rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[WARN] 이 폴더가 다른 Git 저장소 안에 있습니다. 다른 위치를 쓰는 것을 권장합니다." -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host '다음 명령을 그대로 실행하세요:' -ForegroundColor White
Write-Host "  Set-Location `"$workspace`""
Write-Host '  copilot'
Write-Host ''
Write-Host '폴더 신뢰 질문이 나오면 2번(이 폴더를 계속 신뢰)을 선택합니다. 자세한 내용: docs/00-prerequisites.md'
