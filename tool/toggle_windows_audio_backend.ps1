param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("patched", "upstream")]
  [string]$Mode
)

$pubspecPath = Join-Path $PSScriptRoot "..\pubspec.yaml"
$pubspec = Get-Content $pubspecPath -Raw

$patchedBlock = @"
dependency_overrides:
  just_audio_windows:
    path: third_party/just_audio_windows_patched
"@

if ($Mode -eq "patched") {
  if ($pubspec -notmatch "dependency_overrides:\s*`r?`n\s*just_audio_windows:") {
    $pubspec = $pubspec.TrimEnd() + "`r`n`r`n" + $patchedBlock + "`r`n"
    Set-Content -Path $pubspecPath -Value $pubspec -NoNewline
    Write-Host "Switched to patched just_audio_windows backend."
  } else {
    Write-Host "Patched backend is already active."
  }
} else {
  $pubspec = [regex]::Replace(
    $pubspec,
    "(?ms)^\s*dependency_overrides:\s*`r?`n\s*just_audio_windows:\s*`r?`n\s*path:\s*third_party/just_audio_windows_patched\s*`r?`n?",
    ""
  )
  Set-Content -Path $pubspecPath -Value $pubspec.TrimEnd() -NoNewline
  Write-Host "Switched to upstream just_audio_windows backend."
}

Write-Host "Now run: flutter clean; flutter pub get; flutter run -d windows"
