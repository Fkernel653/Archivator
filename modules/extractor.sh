#!/bin/bash
set -euo pipefail

target_folder="$HOME/Archives"
modules_path=$(dirname "${BASH_SOURCE[0]}")
source "$modules_path/colors.sh"

extractor() {
    local file

    # Check if target directory exists, if not ask for archive path
    if [ ! -d "$target_folder" ]; then
        read -r -p "   Enter file to archive: " file
    else
        cd "${target_folder}"
        read -r -p "   Enter archive name: " file
        # If relative path, it's relative to target_folder
        if [[ ! "$file" = /* && ! "$file" =~ ^~ ]]; then
            file="$target_folder/$file"
        fi
    fi

    # Revealing a tilde and a variable
    file=$(eval echo "$file")

    # Normalize the path
    file=$(realpath "$file" 2>/dev/null || echo "$file")

    # Check if archive exists and is a file
    if [ ! -f "$file" ]; then
        echo -e "${RED}Archive not found: ${RESET}$file"
        exit 1
    fi

    # Create extraction directory
    extract_base="${target_folder}/extracted"
    mkdir -p "$extract_base"

    # Extract based on format
    case $file in
        *.tar.gz)
            tar -xzvf "$file" -C "$extract_base"
            ;;
        *.tar.xz)
            tar -xJvf "$file" -C "$extract_base"
            ;;
        *.tar.zst)
            tar --zstd -xvf "$file" -C "$extract_base"
            ;;
        *.zip)
            size=$(stat -c %s "$file")
            if [ "$size" -gt 4000000000 ]; then
                7z x "$file" -o"$extract_base"
            else
                unzip "$file" -d "$extract_base"
            fi
            ;;
        *.7z)
            7z x "$file" -o"$extract_base"
            ;;
        *)
            echo -e "${RED}Unsupported archive format: ${RESET}$file"
            exit 1
    esac
}

extractor