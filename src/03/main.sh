#!/bin/bash
source colors.sh
input1=$1
input2=$2
input3=$3
input4=$4

check_duplicate(){
    if [[ $1 =~ ^[0-9]+$ && $2 =~ ^[0-9]+$ && $3 =~ ^[0-9]+$ && $4 =~ ^[0-9]+$ ]]; then
        if [[ "$1" == "$2" || "$3" == "$4" ]]; then
            echo "Error. Duplicate colors detected, enter different parameters please"
            exit 1
        fi
        if [[ "$1" > "6" || "$2" > "6" || "$3" > "6" || "$4" > "6" ]]; then
            echo "Error. Parameters must be between 0 and 6"
            exit 1
        fi
    else
        echo "Error. Parameters must be digits"
        exit 1
    fi
}

choose_text() {
    local color
    case "$1" in
        1) color=$TEXT_WHITE;;
        2) color=$TEXT_RED;;
        3) color=$TEXT_GREEN;;
        4) color=$TEXT_BLUE;;
        5) color=$TEXT_PURPLE;;
        6) color=$TEXT_BLACK;;
    esac
    echo "$color"
}

choose_back() {
    local color
    case "$1" in
        1) color=$BG_WHITE;;
        2) color=$BG_RED;;
        3) color=$BG_GREEN;;
        4) color=$BG_BLUE;;
        5) color=$BG_PURPLE;;
        6) color=$BG_BLACK;;
    esac
    echo "$color"
}

check_duplicate "$1" "$2" "$3" "$4"
name_back=$(choose_back $input1)
name_text=$(choose_text $input2)
val_back=$(choose_back $input3)
val_text=$(choose_text $input4)

info() {
    
    host=$(hostname)
    timezone=$(cat /etc/timezone)
    usr=$(whoami)
    os=$(cat /etc/os-release | grep PRETTY | awk -F '"' '{print $2}')
    time=$(date +'%d %b %Y %H:%M:%S')
    uptime=$(uptime -p)
    uptime_s=$(cat /proc/uptime | awk '{print $1}')
    ip=$(ip addr show eth0 | grep inet | grep -v '::' | awk '{print $2}')
    mask=$(ifconfig | grep -i -e broad | grep -i -e mask| awk '{print $4}')
    gate=$(ip route show default | awk '{print $3}')
    ram_t=$(free -b | awk '/Mem/ {printf "%.3f GB\n", $2/1024/1024/1024}')
    ram_u=$(free -b | awk '/Mem/ {used = $3} /buffers\/cache/ {used += $3} END {printf "%.3f GB\n", used/1024/1024/1024}')
    ram_f=$(free -b | awk '/Mem/ {free = $4} /buffers\/cache/ {free += $3} END {printf "%.3f GB\n", free/1024/1024/1024}')
    space_r=$(df -BM --output=size / | awk 'NR==2 {printf "%.2f MB\n", $1}')
    space_r_u=$(df -BM --output=used / | awk 'NR==2 {printf "%.2f MB\n", $1}')
    space_r_f=$(df -BM --output=avail / | awk 'NR==2 {printf "%.2f MB\n", $1}')
    echo -e "${name_text}${name_back}HOSTNAME = ${NC}${NC}${val_text}${val_back}$host${NC}${NC}"
    echo -e "${name_text}${name_back}TIMEZONE = ${NC}${NC}${val_text}${val_back}$timezone $time${NC}${NC}"
    echo -e "${name_text}${name_back}USER = ${NC}${NC}${val_text}${val_back}$usr${NC}${NC}"
    echo -e "${name_text}${name_back}OS = ${NC}${NC}${val_text}${val_back}$os${NC}${NC}"
    echo -e "${name_text}${name_back}DATE = ${NC}${NC}${val_text}${val_back}$time${NC}${NC}"
    echo -e "${name_text}${name_back}UPTIME = ${NC}${NC}${val_text}${val_back}$uptime${NC}${NC}"
    echo -e "${name_text}${name_back}UPTIME_SEC = ${NC}${NC}${val_text}${val_back}$uptime_s${NC}${NC}"
    echo -e "${name_text}${name_back}IP = ${NC}${NC}${val_text}${val_back}$ip${NC}${NC}"
    echo -e "${name_text}${name_back}MASK = ${NC}${NC}${val_text}${val_back}$mask${NC}${NC}"
    echo -e "${name_text}${name_back}GATEWAY = ${NC}${NC}${val_text}${val_back}$gate${NC}${NC}"
    echo -e "${name_text}${name_back}RAM_TOTAL = ${NC}${NC}${val_text}${val_back}$ram_t${NC}${NC}"
    echo -e "${name_text}${name_back}RAM_USED = ${NC}${NC}${val_text}${val_back}$ram_u${NC}${NC}"
    echo -e "${name_text}${name_back}RAM_FREE = ${NC}${NC}${val_text}${val_back}$ram_f${NC}${NC}"
    echo -e "${name_text}${name_back}SPACE_ROOT = ${NC}${NC}${val_text}${val_back}$space_r${NC}${NC}"
    echo -e "${name_text}${name_back}SPACE_ROOT_USED = ${NC}${NC}${val_text}${val_back}$space_r_u${NC}${NC}"
    echo -e "${name_text}${name_back}SPACE_ROOT_FREE = ${NC}${NC}${val_text}${val_back}$space_r_f${NC}${NC}"
    }
info
exit 0



