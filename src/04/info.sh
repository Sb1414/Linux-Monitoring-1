#!/bin/bash

function dataSetup {
        sudo timedatectl set-timezone Europe/Moscow
        sudo apt install ipcalc
        clear
        HOSTNAMEE=$(hostname)
        TIMEZONE="$(cat /etc/timezone) UTC $(date +"%Z")"
        USER=$(whoami)
        OS=$(cat /etc/issue | sed -n '1'p | awk '{printf("%s %s", $1, $2)}')
        DATE=$(date +"%d %b %Y %H:%M:%S")
        UPTIME=$(uptime -p)
        UPTIME_SEC=$(cat /proc/uptime | awk '{printf("%s", $1)}')
        IP=$(ip address | grep "inet.*enp0s3" | awk '{print $2}')
        MASK=$(ipcalc $IP | sed -n '2'p | awk '{printf("%s", $2)}')
        GATEWAY=$(ip route | sed -n '1'p | awk '{printf("%s", $3)}')
        RAM_TOTAL=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $2 / 1024 / 1024)}')
        RAM_USED=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $3 / 1024 / 1024)}')
        RAM_FREE=$(free | sed -n '2'p | awk '{printf("%.3f Gb", $4 / 1024 / 1024)}')
        SPACE_ROOT="$(df /root/ | awk '/\/$/ {printf "%.2f MB", $2/1024}')"
        SPACE_ROOT_USED=$(df | sed -n '4'p | awk '{printf("%.2f Gb", $3 / 1024 / 1024)}')
        SPACE_ROOT_FREE=$(df | sed -n '4'p | awk '{printf("%.2f Gb", $4 / 1024 / 1024)}')
}

