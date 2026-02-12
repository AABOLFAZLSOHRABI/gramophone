# Android Runtime Log Notes

The following logs are usually informational on many Android devices and are
not app-level failures by themselves:

- `AudioCapabilities Unsupported mime ...`
- `CCodec ... BAD_INDEX`
- `BufferPool...`
- `Access denied finding property "persist.vendor..."`
- `TrafficStats tagSocket...`

These should only be investigated as blockers when they are paired with real
functional failures (for example: audio does not start, crashes, ANR, or
player state stuck in loading/error).
