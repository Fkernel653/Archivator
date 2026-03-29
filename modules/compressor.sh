#!/bin/bash
set -euo pipefail

compress_path="$HOME/Archives"
modules_path=$(dirname "${BASH_SOURCE[0]}")
source "$modules_path/colors.sh"

compressor() {
    read -r -p "   Enter path: " path

    # Normalize path (handles ~, ., .., relative paths)
    if ! path=$(realpath "$path" 2>/dev/null); then
        echo -e "${RED}Invalid path${RESET}"
        exit 1
    fi

    # Check if source exists
    if [ ! -e "$path" ]; then
        echo -e "${RED}Content not found${RESET}"
        exit 1
    fi

    # Create target directory
    mkdir -p "$compress_path" || {
        echo -e "${RED}Failed to create directory - ${RESET}${compress_path}"
        exit 1
    }

    # Determine archive name (remove extension for files)
    basename=$(basename "$path")
    basename_no_ext=${basename%.*}
    archive="$compress_path/$basename_no_ext.tar.zst"

    # Compress with zstd
    if [ -f "$path" ]; then
        tar -cf - "$path" | zstd -19 -T0 > "$archive"
    elif [ -d "$path" ]; then
        tar --exclude="temp/*" --exclude="cache/*" --exclude="*.tmp" --exclude="*.log" \
            -cf - "$path" | zstd -19 -T0 > "$archive"
    else
        echo -e "${RED}Unknown content format${RESET}"
        exit 1
    fi

    # Verify and display archive contents
    if tar --zstd -tvf "$archive" > /dev/null 2>&1; then
        echo -e "${BLUE}Archive contents:${RESET}"
        tar --zstd -tvf "$archive"
    else
        echo -e "${RED}Error reading file${RESET}"
        exit 1
    fi
}

compressor