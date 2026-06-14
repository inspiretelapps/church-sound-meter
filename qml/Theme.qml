import QtQuick 2.15

/*!
 * Church Sound Meter — Glass Theme
 *
 * Design tokens for a modern frosted-glass aesthetic.
 * Inspired by macOS Big Sur+ / visionOS vibrancy.
 */
QtObject {
    readonly property string name: "Church Sound Meter"

    // ── Glass surface ──────────────────────────────────────────────
    readonly property color glassBackground:         Qt.rgba(0.12, 0.12, 0.14, 0.75)
    readonly property color glassSurface:            Qt.rgba(0.18, 0.18, 0.22, 0.65)
    readonly property color glassSurfaceLighter:     Qt.rgba(0.24, 0.24, 0.28, 0.60)
    readonly property color glassBorder:             Qt.rgba(1.0,  1.0,  1.0,  0.08)
    readonly property color glassBorderLight:        Qt.rgba(1.0,  1.0,  1.0,  0.15)
    readonly property real   glassRadius:            10
    readonly property real   glassRadiusSmall:       6

    // ── Accent ─────────────────────────────────────────────────────
    readonly property color accent:                 Qt.rgba(0.40, 0.60, 1.0,  1.0)  // vibrant blue
    readonly property color accentDim:              Qt.rgba(0.30, 0.50, 0.90, 0.60)
    readonly property color accentPink:             Qt.rgba(1.0,  0.35, 0.65, 1.0)
    readonly property color accentGreen:            Qt.rgba(0.30, 0.85, 0.55, 1.0)
    readonly property color accentOrange:           Qt.rgba(1.0,  0.60, 0.20, 1.0)
    readonly property color accentPurple:           Qt.rgba(0.60, 0.40, 1.0,  1.0)

    // ── Text ───────────────────────────────────────────────────────
    readonly property color textPrimary:            Qt.rgba(1.0,  1.0,  1.0,  0.92)
    readonly property color textSecondary:          Qt.rgba(1.0,  1.0,  1.0,  0.60)
    readonly property color textMuted:              Qt.rgba(1.0,  1.0,  1.0,  0.35)

    // ── Chart colors ───────────────────────────────────────────────
    readonly property color chartBackground:        Qt.rgba(0.06, 0.06, 0.08, 1.0)
    readonly property color chartGrid:              Qt.rgba(1.0,  1.0,  1.0,  0.06)
    readonly property color chartGridMajor:         Qt.rgba(1.0,  1.0,  1.0,  0.12)
    readonly property color chartText:              Qt.rgba(1.0,  1.0,  1.0,  0.50)
    readonly property color chartCursor:            Qt.rgba(1.0,  1.0,  1.0,  0.70)
    readonly property color chartGlow:              Qt.rgba(0.40, 0.60, 1.0,  0.25)

    // ── Series colors (vibrant, modern palette) ────────────────────
    readonly property var seriesColors: [
        Qt.rgba(0.40, 0.60, 1.0,  1.0),  // blue
        Qt.rgba(1.0,  0.35, 0.65, 1.0),  // pink
        Qt.rgba(0.30, 0.85, 0.55, 1.0),  // green
        Qt.rgba(1.0,  0.60, 0.20, 1.0),  // orange
        Qt.rgba(0.60, 0.40, 1.0,  1.0),  // purple
        Qt.rgba(0.95, 0.75, 0.15, 1.0),  // amber
        Qt.rgba(0.20, 0.80, 0.90, 1.0),  // cyan
        Qt.rgba(1.0,  0.45, 0.30, 1.0),  // red-orange
        Qt.rgba(0.50, 1.0,  0.40, 1.0),  // lime
        Qt.rgba(0.80, 0.50, 1.0,  1.0)   // violet
    ]

    // ── Shadow ─────────────────────────────────────────────────────
    readonly property color shadowColor:            Qt.rgba(0.0,  0.0,  0.0,  0.30)
    readonly property real   shadowBlur:            12
    readonly property real   shadowSpread:          0.5

    // ── Typography ─────────────────────────────────────────────────
    readonly property string fontFamily:            "SF Pro Text, -apple-system, Helvetica Neue, sans-serif"
    readonly property real   fontSizeSmall:         11
    readonly property real   fontSizeBody:          13
    readonly property real   fontSizeTitle:         15
    readonly property real   fontSizeHeading:       18

    // ── Spacing ────────────────────────────────────────────────────
    readonly property real   spacingTiny:           4
    readonly property real   spacingSmall:          8
    readonly property real   spacingMedium:         12
    readonly property real   spacingLarge:          16
    readonly property real   spacingXl:             24

    // ── Controls ───────────────────────────────────────────────────
    readonly property real   controlHeight:         28
    readonly property real   controlHeightSmall:    22
    readonly property real   iconSize:              16
    readonly property real   iconSizeLarge:         22
}
