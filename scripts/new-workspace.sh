#!/usr/bin/env bash
# 홈 폴더 아래에 실습 폴더(space-quiz)를 만듭니다. (macOS / Linux)
# - 이미 파일이 있는 폴더는 건드리지 않고, 다른 이름을 쓰도록 안내합니다.
# - 아무것도 삭제하지 않습니다.
#
# 사용법: bash ./scripts/new-workspace.sh [폴더이름]
#   예)   bash ./scripts/new-workspace.sh space-quiz-2

set -euo pipefail

name="${1:-space-quiz}"

case "$name" in
  *[!A-Za-z0-9._-]* | "" | . | ..)
    echo "[FAIL] 폴더 이름은 영문, 숫자, '.', '_', '-' 만 사용할 수 있습니다: $name" >&2
    exit 1
    ;;
esac

workspace="$HOME/$name"

if [ -d "$workspace" ]; then
  if [ -n "$(ls -A "$workspace" 2>/dev/null)" ]; then
    echo "[WARN] $workspace 폴더가 이미 있고 비어 있지 않습니다."
    echo "       기존 파일은 그대로 둡니다. 새로 시작하려면 다른 이름을 지정하세요:"
    echo "       bash ./scripts/new-workspace.sh ${name}-2"
    exit 1
  fi
  echo "[ OK ] 빈 폴더가 이미 있습니다: $workspace"
elif [ -e "$workspace" ]; then
  echo "[FAIL] 같은 이름의 파일이 있습니다: $workspace" >&2
  exit 1
else
  mkdir -p "$workspace"
  echo "[ OK ] 실습 폴더를 만들었습니다: $workspace"
fi

# 상위 폴더가 Git 저장소 안이면 레슨 3의 git init 이 혼동될 수 있으므로 경고
if command -v git >/dev/null 2>&1 && git -C "$workspace" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[WARN] 이 폴더가 다른 Git 저장소 안에 있습니다. 다른 위치를 쓰는 것을 권장합니다."
fi

echo
echo "다음 명령을 그대로 실행하세요:"
echo "  cd \"$workspace\""
echo "  copilot"
echo
echo "폴더 신뢰 질문이 나오면 2번(이 폴더를 계속 신뢰)을 선택합니다. 자세한 내용: docs/00-prerequisites.md"
