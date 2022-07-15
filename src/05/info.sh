#!/bin/bash
  
startTime=$(date +"%s.%N")  # время старта скрипта
whiteF="\033[107m"; blackT="\033[30m"; reset="\e[0m" #раскраска

function total_number_of_folders {
        count="$(ls -l $param | grep -c ^d)"
        echo -e "${whiteF}${blackT}Total number of folders (including all nested ones)${reset} = $count"
}

function TOP_5_folders_of_maximum_size {
        echo -e "${whiteF}${blackT}TOP 5 folders of maximum size arranged in descending order (path and size):${reset} "
        i=1
        for ((var=1; var<6; var++, i++))
        do
            name=$(sudo du -m $param | sort -n | sed -n "$var"p | awk '{printf("%s", $2)}')
            size=$(sudo du -m $param | sort -n | sed -n "$var"p | awk '{printf("%s", $1)}')
            if ! [ -z "$name" ] && ! [ -z "$size" ]; then
                echo "$i - $name, $size Mb"
            fi
        done
}

function total_number_of_files {
        echo -e "${whiteF}${blackT}Total number of files${reset} = $(sudo ls -laR $param | grep "^-" | wc | awk '{print $1}')"
}

function Number_of {
        echo -e "${whiteF}${blackT}Number of:${reset} "
        echo "Configuration files (with the .conf extension) = $(sudo find $param -type f -name "*.conf" | wc -l)"
        echo "Text files = $(sudo find $param -type f -name "*.txt" | wc -l)"
        echo "Executable files = $(sudo find $param -type f -name -executable | wc -l)"
        echo "Log files (with the extension .log) = $(sudo find $param -type f -name "*.log" | wc -l)"
        echo "Archive files = $(sudo find $param -type f -name "*.zip" -o -name "*.7z" -o -name "*.rar" -o -name "*.tar" | wc -l)"
        echo "Symbolic links = $(sudo find $param -type l | wc -l)"
}

function TOP_10_files_of_maximum_size {
        echo -e "${whiteF}${blackT}TOP 10 files of maximum size arranged in descending order (path, size and type):${reset}"
        i=1
        for ((var=1; var<=10; var++, i++))
        do
            name=$(sudo find $param -type f -exec du -h {} + | sort -hr | sed -n "$var"p | awk '{print $2}')
            size=$(sudo find $param -type f -exec du -h {} + | sort -hr | sed -n "$var"p | awk '{print $1}')
            # type=$(sudo find $param -type f -exec du -h {} + | sort -hr | sed -n "$var"p | awk -F'.' '{print $3}')
            if ! [ -z "$name" ] && ! [ -z "$size" ]; then
                echo "$i - $name, $size Kb, ${name##*.}"
            fi
        done
}

function TOP_10_executable_files {
        echo -e "${whiteF}${blackT}TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):${reset}"
        i=1 
        for ((var=1; var<=10; var++, i++))
        do
            name=$(sudo find $param -type f -executable -exec du -h {} + | sort -hr | sed -n "$var"p | awk '{print $2}')
            size=$(sudo find $param -type f -executable -exec du -h {} + | sort -hr | sed -n "$var"p | awk '{print $1}')
            if [[ "${name##*.}" = "exe" ]]; then
                    hash="$(md5sum ${name[$i]} | awk '{print $1}')"
                    echo "i - $name, $size Kb, $hash"
            fi
        done
}

total_number_of_folders
TOP_5_folders_of_maximum_size
total_number_of_files
Number_of
TOP_10_files_of_maximum_size
TOP_10_executable_files
endTime=$(date +%s%N)
Time=$(bc <<< "$startTime - $endTime")
printTime=$(echo "$Time" | sed 's/-/0/g')
echo -e "${whiteF}${blackT}Script execution time (in seconds)${reset} = $printTime ms"