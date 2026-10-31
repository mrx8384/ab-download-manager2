<h1 align="center">AT Download Manager</h1>

<p align="center">
  A download manager for Windows, Linux, macOS and Android, based on
  <a href="https://github.com/amir1376/ab-download-manager">AB Download Manager</a>.
</p>

## What's different

- **Keeps downloading when the internet drops.** If the connection is lost, downloads keep retrying
  (3s, 6s, 12s, 24s, then every 30s) until the internet is back, then continue from where they stopped.
  You can turn this off in Settings → "Keep Retrying When Connection Is Lost".
- **Its own app identity.** AT Download Manager installs next to AB Download Manager without replacing it,
  and keeps its own settings (`~/.atdm`) and default download folder (`Downloads/ATDM`).

The official AB Download Manager browser extension works with this app too (same port `15151`).
Don't run both apps at the same time, or the browser extension will only reach one of them.

## Download

Get the latest version from the [Releases page](https://github.com/mrx8384/ab-download-manager2/releases).

## Build it yourself (Windows)

```bat
git clone https://github.com/mrx8384/ab-download-manager2.git
cd ab-download-manager2
scripts\build-windows.bat
```

The script installs what's missing (JDK 25, NSIS, Android SDK tools) and puts the installer and
portable zip in `build\ci-release\binaries`.

## Credits and license

AT Download Manager is a modified version of
[AB Download Manager](https://github.com/amir1376/ab-download-manager) by
[amir1376](https://github.com/amir1376) and its contributors.
All the core work is theirs — if you like the app, consider
[supporting the original project](https://abdownloadmanager.com/donate).

Changes in this version: the "keep retrying when connection is lost" feature, a new app name and
identifiers, update checks pointing to this repository, and a Windows build script.

Licensed under the [Apache License 2.0](LICENSE), same as the original project.
The original README is kept in [README.upstream.md](README.upstream.md).
