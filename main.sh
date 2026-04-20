#!/bin/bash
set -euo pipefail

parent_dir=$(dirname "${BASH_SOURCE[0]}")
modules_path="$parent_dir/modules"
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

                                    ${GRAY}dev${MAGENTA}=${RESET}${BOLD}Fkernel653${RESET}
            ${GRAY}1${MAGENTA}=${BLUE}Compress${RESET}
            ${GRAY}2${MAGENTA}=${BLUE}Extract${RESET}
            ${GRAY}3${MAGENTA}=${BLUE}Exit${RESET}
"

    read -r -p $"        Enter your selection: " selection
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
            exit 0
            ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main