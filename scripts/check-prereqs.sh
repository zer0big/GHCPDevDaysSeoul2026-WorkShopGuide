#!/usr/bin/env bash
# GitHub Copilot CLI 첫걸음 핸즈온 사전 점검 (macOS / Linux)
# 실습에 필요한 도구가 설치되어 있는지 확인합니다. 아무것도 설치하거나 변경하지 않습니다.
#
# 사용법: bash ./scripts/check-prereqs.sh

set -u

fail_count=0
warn_count=0

if [ -t 1 ]; then
  C_OK=$'\033[32m'; C_WARN=$'\033[33m'; C_FAIL=$'\033[31m'; C_INFO=$'\033[36m'; C_RESET=$'\033[0m'
else
  C_OK=''; C_WARN=''; C_FAIL=''; C_INFO=''; C_RESET=''
fi

result() {
  # $1=status $2=item $3=detail
  local status="$1" item="$2" detail="${3:-}" color label
  case "$status" in
    OK)   label='[ OK ]'; color="$C_OK" ;;
    WARN) label='[WARN]'; color="$C_WARN"; warn_count=$((warn_count + 1)) ;;
    FAIL) label='[FAIL]'; color="$C_FAIL"; fail_count=$((fail_count + 1)) ;;
    *)    label='[INFO]'; color="$C_INFO" ;;
  esac
  printf '%s%s %s: %s%s\n' "$color" "$label" "$item" "$detail" "$C_RESET"
}

version_of() {
  "$@" 2>&1 | head -n 1
}

echo
echo "GitHub Copilot CLI 첫걸음 - 사전 점검"
echo "------------------------------------------------------------"

# 1. Git
if command -v git >/dev/null 2>&1; then
  result OK "Git" "$(version_of git --version)"
  git_name="$(git config --global user.name 2>/dev/null || true)"
  git_mail="$(git config --global user.email 2>/dev/null || true)"
  if [ -z "$git_name" ] || [ -z "$git_mail" ]; then
    result WARN "Git 작성자 정보" "user.name / user.email 미설정 (레슨 3-0 참고)"
  else
    result OK "Git 작성자 정보" "$git_name <$git_mail>"
  fi
else
  result FAIL "Git" "미설치: macOS 'brew install git' / Linux 패키지 관리자"
fi

# 2. GitHub CLI
if command -v gh >/dev/null 2>&1; then
  result OK "GitHub CLI (gh)" "$(version_of gh --version)"
  if gh auth status --hostname github.com >/dev/null 2>&1; then
    result OK "gh 로그인" "github.com 인증됨"
  else
    result WARN "gh 로그인" "미로그인: gh auth login"
  fi
else
  result WARN "GitHub CLI (gh)" "미설치(권장): macOS 'brew install gh'"
fi

# 3. Copilot CLI
if command -v copilot >/dev/null 2>&1; then
  result OK "Copilot CLI" "$(version_of copilot --version)"
else
  result FAIL "Copilot CLI" "미설치: 'brew install --cask copilot-cli' 또는 'curl -fsSL https://gh.io/copilot-install | bash'"
fi

# 4. Node.js (npm 으로 Copilot CLI 를 설치하는 경우에만 필요)
if command -v node >/dev/null 2>&1; then
  result INFO "Node.js (선택)" "$(version_of node --version)"
else
  result INFO "Node.js (선택)" "없음 - Homebrew/스크립트 설치 시 필요 없음"
fi

# 5. 브라우저 열기 명령
if command -v open >/dev/null 2>&1; then
  result OK "브라우저 열기" "open"
elif command -v xdg-open >/dev/null 2>&1; then
  result OK "브라우저 열기" "xdg-open"
else
  result WARN "브라우저 열기" "open / xdg-open 없음 - index.html 을 직접 브라우저로 여세요"
fi

# 6. 자동 승인 환경 변수 경고
if [ -n "${COPILOT_ALLOW_ALL:-}" ]; then
  result WARN "COPILOT_ALLOW_ALL" "설정됨 - 실습 중에는 해제 권장: unset COPILOT_ALLOW_ALL"
fi

echo "------------------------------------------------------------"
if [ "$fail_count" -gt 0 ]; then
  echo "${C_FAIL}필수 항목 ${fail_count}개 실패. docs/00-prerequisites.md 를 참고해 설치 후 다시 실행하세요.${C_RESET}"
  exit 1
elif [ "$warn_count" -gt 0 ]; then
  echo "${C_WARN}필수 항목 통과, 경고 ${warn_count}개. 경고 항목도 가능하면 해결하세요.${C_RESET}"
  exit 0
else
  echo "${C_OK}모든 항목 통과. 다음: scripts/new-workspace.sh${C_RESET}"
  exit 0
fi
