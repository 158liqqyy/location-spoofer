#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

passed=0
failed=0
failed_scripts=()

for script in "$ROOT"/Tests/*_test.sh; do
  name="$(basename "$script")"
  echo "==> $name"
  if bash "$script"; then
    echo "PASS: $name"
    passed=$((passed + 1))
  else
    echo "FAIL: $name"
    failed_scripts+=("$name")
    failed=$((failed + 1))
  fi
done

echo "----------------------------------------"
echo "Contract tests: $passed passed / $failed failed"
if [ "$failed" -gt 0 ]; then
  echo "Failed scripts:"
  for name in "${failed_scripts[@]}"; do
    echo "  - $name"
  done
  exit 1
fi

echo "PASS: all contract tests"
