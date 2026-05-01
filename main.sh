#!/bin/bash
set -euo pipefail

parent_dir=$(dirname "${BASH_SOURCE[0]}")
modules_path="$parent_dir/modules"
source "$modules_path/colors.sh"

main() {
    clear
    echo -e "${BOLD}${MAGENTA}

    ██   █▄▄▄▄  ▄  █ ▄█     ▄   ██     ▄▄▄▄▀ ████▄ █▄▄▄▄
    █ █  █  ▄▀ █   █ ██      █  █ █ ▀▀▀ █    █   █ █  ▄▀
    █▄▄█ █▀▀▌  ██▀▀█ ██ █     █ █▄▄█    █    █   █ █▀▀▌
    █  █ █  █  █   █ ▐█  █    █ █  █   █     ▀████ █  █
       █   █      █   ▐   █  █     █  ▀              █
      █   ▀      ▀         █▐     █                 ▀
    ▀                     ▐     ▀

                                ${GRAY}by ${BOLD}${BLUE}Fkernel653${RESET}
        ${BOLD}${GREEN}1${RESET}${GRAY}: ${WHITE}Compress${RESET}
        ${BOLD}${GREEN}2${RESET}${GRAY}: ${WHITE}Extract${RESET}
        ${BOLD}${GREEN}3${RESET}${GRAY}: ${WHITE}Exit${RESET}
"

    read -r -p $'\033[0;1m\033[0;33m        Enter selection: \033[0;0m' selection
    case $selection in
        1)
            "${modules_path}/compressor.sh" || {
                echo -e "${RED}Please check for files in ${modules_path}${RESET}"
                exit 1
            }
            ;;
        2)
            "${modules_path}/extractor.sh" || {
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

trap 'clear; echo -e "\n${GREEN}Goodbye!${RESET}"; exit 0' SIGINT
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
