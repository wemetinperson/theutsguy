#!/bin/bash
# www.theutsguy.com

# This will check the files (typically log files) in the "directory_name" directory and will delete the oldest logs if the disk is more than "max_space percent" full
# I use this to manage the logs in the FiPi thing I described in this video: https://youtu.be/k2mtcIc_QAg
# I recommend having this run as a service or in your crontab at regular intervals 

# This is a random thing I made, don't use it for anything.
# Don't listen to anything I say or do anything I do.

#This looks for the largest disk in the system and assumes that's the same disk as the logs/directory you are trying to prune.
percent=$(df -h | sort -k3 -hr | head -n1 | awk '{gsub("%","",$5); print $5}')

#Modify these two variables as you see fit, it's the percent of disk space that's acceptable to have full and the directory you want to prune.
max_space=90
directory_name="/home/theutsguy/uts_kismet_logs"

if (( percent >= max_space )); then
    
        oldest=$(find "$directory_name" -type f -printf '%T@ %p\n' | sort -n | head -n1 | cut -d' ' -f2-)
        if [[ -n "$oldest" ]]; then
                rm -f -- "$oldest"
        fi
    exit 0
else
    exit 0
fi
