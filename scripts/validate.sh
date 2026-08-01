#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./tests/main.sh
python3 scripts/theme_contract.py --local
python3 scripts/generate-theme-adapters.py --check

installer="$repo_root/../../installer/smu.py"
if [ -f "$installer" ]; then
    SMU_MODULE_PATH="$repo_root/.." python3 "$installer" provisioning-adapter validate --json >/dev/null
fi
