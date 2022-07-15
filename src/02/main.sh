#!/bin/bash
  
if [ $# != 0 ]; then
    echo "n/a"
else
    sudo chmod +x /prInfo.sh
    /prInfo.sh
fi