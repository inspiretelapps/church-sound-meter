# Church Sound Meter

> A fork of [OpenSoundMeter](https://github.com/psmokotnin/osm) — FFT-based measurement software for tuning sound systems, customized for church audio.

## Changes from upstream

- GitHub Actions CI (macOS, Linux, Windows) replacing Travis CI
- `<https://github.com/inspiretelapps/church-sound-meter>`
- Build scripts for macOS deployment
- CMakeLists.txt (experimental — qmake is the stable build)

## Build (macOS)

```bash
# Install dependencies
brew install qt@5

# Build (qmake — stable)
./build.sh qmake

# Build (CMake — experimental)
./build.sh cmake
```

The resulting `.app` bundle is in `build/OpenSoundMeter.app` with Qt frameworks bundled.

## License

GNU General Public License v3.0 — same as upstream.
