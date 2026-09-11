#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_SCRIPT="$ROOT/build.sh"

test -x "$BUILD_SCRIPT" || fail "build.sh must be executable"
grep -qF "build-unsigned-ipa.sh" "$BUILD_SCRIPT" || fail "build.sh must call build-unsigned-ipa.sh"

test -f "$ROOT/Scripts/build-unsigned-ipa.sh" || fail "build-unsigned-ipa.sh must exist"
grep -qF 'BUILD_TIMESTAMP="${BUILD_TIMESTAMP:-$(date' "$ROOT/Scripts/build-unsigned-ipa.sh" \
  || fail "build output must include its generation timestamp"
grep -qF 'PaopaoLocationSpoofer-${BUILD_TIMESTAMP}-unsigned.ipa' "$ROOT/Scripts/build-unsigned-ipa.sh" \
  || fail "timestamped IPA filename is missing"

# Should NOT contain Tunnel references
! grep -qF "Tunnel" "$ROOT/Scripts/build-unsigned-ipa.sh" || fail "build-unsigned-ipa.sh must not reference Tunnel"
! grep -qF "appex" "$ROOT/Scripts/build-unsigned-ipa.sh" || fail "build-unsigned-ipa.sh must not embed extensions"

echo "PASS: root build script contract"