function colors {
        whiteF="\033[107m"; redF="\033[41m"; greenF="\033[42m"; blueF="\033[44m"; purpleF="\033[45m"; blackF="\033[40m"
        whiteT="\033[97m"; redT="\033[31m"; greenT="\033[32m"; blueT="\033[34m"; purpleT="\033[35m"; blackT="\033[30m"
        reset="\e[0m"

        countStr=0
        errorCount=0

        for var in "column1_background" "column1_font_color" "column2_background" "column2_font_color"
        do
                if [[ $(grep -c $var config.txt) -eq 1 ]]
                then
                countStr=$(($countStr + 1))
                fi
        done

        if [[ $countStr -eq 4 ]]
        then
                arr[0]=$(grep column1_background config.txt | awk -F = '{printf("%i", $2)}');
                arr[1]=$(grep column1_font_color config.txt | awk -F = '{printf("%i", $2)}');
                arr[2]=$(grep column2_background config.txt | awk -F = '{printf("%i", $2)}');
                arr[3]=$(grep column2_font_color config.txt | awk -F = '{printf("%i", $2)}');
        else
                errorCount=$(($errorCount + 1))
        fi

        if [[ $errorCount -gt 0 ]]
        then
                echo "Invalid config"
                arr[0]=1;
                arr[1]=5;
                arr[2]=2;
                arr[3]=1;
        fi

        for i in 0 1 2 3; do
                if [[ ${arr[$i]} == 1 ]]; then
                        color[$i]="(white)"
                elif [[ ${arr[$i]} == 2 ]]; then
                        color[$i]="(red)"
                elif [[ ${arr[$i]} == 3 ]]; then
                        color[$i]="(green)"
                elif [[ ${arr[$i]} == 4 ]]; then
                        color[$i]="(blue)"
                elif [[ ${arr[$i]} == 5 ]]; then
                        color[$i]="(purple)"
                elif [[ ${arr[$i]} == 6 ]]; then
                        color[$i]="(black)"
                fi
        done

        for i in 0 1 2 3; do
                if [[ ${arr[$i]} < 1 || ${arr[$i]} > 6 ]]; then
                        echo "Wrong arguments"
                fi
        done

        if [[ ${arr[0]} == ${arr[1]} ]]; then
                echo "the background and the color of the text cannot be the same!"
                exit 1	
        elif [[ ${arr[2]} == ${arr[3]} ]]; then
                echo "the background and the color of the text cannot be the same!"
                exit 1
        fi

        for i in 0 2; do
                if [[ ${arr[$i]} == 1 ]]; then
                        narr[$i]=$whiteF
                elif [[ ${arr[$i]} == 2 ]]; then
                        narr[$i]=$redF
                elif [[ ${arr[$i]} == 3 ]]; then
                        narr[$i]=$greenF
                elif [[ ${arr[$i]} == 4 ]]; then
                        narr[$i]=$blueF
                elif [[ ${arr[$i]} == 5 ]]; then
                        narr[$i]=$purpleF
                elif [[ ${arr[$i]} == 6 ]]; then
                        narr[$i]=$blackF
                fi
        done

        for i in 1 3; do
                if [[ ${arr[$i]} == 1 ]]; then
                        narr[$i]=$whiteT
                elif [[ ${arr[$i]} == 2 ]]; then
                        narr[$i]=$redT
                elif [[ ${arr[$i]} == 3 ]]; then
                        narr[$i]=$greenT
                elif [[ ${arr[$i]} == 4 ]]; then
                        narr[$i]=$blueT
                elif [[ ${arr[$i]} == 5 ]]; then
                        narr[$i]=$purpleT
                elif [[ ${arr[$i]} == 6 ]]; then
                        narr[$i]=$blackT
                fi
        done

        dataSetup

        echo -e "${narr[0]}${narr[1]}HOSTNAME$reset = ${narr[2]}${narr[3]}$HOSTNAME$reset"
        echo -e "${narr[0]}${narr[1]}TIMEZONE$reset = ${narr[2]} ${narr[3]}$TIMEZONE$reset"
        echo -e "${narr[0]}${narr[1]}USER$reset = ${narr[2]}${narr[3]}$USER$reset"
        echo -e "${narr[0]}${narr[1]}OS$reset = ${narr[2]}${narr[3]}$OS$reset"
        echo -e "${narr[0]}${narr[1]}DATE$reset = ${narr[2]}${narr[3]}$DATE$reset"
        echo -e "${narr[0]}${narr[1]}UPTIME$reset = ${narr[2]}${narr[3]}$UPTIME$reset"
        echo -e "${narr[0]}${narr[1]}UPTIME_SEC$reset = ${narr[2]}${narr[3]}$UPTIME_SEC$reset"
        echo -e "${narr[0]}${narr[1]}IP$reset = ${narr[2]}${narr[3]}$IP$reset"
        echo -e "${narr[0]}${narr[1]}MASK$reset = ${narr[2]}${narr[3]}$MASK$reset"
        echo -e "${narr[0]}${narr[1]}GATEWAY$reset = ${narr[2]}${narr[3]}$GATEWAY$reset"
        echo -e "${narr[0]}${narr[1]}RAM_TOTAL$reset = ${narr[2]}${narr[3]}$RAM_TOTAL$reset"
        echo -e "${narr[0]}${narr[1]}RAM_USED$reset = ${narr[2]}${narr[3]}$RAM_USED$reset"
        echo -e "${narr[0]}${narr[1]}RAM_FREE$reset = ${narr[2]}${narr[3]}$RAM_FREE$reset"
        echo -e "${narr[0]}${narr[1]}SPACE_ROOT$reset = ${narr[2]}${narr[3]}$SPACE_ROOT$reset"
        echo -e "${narr[0]}${narr[1]}SPACE_ROOT_USED$reset = ${narr[2]}${narr[3]}$SPACE_ROOT_USED$reset"
        echo -e "${narr[0]}${narr[1]}SPACE_ROOT_FREE$reset = ${narr[2]}${narr[3]}$SPACE_ROOT_FREE$reset"
        echo " "
        if [[ ${param[0]} == 1 ]]; then
                echo "Column 1 background = default ${color[0]}"
        else
                echo "Column 1 background = ${arr[0]} ${color[0]}"
        fi

        if [[ ${param[1]} == 1 ]]; then
                echo "Column 1 font color = default ${color[1]}"
        else
                echo "Column 1 font color = ${arr[1]} ${color[1]}"
        fi

        if [[ ${param[2]} == 1 ]]; then
                echo "Column 2 background = default ${color[2]}"
        else    
                echo "Column 2 background = ${arr[2]} ${color[2]}"
        fi  

        if [[ ${param[3]} == 1 ]]; then
                echo "Column 2 font color = default ${color[3]}"
        else
                echo "Column 2 font color = ${arr[3]} ${color[3]}"
        fi
}

colors