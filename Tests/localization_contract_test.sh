#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STRINGS="$ROOT/Resources/en.lproj/Localizable.strings"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

plutil -lint "$STRINGS" >/dev/null || fail "English localization file is invalid"

ruby - "$STRINGS" <<'RUBY' || exit 1
path = ARGV.fetch(0)
entries = File.readlines(path).map do |line|
  match = line.match(/^"((?:\\.|[^"])*)"\s*=\s*"((?:\\.|[^"])*)";/)
  [match[1], match[2]] if match
end.compact

duplicates = entries.group_by(&:first).select { |_key, values| values.length > 1 }.keys
abort "FAIL: duplicate English localization keys: #{duplicates.join(', ')}" unless duplicates.empty?

placeholder = /%(?:\d+\$)?(?:@|lld|ld|d|f)/
entries.each do |source, target|
  source_count = source.scan(placeholder).length
  target_count = target.scan(placeholder).length
  abort "FAIL: placeholder mismatch for #{source.inspect}" unless source_count == target_count
end
RUBY

for key in \
  '环境信息' \
  '诊断日志' \
  '======== 代理验证测试 ========' \
  '======== 第三方代理连接检测 ========' \
  '======== 第三方代理运行检测 ========' \
  '第三方代理测试模式：模块连接成功；已保存坐标=%@' \
  '成功：{\"success\":true,\"longitude\":113.0,\"latitude\":22.0,\"accuracy\":25}\n失败：{\"success\":false,\"error\":\"错误说明\"}'; do
  grep -Fq "\"$key\" = " "$STRINGS" || fail "missing critical English localization: $key"
done

grep -q 'localizedCategory' "$ROOT/Shared/RuntimeLog.swift" \
  || fail "runtime log categories must be localized when rendered"
grep -q 'localizedDetailsText' "$ROOT/App/DiagnosticsView.swift" \
  || fail "runtime log details must be localized in the diagnostics UI"
grep -q 'String(localized: "诊断日志")' "$ROOT/App/BugReportView.swift" \
  || fail "generated bug reports must localize their diagnostic section"
grep -q 'log("  " + e.localizedMessage)' "$ROOT/App/SetupCoordinator.swift" \
  || fail "bug-report verification logs must render stored messages in the active language"

if grep -R -n 'raw.githubusercontent.com/Yu9191/wloc' \
  "$ROOT/App" "$ROOT/Shared" "$ROOT/Resources/ThirdPartyProxyModules" \
  "$ROOT/ThirdParty/WlocScripts/modules"; then
  fail "deleted Yu9191/wloc repository must not remain a runtime dependency"
fi

echo "PASS: localization and diagnostic export contract"
