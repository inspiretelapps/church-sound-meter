#!/bin/bash
# Build script for Church Sound Meter (forked from OpenSoundMeter)
# Usage: ./build.sh [qmake|cmake]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

MODE="${1:-qmake}"
QT5_PATH="${QT5_PATH:-/opt/homebrew/opt/qt@5}"
BUILD_DIR="build"

echo "=== Church Sound Meter Build ==="
echo "Mode:       ${MODE}"
echo "Qt path:    ${QT5_PATH}"
echo "Build dir:  ${BUILD_DIR}"
echo ""

# Verify Qt
if [ ! -f "${QT5_PATH}/bin/qmake" ]; then
    echo "ERROR: Qt 5 not found at ${QT5_PATH}"
    echo "Install with: brew install qt@5"
    exit 1
fi

export PATH="${QT5_PATH}/bin:$PATH"

case "${MODE}" in
    qmake)
        echo "[1/3] Configuring with qmake..."
        rm -rf "${BUILD_DIR}"
        mkdir -p "${BUILD_DIR}"
        qmake PREFIX=/usr -o "${BUILD_DIR}/Makefile" CONFIG+="sdk_no_version_check"

        echo "[2/3] Building..."
        make -j"$(sysctl -n hw.ncpu)" -C "${BUILD_DIR}"

        echo "[3/3] Bundling frameworks..."
        "${QT5_PATH}/bin/macdeployqt" "${BUILD_DIR}/OpenSoundMeter.app"
        echo "Bundled app in: ${BUILD_DIR}/OpenSoundMeter.app"
        ;;
    cmake)
        echo "[1/3] Configuring with CMake..."
        cmake -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH="${QT5_PATH}" \
            -DGRAPH_BACKEND=OPENGL

        echo "[2/3] Building..."
        cmake --build "${BUILD_DIR}" -j"$(sysctl -n hw.ncpu)"

        echo "[3/3] Bundling frameworks..."
        if [ -d "${BUILD_DIR}/OpenSoundMeter.app" ]; then
            "${QT5_PATH}/bin/macdeployqt" "${BUILD_DIR}/OpenSoundMeter.app"
            echo "Bundled app in: ${BUILD_DIR}/OpenSoundMeter.app"
        fi
        ;;
    *)
        echo "Usage: $0 [qmake|cmake]"
        echo "  qmake — stable build (default)"
        echo "  cmake — experimental CMake build"
        exit 1
        ;;
esac

echo ""
echo "=== Build complete ==="
APP="${BUILD_DIR}/OpenSoundMeter.app"
if [ -d "$APP" ]; then
    echo "App bundle: ${APP}"
    echo "Size:       $(du -sh "$APP" | cut -f1)"
fi
