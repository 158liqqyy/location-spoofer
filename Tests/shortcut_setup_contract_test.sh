#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() { echo "FAIL: $*" >&2; exit 1; }

GUIDE="$ROOT/App/DingTalkAutomationGuideView.swift"
SETTINGS="$ROOT/App/SettingsView.swift"

test -s "$GUIDE" || fail "DingTalk automation guide view is missing"
grep -q 'struct DingTalkAutomationGuideSection: View' "$GUIDE" || fail "settings entry view is missing"
grep -q 'struct DingTalkAutomationGuideView: View' "$GUIDE" || fail "automation guide view is missing"
grep -q 'ShortcutsLink' "$GUIDE" || fail "iOS 16 ShortcutsLink path is missing"
grep -q 'shortcuts://' "$GUIDE" || fail "Shortcuts URL fallback is missing"
grep -q '特定时间' "$GUIDE" || fail "time-of-day automation step is missing"
grep -q '立即运行' "$GUIDE" || fail "run-immediately step is missing"
grep -q '运行时通知' "$GUIDE" || fail "notification option step is missing"
grep -q '钉钉' "$GUIDE" || fail "DingTalk step is missing"
grep -q '考勤打卡' "$GUIDE" || fail "attendance action step is missing"
grep -q 'DingTalkAutomationGuideSection()' "$SETTINGS" || fail "settings page entry is missing"

echo "PASS: shortcut setup contract"
