# Archivator — Advanced Archive Management

[![Bash](https://img.shields.io/badge/bash-4.0+-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS%20%7C%20WSL-blue.svg)]()

A powerful CLI tool for compressing and extracting archives with modern algorithms. Built with Bash, featuring a colorful interface and support for multiple archive formats.

## ✨ Features

- **Multiple Formats** — `zip`, `7z`, `tar`, `tar.gz` (`tgz`/`gz`), `tar.zst` (`zst`), `tar.xz` (`xz`)
- **High Compression** — Zstandard level 19 with multi-threading
- **Smart Exclusions** — Auto-skips `temp/`, `cache/`, `*.tmp`, `*.log`
- **Large File Support** — Handles ZIP >4GB via 7z backend
- **Intelligent Extraction** — Auto-detects format and method
- **Colorful TUI** — ANSI-colored terminal interface

## 🚀 Quick Start

### Prerequisites
```bash
# Ubuntu/Debian
sudo apt install zstd unzip p7zip-full xz-utils

# macOS
brew install zstd unzip p7zip xz

# Arch
sudo pacman -S zstd unzip p7zip xz
```

### Installation
```bash
git clone https://github.com/Fkernel653/Archivator.git && cd Archivator
chmod +x main.sh modules/*.sh
./main.sh
```

## 📖 Usage

| Option | Description |
|--------|-------------|
| `1` | Compress — Select format, output to `~/Archives/` |
| `2` | Extract — Auto-detect format to `~/Archives/extracted/` |
| `3` | Exit |

**Supported extensions for compression:** `zip`, `7z`, `tar`, `tar.gz` (or `gz`/`tgz`), `tar.zst` (or `zst`), `tar.xz` (or `xz`)

**Supported formats for extraction:** `.zip`, `.7z`, `.tar`, `.tar.gz`, `.tgz`, `.tar.xz`, `.txz`, `.tar.zst`, `.gz`, `.xz`, `.zst`, `.rar`

**Examples:**
```bash
# Compress a directory
Enter path: /home/user/Documents/MyProject
Enter the extension: tar.zst
# → ~/Archives/MyProject.tar.zst

# Extract an archive
Enter archive name: myarchive.7z
# → ~/Archives/extracted/myarchive/
```

## 📁 Structure

```
Archivator/
├── main.sh           # Menu interface
└── modules/
    ├── colors.sh     # ANSI color definitions
    ├── compressor.sh # Compression logic
    └── extractor.sh  # Extraction logic
```

## 🔧 Compression Settings

| Setting | Value |
|---------|-------|
| Level | 19 (max) |
| Threads | Auto (all cores) |
| Exclusions | `temp/*`, `cache/*`, `*.tmp`, `*.log` |
| Output | `~/Archives/` |

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Command not found | Install missing dependency |
| Permission denied | `chmod +x main.sh modules/*.sh` |
| Archive not found | Use absolute path or check `~/Archives/` |
| Large ZIP fails | Ensure `p7zip-full` is installed |

## 📄 License

MIT License — see [LICENSE](LICENSE).

## 👤 Author

**Fkernel653** — [GitHub](https://github.com/Fkernel653)