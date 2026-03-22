#!/bin/bash
set -euo pipefail

parent_path=$(dirname "${BASH_SOURCE[0]}")
modules_path="$parent_path/modules"
source "$modules_path/colors.sh"

main() {
    echo -e """${YELLOW}
_______             ______ _____              _____             
___    |_______________  /____(_)__   _______ __  /_____________
__  /| |_  ___/  ___/_  __ \_  /__ | / /  __  /  __/  _ \_  ___/
_  ___ |  /   / /__ _  / / /  / __ |/ // /_/ // /_ /  __/  /    
/_/  |_/_/    \___/ /_/ /_//_/  _____/ \__,_/ \__/ \___//_/     

                        ${BLUE}dev${MAGENTA}=${RESET}${ITALIC}Fkernel653${RESET}
    ${GREEN}1${MAGENTA}=${YELLOW}Compress${RESET}
    ${BLUE}2${MAGENTA}=${YELLOW}Extract${RESET}
    ${RED}3${MAGENTA}=${YELLOW}Exit${RESET}
"""

    read -p "Enter your selection: " selection
    case $selection in
        1)
            if [ -f "$modules_path/compressor.sh" ]; then
                bash "$modules_path/compressor.sh"
            else
                echo -e "${RED}Please check for files in ${modules_path}${RESET}"
                exit 1
            fi
            ;;
            
        2)
            if [ -f "$modules_path/extracter.sh" ]; then
                bash "$modules_path/extracter.sh"
            else
                echo -e "${RED}Please check for files in ${modules_path}${RESET}"
                exit 1
            fi
            ;;

        3)
            clear
            echo -e "${GREEN}Goodbye!${RESET}"
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi