# Windows Audio Playback Debug

This project supports two Windows backends for `just_audio_windows`:

1. `patched` (local fork): `third_party/just_audio_windows_patched`
2. `upstream` (pub.dev package)

## Toggle backend mode

```powershell
# patched backend
pwsh ./tool/toggle_windows_audio_backend.ps1 -Mode patched

# upstream backend
pwsh ./tool/toggle_windows_audio_backend.ps1 -Mode upstream
```

After each switch, run a full rebuild:

```powershell
flutter clean
flutter pub get
flutter run -d windows
```

Hot restart is not enough for native/plugin changes.
