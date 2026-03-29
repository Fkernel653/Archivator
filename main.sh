#!/bin/bash
set -euo pipefail

parent_path=$(dirname "${BASH_SOURCE[0]}")
modules_path="$parent_path/modules"
source "$modules_path/colors.sh"

main() {
    clear
    echo -e "${GRAY}
██   █▄▄▄▄  ▄  █ ▄█     ▄   ██     ▄▄▄▄▀ ████▄ █▄▄▄▄
█ █  █  ▄▀ █   █ ██      █  █ █ ▀▀▀ █    █   █ █  ▄▀
█▄▄█ █▀▀▌  ██▀▀█ ██ █     █ █▄▄█    █    █   █ █▀▀▌ 
█  █ █  █  █   █ ▐█  █    █ █  █   █     ▀████ █  █ 
   █   █      █   ▐   █  █     █  ▀              █  
  █   ▀      ▀         █▐     █                 ▀   
 ▀                     ▐     ▀                           

                        ${BLUE}dev${MAGENTA}=${RESET}${ITALIC}Fkernel653${RESET}
    ${GREEN}1${MAGENTA}=${YELLOW}Compress${RESET}
    ${BLUE}2${MAGENTA}=${YELLOW}Extract${RESET}
    ${RED}3${MAGENTA}=${YELLOW}Exit${RESET}
"

    read -r -p "Enter your selection: " selection
    case $selection in
        1)
            bash "$modules_path/compressor.sh" || {
                echo -e "${RED}Please check for files in ${modules_path}${RESET}"
                exit 1
            }
            ;;
        2)
            bash "$modules_path/extractor.sh" || {
                echo -e "${RED}Please check for files in ${modules_path}${RESET}"
                exit 1
            }
            ;;
        3)
            clear
            echo -e "${GREEN}Goodbye!${RESET}"
            ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main