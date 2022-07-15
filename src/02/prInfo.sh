#!/bin/bash

inputFile="test.txt"
touch $inputFile

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

function dataOutput {

        echo "HOSTNAMEE = $HOSTNAME" | tee -a $inputFile
        echo "TIMEZONE = $TIMEZONE" | tee -a $inputFile
        echo "USER = $USER" | tee -a $inputFile
        echo "OS = $OS" | tee -a $inputFile
        echo "DATE = $DATE" | tee -a $inputFile
        echo "UPTIME = $UPTIME" | tee -a $inputFile
        echo "UPTIME_SEC = $UPTIME_SEC" | tee -a $inputFile
        echo "IP = $IP" | tee -a $inputFile
        echo "MASK = $MASK" | tee -a $inputFile
        echo "GATEWAY = $GATEWAY" | tee -a $inputFile
        echo "RAM_TOTAL = $RAM_TOTAL" | tee -a $inputFile
        echo "RAM_USED = $RAM_USED" | tee -a $inputFile
        echo "RAM_FREE = $RAM_FREE" | tee -a $inputFile
        echo "SPACE_ROOT = $SPACE_ROOT" | tee -a $inputFile
        echo "SPACE_ROOT_USED = $SPACE_ROOT_USED" | tee -a $inputFile
        echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE" | tee -a $inputFile

        echo "============================================================="
        read -p "if you want to save the data to a file, write Y or y " answer
        if [[ $answer == Y || $answer == y ]]; then
                mv $inputFile $(date '+%d_%m_%Y_%H_%M_%S').status
        fi
}

dataSetup
dataOutput
echo "============================================================="
echo "your data is written to a file $(date '+%d_%m_%Y_%H_%M_%S').status"