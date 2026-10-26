#!/bin/bash
# GPL-3.0-or-later. Builds test executables only; does not install or sign an app.
set -euo pipefail
cd "$(dirname "$0")"
patch_dir=$PWD
source_dir=$(cd ../.. && pwd)
dns_dir="$source_dir/AdGuardSDK/AdGuardSDK/DNS"
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/adguard-network-restart.XXXXXX")
caffeinate -di &
awake_pid=$!
cleanup() {
    local result=$?
    rm -rf "$build_dir"
    if command -v go >/dev/null 2>&1; then
        go clean -cache -testcache || { [[ "$result" -ne 0 ]] || result=1; }
    fi
    kill "$awake_pid" 2>/dev/null || true
    exit "$result"
}
trap cleanup EXIT
# Type-check the production state/fingerprint against both supported iOS targets.
for ios_version in 13.0 15.0; do
    xcrun --sdk iphoneos swiftc -swift-version 5 -typecheck \
        -sdk "$(xcrun --sdk iphoneos --show-sdk-path)" -target "arm64-apple-ios$ios_version" \
        "$dns_dir/Utils/NetworkUtils/InternetState.swift" "$dns_dir/Utils/NetworkUtils/NetworkStateInfo.swift"
done
# Isolated collaborators stand in for DNS and SDK dependencies. No production logic is copied.
for module in AGDnsProxy SharedAdGuardSDK; do
    xcrun swiftc -swift-version 5 -emit-library -emit-module -module-name "$module" \
        "$patch_dir/tests/$module.swift" -o "$build_dir/lib$module.dylib" \
        -emit-module-path "$build_dir/$module.swiftmodule"
done
xcrun swiftc -swift-version 5 -I "$build_dir" -L "$build_dir" -lAGDnsProxy -lSharedAdGuardSDK \
    -Xlinker -rpath -Xlinker "$build_dir" \
    "$dns_dir/Utils/NetworkUtils/InternetState.swift" "$dns_dir/Utils/NetworkUtils/NetworkStateInfo.swift" \
    "$dns_dir/PacketTunnelProvider/PacketTunnelProviderProxy.swift" \
    "$patch_dir/tests/Support.swift" "$patch_dir/tests/main.swift" -o "$build_dir/network-restart-tests"
"$build_dir/network-restart-tests"
# Compile the complete monitor adapter using the upstream resolv header and real Apple Network APIs.
mkdir -p "$build_dir/SystemLibsResolv"
cp "$source_dir/AdGuardSDK/SystemLibsResolv/SystemLibs.h" "$build_dir/SystemLibsResolv/"
cat > "$build_dir/SystemLibsResolv/module.modulemap" <<'MAP'
module SystemLibsResolv [system] { header "SystemLibs.h" export * }
MAP
xcrun swiftc -swift-version 5 -I "$build_dir" -I "$build_dir/SystemLibsResolv" \
    -L "$build_dir" -lAGDnsProxy -lSharedAdGuardSDK -Xlinker -rpath -Xlinker "$build_dir" \
    "$dns_dir/Utils/NetworkUtils/InternetState.swift" "$dns_dir/Utils/NetworkUtils/NetworkStateInfo.swift" \
    "$dns_dir/Utils/NetworkUtils/NetworkUtils.swift" "$patch_dir/tests/NetworkUtilsTypes.swift" \
    "$patch_dir/tests/MonitorSmoke.swift" -o "$build_dir/monitor-smoke"
"$build_dir/monitor-smoke"
# Also type-check the real proxy and monitor adapter for iOS, with test-only dependencies.
mkdir -p "$build_dir/ios"
ios_sdk=$(xcrun --sdk iphoneos --show-sdk-path)
for module in AGDnsProxy SharedAdGuardSDK; do
    xcrun swiftc -swift-version 5 -emit-module -module-name "$module" -sdk "$ios_sdk" \
        -target arm64-apple-ios13.0 "$patch_dir/tests/$module.swift" \
        -emit-module-path "$build_dir/ios/$module.swiftmodule"
done
xcrun swiftc -swift-version 5 -typecheck -sdk "$ios_sdk" -target arm64-apple-ios13.0 \
    -I "$build_dir/ios" -I "$build_dir/SystemLibsResolv" \
    "$dns_dir/Utils/NetworkUtils/InternetState.swift" "$dns_dir/Utils/NetworkUtils/NetworkStateInfo.swift" \
    "$dns_dir/Utils/NetworkUtils/NetworkUtils.swift" "$patch_dir/tests/NetworkUtilsTypes.swift"
xcrun swiftc -swift-version 5 -typecheck -sdk "$ios_sdk" -target arm64-apple-ios13.0 \
    -I "$build_dir/ios" "$dns_dir/PacketTunnelProvider/PacketTunnelProviderProxy.swift" "$patch_dir/tests/Support.swift"
xcrun swiftc -frontend -parse "$dns_dir/PacketTunnelProvider/PacketTunnelProvider.swift"
