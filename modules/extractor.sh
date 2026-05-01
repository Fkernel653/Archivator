#!/bin/bash
set -euo pipefail

target_folder="$HOME/Archives"
modules_path=$(dirname "${BASH_SOURCE[0]}")
source "$modules_path/colors.sh"

extractor() {
    local file

    # Check if target directory exists, if not ask for archive path
    if [ ! -d "$target_folder" ]; then
        read -r -p $'\033[0;1m\033[0;36m        📦 Enter file to archive: \033[0;0m' file
    else
        # Show available formats for reference
        echo -e "\n\t${BOLD}${MAGENTA}📦 Supported archive formats:${RESET}"
        echo -e "\t  ${GREEN}1${RESET}${GRAY})${RESET} ${YELLOW}zip${RESET}"
        echo -e "\t  ${GREEN}2${RESET}${GRAY})${RESET} ${YELLOW}7z${RESET}"
        echo -e "\t  ${GREEN}3${RESET}${GRAY})${RESET} ${YELLOW}tar${RESET}"
        echo -e "\t  ${GREEN}4${RESET}${GRAY})${RESET} ${YELLOW}tar.gz${RESET} ${GRAY}(tgz/gz)${RESET}"
        echo -e "\t  ${GREEN}5${RESET}${GRAY})${RESET} ${YELLOW}tar.zst${RESET} ${GRAY}(zst/tzst)${RESET}"
        echo -e "\t  ${GREEN}6${RESET}${GRAY})${RESET} ${YELLOW}tar.xz${RESET} ${GRAY}(xz/txz)${RESET}"

        cd "${target_folder}"
        read -r -p $'\n\t\033[0;1m\033[0;33m📂 Enter archive name: \033[0;0m' file
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
        echo -e "${RED}❌ Archive not found: ${RESET}$file"
        exit 1
    fi

    # Create extraction directory
    extract_base="${target_folder}/extracted"
    mkdir -p "$extract_base"

    # Extract based on format
    case $file in
            *.tar.gz|*.tgz)
                echo -e "${BLUE}📦 Extracting GZIP archive...${RESET}"
                tar -xzvf "$file" -C "$extract_base"
                ;;
            *.tar.xz|*.txz)
                echo -e "${BLUE}📦 Extracting XZ archive...${RESET}"
                tar -xJvf "$file" -C "$extract_base"
                ;;
            *.tar.zst|*.tzst)
                echo -e "${BLUE}📦 Extracting ZSTD archive...${RESET}"
                tar --zstd -xvf "$file" -C "$extract_base"
                ;;
            *.gz)
                echo -e "${BLUE}📦 Extracting GZ file...${RESET}"
                gunzip -k "$file"
                ;;
            *.xz)
                echo -e "${BLUE}📦 Extracting XZ file...${RESET}"
                unxz -k "$file"
                ;;
            *.zst)
                echo -e "${BLUE}📦 Extracting ZST file...${RESET}"
                unzstd -k "$file"
                ;;
            *.zip)
                echo -e "${BLUE}📦 Extracting ZIP archive...${RESET}"
                size=$(stat -c %s "$file")
                if [ "$size" -gt 4000000000 ]; then
                    7z x "$file" -o"$extract_base"
                else
                    unzip "$file" -d "$extract_base"
                fi
                ;;
            *.7z)
                echo -e "${BLUE}📦 Extracting 7Z archive...${RESET}"
                7z x "$file" -o"$extract_base"
                ;;
            *)
                echo -e "${RED}❌ Unsupported archive format: ${RESET}$file"
                exit 1
    esac

    echo -e "${GREEN}✅ Extraction complete! Files in: ${RESET}$extract_base"
}

extractor
