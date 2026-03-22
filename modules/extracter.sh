#!/bin/bash
set -euo pipefail

# path to Archives
target_path="$HOME/Archives"

# Module Path
modules_path=$(dirname "${BASH_SOURCE[0]}")
# Activating colors.sh
source "$modules_path/colors.sh"

extracter() {
    local path

    # Check if target directory exists, if not ask for archive path
    if [ ! -d "$target_path" ]; then
        read -p "   Enter path to archive: " path
    elif [ -e "$target_path" ]; then
        cd "${target_path}"
        read -p "   Enter archive name: " path
    fi

    # Check if the archive file exists
    if [ -e "$path" ]; then
        if [ -f "$path" ]; then
            # Extract based on archive format
            case $path in
                *.tar.gz)
                    tar -xzvf "$path" -C "$target_path"
                ;;

                *.tar.zst)
                    tar --zstd -xvf "$path" -C "$target_path"
                ;;

                *.zip)
                    unzip "$path" -d "$target_path"
                ;;

                *.7z)
                    7z x "$path" -o "$target_path"
                ;;

                *)
                    echo -e "${RED}Unsupported archive format: ${RESET}$path"
                    exit 1
            esac
        fi
    else
        echo -e "${RED}Archive not found${RESET}"
        exit 1
    fi
}

extracter