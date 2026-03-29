# Archivator - Advanced Archive Management Tool

A powerful, user-friendly command-line tool for compressing and extracting archives with modern algorithms. Built with Bash, Archivator provides a colorful interface for managing `.tar.zst`, `.tar.gz`, `.tar.xz`, `.zip`, and `.7z` archives efficiently.

![Bash Version](https://img.shields.io/badge/bash-4.0+-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS%20%7C%20WSL-blue.svg)
![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)

## 📋 Features

- **Multiple Archive Formats**: Support for `.tar.zst`, `.tar.gz`, `.tar.xz`, `.zip`, and `.7z` formats
- **High Compression Ratio**: Utilizes Zstandard (zstd) compression with level 19 for optimal size
- **Smart Directory Handling**: Automatically excludes temporary files and logs during compression
- **Intelligent Extraction**: Automatically detects archive format and uses optimal extraction method
- **Large File Support**: Handles ZIP files larger than 4GB using 7z backend
- **Intuitive Interface**: Color-coded terminal output with clear prompts and ASCII art banner
- **Automatic Directory Management**: Creates target directories if they don't exist
- **Archive Verification**: Automatically verifies and displays archive contents after creation
- **Cross-Platform**: Works on Linux, macOS, and Windows (via WSL or Git Bash)
- **Secure Handling**: Comprehensive error handling and input validation
- **Path Normalization**: Handles relative paths, absolute paths, and home directory (~) expansion

## 🚀 Installation

### Prerequisites

- **Bash 4.0 or higher** - Check with `bash --version`
- **tar** - Usually pre-installed on Unix-like systems
- **zstd** - Required for `.tar.zst` compression/decompression
- **unzip** - For handling `.zip` archives (small files)
- **7z** (p7zip) - For handling `.7z` archives and large ZIP files
- **xz-utils** - For `.tar.xz` format support

### Install Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install zstd unzip p7zip-full xz-utils
```

**Fedora/RHEL:**
```bash
sudo dnf install zstd unzip p7zip xz
```

**Arch Linux:**
```bash
sudo pacman -S zstd unzip p7zip xz
```

**openSUSE:**
```bash
sudo zypper install zstd unzip p7zip xz
```

**macOS (with Homebrew):**
```bash
brew install zstd unzip p7zip xz
```

### Install Archivator

1. Clone the repository:
```bash
git clone https://github.com/Fkernel653/Archivator.git
cd Archivator
```

2. Make scripts executable:
```bash
chmod +x main.sh modules/*.sh
```

3. Run the tool:
```bash
./main.sh
```

## 📖 Usage

### Launch the Tool
```bash
./main.sh
```

### Main Menu Options

The tool presents a colorful ASCII art banner with three main options:

1. **Compress** - Create compressed archives
2. **Extract** - Extract existing archives
3. **Exit** - Close the application

### Compression Mode

When selecting compression, you'll be prompted to enter a path:

```bash
Enter your selection: 1
   Enter path: /home/user/Documents/MyProject
```

**What happens:**
- Creates archive in `~/Archives/` directory
- For files: `filename.tar.zst`
- For directories: `dirname.tar.zst`
- Automatically excludes: `temp/`, `cache/`, `*.tmp`, `*.log`
- Uses maximum compression (level 19) with multi-threading
- Displays archive contents after successful creation

**Example:**
```bash
Enter path: /home/user/Music/MyAlbum
Archive contents:
drwxr-xr-x user/user   0 2024-01-15 10:30 MyAlbum/
-rw-r--r-- user/user 5242880 2024-01-15 10:28 MyAlbum/song1.mp3
-rw-r--r-- user/user 6352896 2024-01-15 10:29 MyAlbum/song2.mp3
```

### Extraction Mode

When selecting extraction, you have two options:

**If `~/Archives/` exists:**
```bash
Enter your selection: 2
   Enter archive name: myarchive.tar.zst
```

**If `~/Archives/` doesn't exist:**
```bash
Enter your selection: 2
   Enter file to archive: /home/user/Downloads/myarchive.tar.zst
```

**Supported formats:**
- `.tar.zst` - Zstandard compressed tarballs
- `.tar.gz` - Gzip compressed tarballs
- `.tar.xz` - XZ compressed tarballs
- `.zip` - ZIP archives (automatic 4GB+ detection)
- `.7z` - 7-Zip archives

**Extraction Location:**
All archives are extracted to `~/Archives/extracted/` with preserved directory structure.

## 🎨 Terminal Color Scheme

The tool uses consistent ANSI color codes for better readability:

| Color | Usage |
|-------|-------|
| 🔴 **Red** | Errors and warnings |
| 🟢 **Green** | Success messages and option 1 |
| 🔵 **Blue** | ASCII art and informational text |
| 🟣 **Magenta** | Menu separators and accents |
| 🟡 **Yellow** | Menu options and headings |
| 💙 **Cyan** | Archive verification messages |
| ⚪ **Gray** | ASCII art background |
| *Italic* | Subtitle/author information |

## 🛠️ Technical Architecture

### Module Structure

```
Archivator/
├── main.sh              # Main menu interface
├── README.md            # This documentation
└── modules/
    ├── colors.sh        # ANSI color definitions
    ├── compressor.sh    # Compression functionality
    └── extractor.sh     # Extraction functionality
```

### Component Details

#### main.sh
- Displays ASCII art banner with improved graphics
- Provides interactive menu system
- Routes to appropriate modules
- Handles script execution flow
- Clean exit with proper messages

#### compressor.sh
- Validates and normalizes input paths
- Creates target directory structure
- Implements smart exclusion patterns
- Uses zstd compression with optimal settings
- Verifies and displays archive contents
- Handles both files and directories

**Compression Settings:**
| Setting | Value |
|---------|-------|
| **Level** | 19 (maximum compression) |
| **Threads** | Auto (uses all available cores) |
| **Exclusions** | `temp/*`, `cache/*`, `*.tmp`, `*.log` |
| **Format** | POSIX tar with zstd compression |

#### extractor.sh
- Checks for default archive directory
- Prompts for archive location intelligently
- Identifies format and extracts accordingly
- Preserves directory structure
- Handles large ZIP files (>4GB) automatically
- Creates extraction directory if needed

**Extraction Commands:**
| Format | Command | Notes |
|--------|---------|-------|
| `.tar.zst` | `tar --zstd -xvf` | Full extraction |
| `.tar.gz` | `tar -xzvf` | Verbose output |
| `.tar.xz` | `tar -xJvf` | XZ compression |
| `.zip` | `unzip` or `7z x` | Auto-detects size |
| `.7z` | `7z x` | Full 7z support |

#### colors.sh
- Defines ANSI color constants
- Provides consistent styling
- Maintains color scheme across modules
- Easy to customize color preferences

## ⚙️ Configuration

### Archive Directory

The default archive location is set to:
```bash
~/Archives/
```

This directory is automatically created if it doesn't exist during compression.

### Extraction Directory

All archives are extracted to:
```bash
~/Archives/extracted/
```

This ensures organized extraction and prevents clutter.

### Customization

You can modify the compression settings by editing `modules/compressor.sh`:

- **Compression level**: Change `-19` to desired level (1-22, 19 recommended)
- **Thread count**: Adjust `-T0` (0 = auto) or specify number
- **Exclusion patterns**: Modify the `--exclude` parameters
- **Target path**: Change `compress_path` variable

## 🐛 Troubleshooting Guide

### Common Issues and Solutions

#### 1. "Content not found" Error
**Possible causes:**
- Invalid path entered
- File/directory doesn't exist
- Permission denied

**Solutions:**
- Verify the path exists: `ls -la /path/to/file`
- Check permissions: `ls -l /path/to/file`
- Use absolute paths instead of relative paths
- Ensure you have read access to the source
- Try using `realpath` to verify the path

#### 2. Archive Not Found During Extraction
**Possible causes:**
- Wrong filename or path
- Archive directory doesn't exist
- Typo in archive name
- Missing file extension

**Solutions:**
- Use absolute paths when prompted for path
- Check if `~/Archives/` exists: `ls -la ~/Archives/`
- Verify archive name includes correct extension
- Use tab completion if available
- Check case sensitivity

#### 3. "Unsupported archive format" Error
**Possible causes:**
- File extension not recognized
- Corrupted archive
- Missing dependencies
- Wrong file extension

**Solutions:**
- Ensure file has correct extension (.tar.zst, .tar.gz, .tar.xz, .zip, .7z)
- Check if file is valid: `file /path/to/archive`
- Install missing tools: `zstd`, `unzip`, `p7zip`, or `xz-utils`
- Try extracting manually to verify archive integrity

#### 4. Compression Fails
**Possible causes:**
- Insufficient disk space
- Permission issues
- Directory not writable
- Source path contains spaces (though handled)

**Solutions:**
- Check available space: `df -h ~/Archives/`
- Verify write permissions: `touch ~/Archives/test`
- Ensure target directory exists and is writable
- Check for disk quotas

#### 5. Zstd Not Found
**Solution:**
```bash
# Ubuntu/Debian
sudo apt install zstd

# Fedora
sudo dnf install zstd

# macOS
brew install zstd

# Arch
sudo pacman -S zstd
```

#### 6. Large ZIP Files (>4GB) Not Extracting
**Cause:** Standard unzip doesn't support files >4GB
**Solution:** Archivator automatically detects and uses 7z for large files
**Manual verification:**
```bash
# Check file size
ls -lh largefile.zip
# Install 7z if needed
sudo apt install p7zip-full  # Debian/Ubuntu
```

#### 7. Permission Denied Errors
**Solutions:**
```bash
# Check permissions
ls -la /path/to/file

# Fix permissions if needed
chmod +r /path/to/file  # Read permission
chmod +x /path/to/directory  # Execute permission for directories
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Ways to Contribute
- **Report Bugs**: Open an issue with detailed description
- **Suggest Features**: Share ideas for improvements
- **Submit Pull Requests**: Fix bugs or add features
- **Improve Documentation**: Enhance README or code comments
- **Add Features**: Support new archive formats
- **Test**: Test on different platforms and report results

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes thoroughly
5. Submit a pull request

### Coding Standards
- Use `set -euo pipefail` for robust error handling
- Add comments for complex logic
- Test with different inputs (files, directories, paths with spaces)
- Maintain color scheme consistency
- Follow existing naming conventions

### Testing Guidelines
```bash
# Test compression
./main.sh -> 1 -> /path/to/test/directory

# Test extraction
./main.sh -> 2 -> testarchive.tar.zst

# Test with various formats
# .tar.gz, .tar.xz, .zip, .7z
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

**MIT License Summary:**
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ❌ Liability
- ❌ Warranty

## 👨‍💻 Author

**Fkernel653**
- GitHub: [@Fkernel653](https://github.com/Fkernel653)

## 🙏 Acknowledgments

- **Zstandard (zstd)** - For excellent compression algorithm
- **GNU tar** - For robust archiving capabilities
- **7-Zip** - For 7z format support and large ZIP handling
- **XZ Utils** - For .tar.xz compression support
- All contributors and users of this tool

## 📊 Version History

**v2.0.0** (Current)
- Renamed to Archivator
- Added .tar.xz format support
- Automatic detection of large ZIP files (>4GB)
- Improved path normalization
- Enhanced error handling
- Better ASCII art banner
- Updated documentation

**v1.0.0**
- Initial release
- Support for `.tar.zst`, `.tar.gz`, `.zip`, `.7z`
- Interactive menu system
- Color-coded output
- Automatic directory creation

**Planned Features**
- Progress bars for compression/extraction
- Multiple archive selection
- Password protection for archives
- GUI wrapper
- Batch compression mode
- Custom compression profiles
- Archive splitting
- Encryption support
- Cloud storage integration

## 💡 Tips and Tricks

1. **Tab Completion**: Use tab completion when entering paths for faster input
2. **Large Directories**: For large directories, consider adjusting exclusions to skip unnecessary files
3. **Compression Time**: Level 19 compression is slow but provides the best size reduction
4. **Multi-threading**: The `-T0` flag automatically uses all CPU cores for faster compression
5. **Archive Verification**: Always check the displayed archive contents after compression
6. **Custom Exclusions**: Edit `compressor.sh` to add your own exclusion patterns
7. **Batch Processing**: Create a loop to process multiple files:
   ```bash
   for file in *.log; do
       echo "$file" | ./main.sh
   done
   ```
8. **Quick Extract**: Use absolute paths for faster extraction without navigating menus
9. **Space Management**: Check archive sizes before compression:
   ```bash
   du -sh /path/to/directory
   ```
10. **Format Selection**: Use .tar.zst for best compression, .zip for compatibility

## 🔧 Advanced Usage

### Custom Compression Profiles

Edit `modules/compressor.sh` to create different compression profiles:

```bash
# Fast compression (level 3)
tar -cf - "$path" | zstd -3 -T0 > "$archive"

# Balanced (level 10)
tar -cf - "$path" | zstd -10 -T0 > "$archive"

# Ultra compression (level 22) - very slow
tar -cf - "$path" | zstd -22 -T0 > "$archive"
```

### Adding Custom Exclusions

Modify the tar command in `compressor.sh`:

```bash
tar --exclude="temp/*" \
    --exclude="cache/*" \
    --exclude="*.tmp" \
    --exclude="*.log" \
    --exclude="node_modules/*" \
    --exclude=".git/*" \
    -cf - "$path" | zstd -19 -T0 > "$archive"
```

## ⭐ Support the Project

If you find this tool useful, please consider:
- **Starring** the repository on GitHub
- **Forking** to contribute improvements
- **Sharing** with others who might find it useful
- **Reporting** issues you encounter
- **Writing** tutorials or blog posts about Archivator

---

**Disclaimer**: This tool is provided as-is. Always verify your archives after compression to ensure data integrity. The developers assume no liability for data loss or corruption. Test on non-critical data first.