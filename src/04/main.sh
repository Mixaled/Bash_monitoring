#!/bin/bash
source colors.sh

DEFAULT_COLUMN1_BACKGROUND=$BG_BLACK
DEFAULT_COLUMN1_FONT_COLOR=$TEXT_WHITE
DEFAULT_COLUMN2_BACKGROUND=$BG_RED
DEFAULT_COLUMN2_FONT_COLOR=$TEXT_BLUE

default1=false
default2=false
default3=false
default4=false

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

check_digit(){
    if [[ $1 =~ ^[1-9]+$ ]]; then
        if [ "$1" -gt 6 ]; then
            echo "Error. Digit must be between 1 and 6"
            exit 1
        fi
    else
        echo "Error. Parameters must be digits"
        exit 1
    fi
}


CONFIG_FILE="config.txt"
if [ -f "$CONFIG_FILE" ]; then
    if test -n "$(grep column1_background config.txt)"; then
        input1=$(grep column1_background config.txt | cut -d'=' -f2)
        input1_n=$(awk "BEGIN {print $input1 + 0}")
        check_digit $input1_n
        input1=$(choose_back $input1_n)
    else
        default1=true
        input1=$DEFAULT_COLUMN1_BACKGROUND
    fi

    if test -n "$(grep column1_font_color config.txt)"; then
        input2=$(grep column1_font_color config.txt | cut -d'=' -f2)
        input2_n=$(awk "BEGIN {print $input2 + 0}")
        check_digit $input2_n
        input2=$(choose_text $input2_n)
    else
        default2=true
        input2=$DEFAULT_COLUMN1_FONT_COLOR
    fi

    if test -n "$(grep column2_background config.txt)"; then
        input3=$(grep column2_background config.txt | cut -d'=' -f2)
        input3_n=$(awk "BEGIN {print $input3 + 0}")
        check_digit $input3_n
        input3=$(choose_back $input3_n)
    else
        default3=true
        input3=$DEFAULT_COLUMN2_BACKGROUND
    fi

    if test -n "$(grep column2_font_color config.txt)"; then
        input4=$(grep column2_font_color config.txt | cut -d'=' -f2)
        input4_n=$(awk "BEGIN {print $input4 + 0}")
        check_digit $input4_n
        input4=$(choose_text $input4_n)
    else
        default4=true
        input4=$DEFAULT_COLUMN2_FONT_COLOR
    fi

else
    input1=$DEFAULT_COLUMN1_BACKGROUND
    input2=$DEFAULT_COLUMN1_FONT_COLOR
    input3=$DEFAULT_COLUMN2_BACKGROUND
    input4=$DEFAULT_COLUMN2_FONT_COLOR
    default1=true
    default2=true
    default3=true
    default4=true
fi




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

    echo -e "${input2}${input1}HOSTNAME = ${NC}${NC}${input4}${input3}$host${NC}${NC}"
    echo -e "${input2}${input1}TIMEZONE = ${NC}${NC}${input4}${input3}$timezone $time${NC}${NC}"
    echo -e "${input2}${input1}USER = ${NC}${NC}${input4}${input3}$usr${NC}${NC}"
    echo -e "${input2}${input1}OS = ${NC}${NC}${input4}${input3}$os${NC}${NC}"
    echo -e "${input2}${input1}DATE = ${NC}${NC}${input4}${input3}$time${NC}${NC}"
    echo -e "${input2}${input1}UPTIME = ${NC}${NC}${input4}${input3}$uptime${NC}${NC}"
    echo -e "${input2}${input1}UPTIME_SEC = ${NC}${NC}${input4}${input3}$uptime_s${NC}${NC}"
    echo -e "${input2}${input1}IP = ${NC}${NC}${input4}${input3}$ip${NC}${NC}"
    echo -e "${input2}${input1}MASK = ${NC}${NC}${input4}${input3}$mask${NC}${NC}"
    echo -e "${input2}${input1}GATEWAY = ${NC}${NC}${input4}${input3}$gate${NC}${NC}"
    echo -e "${input2}${input1}RAM_TOTAL = ${NC}${NC}${input4}${input3}$ram_t${NC}${NC}"
    echo -e "${input2}${input1}RAM_USED = ${NC}${NC}${input4}${input3}$ram_u${NC}${NC}"
    echo -e "${input2}${input1}RAM_FREE = ${NC}${NC}${input4}${input3}$ram_f${NC}${NC}"
    echo -e "${input2}${input1}SPACE_ROOT = ${NC}${NC}${input4}${input3}$space_r${NC}${NC}"
    echo -e "${input2}${input1}SPACE_ROOT_USED = ${NC}${NC}${input4}${input3}$space_r_u${NC}${NC}"
    echo -e "${input2}${input1}SPACE_ROOT_FREE = ${NC}${NC}${input4}${input3}$space_r_f${NC}${NC}"
}

define_color() {
    local color
    case "$1" in
        1) color="white";;
        2) color="red";;
        3) color="green";;
        4) color="blue";;
        5) color="purple";;
        6) color="black";;
    esac
    echo "$color"
}
end(){

    if [[ $default1 == true ]]; then
        echo "Column 1 background = default (black)"
    else
        echo "Column 1 background = ${input1_n} ($(define_color $input1_n))"
    fi
    if [[ $default2 == true ]]; then
        echo "Column 1 font color = default (white)"
    else
        echo "Column 1 font color = ${input2_n} ($(define_color $input2_n))"
    fi
    if [[ $default3 == true ]]; then
        echo "Column 2 background = default (red)"
    else
        echo "Column 2 background = ${input3_n} ($(define_color $input3_n))"
    fi
    if [[ $default4 == true ]]; then
        echo "Column 2 font color = default (blue)"
    else
        echo "Column 2 font color = ${input4_n} ($(define_color $input4_n))"
    fi
}

info
end
exit 0
