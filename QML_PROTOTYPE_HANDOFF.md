# KFPS QML Prototype Handoff

This folder is a local prototype based on current GitHub `main` at commit `d35360e`.

## What changed

- Replaced the WPF shell with the QML shell from `KFPS_QML_REFINEMENT_PASS_02_SOURCE`.
- Removed the tracked `KFPS.Wpf` folder from the prototype.
- Rebuilt the root `KFPS.exe` on Windows as a PyInstaller/PySide6/QML executable.
- Kept the existing backend scripts for generation, JSON preview, Fabric editor launch, import, export, and update flow.
- Updated update cleanup so old `KFPS.Wpf` files are removed during future updates.
- Forced Qt Quick Controls to use the `Basic` style so custom QML controls render consistently.
- Kept backend bridge compatibility with old `WPF_*` event markers while emitting new `KFPS_*` markers.

## Validation Performed

- Windows bundled Python test suite: 15/15 passed.
- Linux static QML refinement tests: 10/10 passed.
- Source QML audit on Windows: 10 screenshots and 10 layout reports generated.
- Built `KFPS.exe` audit on Windows: 10 screenshots and 10 layout reports generated.
- Built layout report: no zero-size or too-small controls found.
- Built `KFPS.exe` no-argument launch smoke test: process started and stayed alive.

## Current Prototype Paths

- Linux source prototype: `/home/hestia/Desktop/KFPS QML Prototype`
- Windows test prototype: `C:\Users\Hestia\Desktop\KFPS QML Prototype`
- Windows executable: `C:\Users\Hestia\Desktop\KFPS QML Prototype\KFPS.exe`

## Not Pushed

No GitHub push or release was made. This is a local prototype for manual testing.
