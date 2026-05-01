#!/bin/bash
set -euo pipefail

compress_path="$HOME/Archives"
modules_path=$(dirname "${BASH_SOURCE[0]}")
source "$modules_path/colors.sh"

compressor() {
    read -r -p $'\033[0;1m\033[0;36m        📁 Enter path: \033[0;0m' path

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

    # Show available formats
    echo -e "\n\t${BOLD}${MAGENTA}📦 Available compression formats:${RESET}"
    echo -e "\t  ${GREEN}1${RESET}${GRAY})${RESET} ${YELLOW}zip${RESET}"
    echo -e "\t  ${GREEN}2${RESET}${GRAY})${RESET} ${YELLOW}7z${RESET}"
    echo -e "\t  ${GREEN}3${RESET}${GRAY})${RESET} ${YELLOW}tar${RESET}"
    echo -e "\t  ${GREEN}4${RESET}${GRAY})${RESET} ${YELLOW}tar.gz${RESET} ${GRAY}(tgz/gz)${RESET}"
    echo -e "\t  ${GREEN}5${RESET}${GRAY})${RESET} ${YELLOW}tar.zst${RESET} ${GRAY}(zst/tzst)${RESET}"
    echo -e "\t  ${GREEN}6${RESET}${GRAY})${RESET} ${YELLOW}tar.xz${RESET} ${GRAY}(xz/txz)${RESET}"

    read -r -p $'\n\t\033[0;1m\033[0;33m🔧 Enter format number or extension: \033[0;0m' user_ext

    # Convert number to extension if digit was entered
    case "$user_ext" in
        1) user_ext="zip" ;;
        2) user_ext="7z" ;;
        3) user_ext="tar" ;;
        4) user_ext="tar.gz" ;;
        5) user_ext="tar.zst" ;;
        6) user_ext="tar.xz" ;;
    esac

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
                echo -e "${GREEN}✅ Created ZIP archive:${RESET} $archive"
                ;;

            7z)
                if [ "$is_file" = true ]; then
                    7z a -mx=5 "$archive" "$path"
                else
                    7z a -mx=5 "$archive" "$path"/*
                fi
                echo -e "${GREEN}✅ Created 7Z archive:${RESET} $archive"
                ;;

            tar)
                tar -cf "$archive" -C "$(dirname "$path")" "$basename"
                echo -e "${GREEN}✅ Created TAR archive:${RESET} $archive"
                ;;

            tar.gz|tgz|gz)
                if [[ "$user_ext" == "gz" ]]; then
                    archive="$compress_path/$basename_no_ext.tar.gz"
                fi
                tar -czf "$archive" -C "$(dirname "$path")" "$basename"
                echo -e "${GREEN}✅ Created GZIP archive:${RESET} $archive"
                ;;

            tar.zst|zst|tzst)
                if [[ "$user_ext" == "zst" || "$user_ext" == "tzst" ]]; then
                    archive="$compress_path/$basename_no_ext.tar.zst"
                fi
                if [ "$is_file" = true ]; then
                    tar -cf - -C "$(dirname "$path")" "$basename" | zstd -19 -T0 > "$archive"
                else
                    tar --exclude="temp/*" --exclude="cache/*" --exclude="*.tmp" --exclude="*.log" \
                        -cf - -C "$(dirname "$path")" "$basename" | zstd -19 -T0 > "$archive"
                fi
                echo -e "${GREEN}✅ Created ZSTD archive:${RESET} $archive"
                ;;

            tar.xz|xz|txz)
                if [[ "$user_ext" == "xz" || "$user_ext" == "txz" ]]; then
                    archive="$compress_path/$basename_no_ext.tar.xz"
                fi
                tar -cJf "$archive" -C "$(dirname "$path")" "$basename"
                echo -e "${GREEN}✅ Created XZ archive:${RESET} $archive"
                ;;

            *)
                echo -e "${RED}❌ Please enter a valid number or extension!${RESET}"
                echo -e "Valid options: 1-6 or zip, 7z, tar, tar.gz (gz/tgz), tar.zst (zst/tzst), tar.xz (xz/txz)"
                exit 1
                ;;
    esac

    # Verify and display archive contents
    echo -e "\n${BLUE}📋 Archive contents:${RESET}"
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
            tar.zst|zst|tzst)
                tar --zstd -tvf "$archive" 2>/dev/null || zstd -dc "$archive" | tar -tvf -
                ;;
            tar.xz|xz|txz)
                tar -tJvf "$archive"
                ;;
            *)
                echo -e "${RED}Unsupported format for listing: ${RESET}$user_ext"
                ;;
    esac
}

compressor
