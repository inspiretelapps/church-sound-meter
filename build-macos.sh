#!/bin/bash
# Build script for OpenSoundMeter on macOS
# Usage: ./build-macos.sh [arm64|x86_64]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ARCH="${1:-arm64}"
QT_PATH="${QT_PATH:-/opt/homebrew/opt/qt@5}"
BUILD_DIR="build-macos-${ARCH}"

echo "=== OpenSoundMeter macOS Build ==="
echo "Architecture: ${ARCH}"
echo "Qt path:      ${QT_PATH}"
echo "Build dir:    ${BUILD_DIR}"
echo ""

# Verify Qt
if [ ! -f "${QT_PATH}/bin/qmake" ]; then
    echo "ERROR: Qt not found at ${QT_PATH}"
    echo "Install with: brew install qt@5"
    exit 1
fi

echo "[1/4] Cleaning..."
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

echo "[2/4] Configuring..."
export PATH="${QT_PATH}/bin:$PATH"
qmake PREFIX=/usr -o "${BUILD_DIR}/Makefile" CONFIG+="sdk_no_version_check"

echo "[3/4] Building..."
make -j"$(sysctl -n hw.ncpu)" -C "${BUILD_DIR}"

echo "[4/4] Bundling frameworks..."
"${QT_PATH}/bin/macdeployqt" "${BUILD_DIR}/OpenSoundMeter.app"

echo ""
echo "=== Build complete ==="
echo "App bundle: ${BUILD_DIR}/OpenSoundMeter.app"
echo "Size:       $(du -sh "${BUILD_DIR}/OpenSoundMeter.app" | cut -f1)"

# Optional: create DMG
if command -v create-dmg &>/dev/null; then
    echo ""
    echo "Creating DMG..."
    create-dmg \
        --volname "OpenSoundMeter" \
        --volicon "icons/white.icns" \
        --window-pos 200 120 \
        --window-size 600 300 \
        --icon-size 100 \
        --icon "OpenSoundMeter.app" 175 120 \
        --app-drop-link 425 120 \
        "OpenSoundMeter-macOS-${ARCH}.dmg" \
        "${BUILD_DIR}/OpenSoundMeter.app" \
        2>/dev/null || true
fi
