#!/bin/bash
info() {
	host=$(hostname)
	echo "HOSTANAME = $host"
	timezone=$(cat /etc/timezone)
	time=$(date +"%Z")
	echo "TIMEZONE = $timezone $time"
	usr=$(whoami)
	echo "USER = $usr"
	os=$(cat /etc/os-release | grep PRETTY | awk -F '"' '{print $2}')
	echo "OS = $os"
	time=$(date +'%d %b %Y %H:%M:%S')
	echo "DATE = $time"
	uptime=$(uptime -p)
	echo "UPTIME = $uptime"
	uptime_s=$(cat /proc/uptime | awk '{print $1}')
	echo "UPTIME_SEC = $uptime_s"
	ip=$(ip addr show eth0 | grep inet | grep -v '::' | awk '{print $2}')
	echo "IP = $ip"
	mask=$(ifconfig | grep -i -e broad | grep -i -e mask| awk '{print $4}')
	echo "MASK = $mask"
	gate=$(ip route show default | awk '{print $3}')
	echo "GATEWAY = $gate"
	ram_t=$(free -b | awk '/Mem/ {printf "%.3f GB\n", $2/1024/1024/1024}')
	echo "RAM_TOTAL = $ram_t"
	ram_u=$(free -b | awk '/Mem/ {used = $3} /buffers\/cache/ {used += $3} END {printf "%.3f GB\n", used/1024/1024/1024}')
	echo "RAM_USED = $ram_u"
	ram_f=$(free -b | awk '/Mem/ {free = $4} /buffers\/cache/ {free += $3} END {printf "%.3f GB\n", free/1024/1024/1024}')
	echo "RAM_FREE = $ram_f"
	space_r=$(df -BM --output=size / | awk 'NR==2 {printf "%.2f MB\n", $1}')
	echo "SPACE_ROOT = $space_r"
	space_r_u=$(df -BM --output=used / | awk 'NR==2 {printf "%.2f MB\n", $1}')
	echo "SPACE_ROOT_USED = $space_r_u"
	space_r_f=$(df -BM --output=avail / | awk 'NR==2 {printf "%.2f MB\n", $1}')
	echo "SPACE_ROOT_FREE = $space_r_f"
	
}
info
file=$(date +"%d_%m_%y_%H_%M_%S.status")
echo "Save ifo in the file? [Y/n]"
read input
if [ "$input" = "Y" ] || [ "$input" = "y" ]; then
    info >> "$file"
else
    exit 0
fi

