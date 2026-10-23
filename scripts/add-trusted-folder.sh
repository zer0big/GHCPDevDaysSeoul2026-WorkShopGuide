#!/usr/bin/env bash
# 지정한 폴더를 Copilot CLI 의 신뢰 폴더(trustedFolders)에 추가합니다. (macOS / Linux)
#
# /worktree 실행 시 "The queued prompt ... is waiting" 상태로 멈추는 경우 등에 사용하는 우회 방법입니다.
# - 공식 문서상 신뢰 폴더는 config.json 의 trustedFolders 배열에 저장됩니다.
# - config.json 은 CLI 가 자동 관리하는 파일이므로 실행 전 모든 Copilot CLI 세션을 종료해야 합니다.
# - 수정 전에 config.json.bak 으로 백업합니다. python3 가 필요합니다.
#
# 사용법: bash ./scripts/add-trusted-folder.sh [폴더경로]   (기본값: 현재 폴더)
# 참고:   https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/configure-copilot-cli

set -euo pipefail

target="${1:-$PWD}"

if pgrep -x copilot >/dev/null 2>&1; then
  echo "[FAIL] 실행 중인 Copilot CLI 가 있습니다. 모든 세션에서 /exit 로 종료한 뒤 다시 실행하세요." >&2
  exit 1
fi

if [ ! -d "$target" ]; then
  echo "[FAIL] 폴더가 없습니다: $target" >&2
  exit 1
fi
folder="$(cd "$target" && pwd -P)"

if [ "$folder" = "$(cd "$HOME" && pwd -P)" ] || [ "$folder" = "/" ]; then
  echo "[FAIL] 홈 폴더 전체나 루트는 신뢰 폴더로 추가하지 않습니다. 실습 폴더를 지정하세요." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "[FAIL] python3 가 없습니다. config.json 의 trustedFolders 배열에 아래 경로를 직접 추가하세요:" >&2
  echo "       $folder" >&2
  exit 1
fi

copilot_home="${COPILOT_HOME:-$HOME/.copilot}"
config="$copilot_home/config.json"
mkdir -p "$copilot_home"

if [ -f "$config" ]; then
  cp "$config" "$config.bak"
  echo "[ OK ] 백업: $config.bak"
fi

python3 -I - "$config" "$folder" <<'PY'
import json, os, sys
path, folder = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        text = f.read().strip()
    if text:
        data = json.loads(text)
trusted = [p for p in data.get("trustedFolders", []) if p]
if folder in trusted:
    print(f"[ OK ] 이미 신뢰 폴더입니다: {folder}")
else:
    trusted.append(folder)
    data["trustedFolders"] = trusted
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"[ OK ] 추가했습니다: {folder}")
print("현재 trustedFolders:")
for p in trusted:
    print(f"  {p}")
PY

echo
echo "이제 copilot 을 실행하고 새 세션에서 /worktree 를 한 번만 시도하세요."
