#!/bin/bash
set -euo pipefail

compress_path="$HOME/Archives"
modules_path=$(dirname "${BASH_SOURCE[0]}")
source "$modules_path/colors.sh"

compressor() {
    read -r -p $"   Enter path: " path

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

    # Determine what the user entered (file or directory)
    if [ -f "$path" ]; then
        is_file=true
    elif [ -d "$path" ]; then
        is_file=false
    else
        echo -e "${RED}Unknown content format (not a regular file or directory)${RESET}"
        exit 1
    fi

    read -r -p $'\tEnter the extension: ' user_ext

    # Determine archive name (remove extension for files)
    basename=$(basename "$path")
    basename_no_ext=${basename%.*}
    archive="$compress_path/$basename_no_ext.${user_ext}"

    case "$user_ext" in
        zip)
            if [ "$is_file" = true ]; then
                zip -9 -j "$archive" "$path"
            else
                zip -r -9 "$archive" "$path"/*
            fi
            echo -e "${GREEN}Created ZIP archive:${RESET} $archive"
            ;;

        7z)
            if [ "$is_file" = true ]; then
                7z a -mx=5 "$archive" "$path"
            else
                7z a -mx=5 "$archive" "$path"/*
            fi
            echo -e "${GREEN}Created 7z archive:${RESET} $archive"
            ;;

        tar)
            tar -cf "$archive" -C "$(dirname "$path")" "$basename"
            echo -e "${GREEN}Created TAR archive:${RESET} $archive"
            ;;

        tar.gz|tgz|gz)
            # Handle both .tar.gz and .tgz extensions
            if [[ "$user_ext" == "gz" ]]; then
                archive="$compress_path/$basename_no_ext.tar.gz"
            fi
            tar -czf "$archive" -C "$(dirname "$path")" "$basename"
            echo -e "${GREEN}Created GZIP archive:${RESET} $archive"
            ;;

        tar.zst|zst)
            if [[ "$user_ext" == "zst" ]]; then
                archive="$compress_path/$basename_no_ext.tar.zst"
            fi
            if [ "$is_file" = true ]; then
                tar -cf - -C "$(dirname "$path")" "$basename" | zstd -19 -T0 > "$archive"
            else
                tar --exclude="temp/*" --exclude="cache/*" --exclude="*.tmp" --exclude="*.log" \
                    -cf - -C "$(dirname "$path")" "$basename" | zstd -19 -T0 > "$archive"
            fi
            echo -e "${GREEN}Created ZSTD archive:${RESET} $archive"
            ;;

        tar.xz|xz)
            if [[ "$user_ext" == "xz" ]]; then
                archive="$compress_path/$basename_no_ext.tar.xz"
            fi
            tar -cJf "$archive" -C "$(dirname "$path")" "$basename"
            echo -e "${GREEN}Created XZ archive:${RESET} $archive"
            ;;

        *)
            echo -e "${RED}Please enter a valid extension!${RESET}"
            echo -e "Valid extensions: zip, 7z, tar, tar.gz (gz/tgz), tar.zst (zst), tar.xz (xz)"
            exit 1
            ;;
    esac

    # Verify and display archive contents
    echo -e "${BLUE}Archive contents:${RESET}"
    case "$user_ext" in
        zip)
            unzip -l "$archive"
            ;;
        7z)
            7z l "$archive"
            ;;
        tar|tar.gz|tgz|gz)
            tar -tvf "$archive"
            ;;
        tar.zst|zst)
            if tar --zstd -tvf "$archive" > /dev/null 2>&1; then
                tar --zstd -tvf "$archive"
            else
                zstd -dc "$archive" | tar -tvf -
            fi
            ;;
        tar.xz|xz)
            tar -tJvf "$archive"
            ;;
    esac
}

compressor