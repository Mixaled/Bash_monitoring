#!/bin/bash
start_time=$(date +%s)
path=''
if [[ $1 == */ && -d "$1" ]]; then
    path=$1
else
    echo "Wrong path"
    exit 1
fi
count_dir=$(find $path -type d | wc -l)
echo "Total number of folders (including all nested ones) = ${count_dir}"
sudo du -h -d 1 $path| sort -hr | head -n 6 >> tmp.txt

output=$(cat -n tmp.txt)

while IFS= read -r line; do
    list+=("$line")
done <<< "$output"

unset 'list[0]'

count=1
for item in "${list[@]}"; do
    path2=$(echo "$item" | awk '{print $3}')
    size=$(echo "$item" | awk '{print $2}')
    echo "$count - $path2, $size"
    ((count++))
done
rm -f tmp.txt

total_files=$(find $path -type f 2> /dev/null| wc -l)
config_files=$(find "$path" -type f -name '*.config' | wc -l)
text_file=$(find $path -type f 2> /dev/null| grep .txt| wc -l)
execute_file=$(find $path -type f -executable 2> /dev/null| wc -l)
log_files=$(ls -alR $path  2> /dev/null| grep .log| wc -l)
archive_files=$(find $path -type f 2> /dev/null| grep "[.tar|.zip|.gz|.tar.gz|.tar.bz2]" | wc -l)
symbolic=$(find $path -type l 2> /dev/null| wc -l)

echo "Total number of files = $total_files" 
echo "Configuration files (with the.conf extension) = $config_files"
echo "Text files = $text_file" 
echo "Executable files = $execute_file" 
echo "Log files (with the extension .log) = $log_files" 
echo "Archive files = $archive_files"
echo "Symbolic links = $symbolic"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
find $path -type f 2> /dev/null -printf '%p %s\n' | awk -F '.' '{print $0 " " $NF}' | sort -nrk2 | nl | numfmt --to=iec --field=3 | awk '{print $1 " - " $2 ", " $3 ", " $4}' | column -t | head -10
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
find $path -type f 2> /dev/null -executable -printf "%p %s " -exec md5sum {$4} \;| sort -nrk2 |nl|numfmt --to=iec --field=3 | awk '{print $1 " - " $2 ", " $3 ", " $4}'|column -t|head -10
end_time=$(date +%s)
duration=$((end_time - start_time))
printf "Script execution time (in seconds) = %.1f\n" $duration
