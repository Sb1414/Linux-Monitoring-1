#!/bin/bash
  
if [ $# != 4 ]; then
    echo "n/a"
else
        export param1=$1
        export param2=$2
        export param3=$3
        export param4=$4
        sudo chmod +x /info.sh
        /info.sh
fi