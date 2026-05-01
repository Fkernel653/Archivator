# Archivator — Advanced Archive Management

[![Bash](https://img.shields.io/badge/bash-4.0+-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS%20%7C%20WSL-blue.svg)]()

A powerful CLI tool for compressing and extracting archives with modern algorithms. Built with Bash, featuring a colorful interface and support for multiple archive formats.

## ✨ Features

- **Multiple Formats** — `zip`, `7z`, `rar`, `tar`, `tar.gz` (`tgz`/`gz`), `tar.zst` (`zst`/`tzst`), `tar.xz` (`xz`/`txz`)
- **High Compression** — Zstandard level 19 with multi-threading; 7z ultra compression (`-mx=5`)
- **Smart Exclusions** — Auto-skips `temp/*`, `cache/*`, `*.tmp`, `*.log` for Zstandard archives
- **Large File Support** — Handles ZIP >4GB via 7z backend during extraction
- **Intelligent Extraction** — Auto-detects format and extraction method (tar vs. single-file decompression)
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
| `1` | **Compress** — Select format, output to `~/Archives/` |
| `2` | **Extract** — Auto-detect format to `~/Archives/extracted/` |
| `3` | Exit |

**Supported extensions for compression:** `zip`, `7z`, `rar`, `tar`, `tar.gz` (or `gz`/`tgz`), `tar.zst` (or `zst`/`tzst`), `tar.xz` (or `xz`/`txz`)

**Supported formats for extraction:** `.zip`, `.7z`, `.rar`, `.tar`, `.tar.gz`, `.tgz`, `.tar.xz`, `.txz`, `.tar.zst`, `.tzst`, `.gz`, `.xz`, `.zst`

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
├── main.sh              # Menu interface
├── README.md            # Project documentation
└── modules/
    ├── colors.sh        # ANSI color definitions
    ├── compressor.sh    # Compression logic
    └── extractor.sh     # Extraction logic
```

## 🔧 Compression Settings

| Setting | Value |
|---------|-------|
| **Zstandard level** | 19 (max. compression) |
| **Zstandard threads** | Auto (all available cores) |
| **7z level** | `-mx=5` (ultra compression) |
| **Zip level** | `-9` (max. compression) |
| **Exclusions (Zstandard)** | `temp/*`, `cache/*`, `*.tmp`, `*.log` |
| **Output directory** | `~/Archives/` |
| **Extraction directory** | `~/Archives/extracted/` |

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Command not found | Install missing dependency (`zstd`, `unzip`, `7z`, `xz`) |
| Permission denied | Run `chmod +x main.sh modules/*.sh` |
| Archive not found | Use absolute path or check inside `~/Archives/` |
| Large ZIP fails during extraction | Ensure `p7zip-full` is installed (auto-detected) |
| `.gz` file extracts to a single file | For single `.gz` files (not `.tar.gz`), the tool uses `gunzip -k` to decompress in place |

## 📄 License

MIT License — see [LICENSE](LICENSE).

---

**Author:** [Fkernel653](https://github.com/Fkernel653)  
**Repository:** [github.com/Fkernel653/fm-dlp](https://github.com/Fkernel653/fm-dlp)
