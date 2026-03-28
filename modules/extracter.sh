#!/bin/bash
set -euo pipefail

# file to Archives
target_path="$HOME/Archives"

# Module Path
modules_path=$(dirname "${BASH_SOURCE[0]}")
# Activating colors.sh
source "$modules_path/colors.sh"

extracter() {
    local file

    # Check if target directory exists, if not ask for archive path
    if [ ! -d "$target_path" ]; then
        read -p "   Enter file to archive: " file
    elif [ -e "$target_path" ]; then
        cd "${target_path}"
        read -p "   Enter archive name: " file
    fi

    # Check if the archive file exists
    if [ -e "$file" ]; then
        if [ -f "$file" ]; then
            # Extract based on archive format
            case $file in
                *.tar.gz)
                    tar -xzvf "$file" -C "$target_path"
                ;;

                *.tar.xz)
                    tar -xvf "$file" -C "$target_path"
                ;;

                *.tar.zst)
                    tar --zstd -xvf "$file" -C "$target_path"
                ;;

                *.zip)
                    size=$(stat -c %s "$file")
                    if [ "$size" -gt 4000 ]; then
                        7z x "$file" -o"$target_path"
                    else
                        unzip "$file" -d "$target_path"
                    fi
                ;;

                *.7z)
                    7z x "$file" -o"$target_path"
                ;;

                *)
                    echo -e "${RED}Unsupported archive format: ${RESET}$file"
                    exit 1
            esac
        fi
    else
        echo -e "${RED}Archive not found${RESET}"
        exit 1
    fi
}

extracter