#!/bin/bash
set -euo pipefail

# compress path
compress_path="$HOME/Archives"

# Modules Path
modules_path=$(dirname "${BASH_SOURCE[0]}")
# Activating colors.sh
source "$modules_path/colors.sh"

compressor () {
    read -p "   Enter path: " path

    # Check if the source file/directory exists
    if [ -e "$path" ]; then

        # Create target directory if it doesn't exist
        if [ ! -d "$compress_path" ]; then
            mkdir -p "$compress_path" || {
                echo -e "${RED}Failed to create directory - ${RESET}${compress_path}"
                exit 1
            }
        fi

        # For file: extract filename without extension
        filename=${path##*/}
        filename=${filename%.*}
        compress_file="$compress_path/$filename.tar.zst"

        # For directory: use basename as archive name
        dirname=$(basename "${path}")
        compress_dir="$compress_path/$dirname.tar.zst"

        # Compress file or directory with zstd compression
        if [ -f "$path" ]; then
            tar -cf - "$path" | zstd -19 -T0 > "$compress_file"
        elif [ -d "$path" ]; then
            tar --exclude="temp/*" --exclude="cache/*" --exclude="*.tmp" --exclude="*.log" -cf - "$path" | zstd -19 -T0 > "$compress_dir"
        else
            echo -e "${RED}Unknown content format${RESET}"
            exit 1
        fi

        # Determine which archive was created
        if [ -f "$compress_file" ]; then
            archive="$compress_file"
        elif [ -f "$compress_dir" ]; then
            archive="$compress_dir"
        else
            echo -e "${RED}Archive not found${RESET}"
            exit 1
        fi

        # Verify and display archive contents
        if tar --zstd -tvf "$archive" > /dev/null 2>&1; then
            echo -e "${BLUE}Archive contents:${RESET}"
            tar --zstd -tvf "$archive"
            exit 0
        else
            echo -e "${RED}Error reading file${RESET}"
            exit 1
        fi

    else
        echo -e "${RED}Content not found${RESET}"
        exit 1
    fi
}

compressor