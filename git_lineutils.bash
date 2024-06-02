#!/bin/bash
# Gives info about files status in the current directory according to git

source bashline_colors
source drain_socket


TRIES=10 # If the socket isn't found, how many tries before giving up
counter=0
while [[ $counter -ne $TRIES ]] && ! [[ -S "$1" ]]; do
    sleep 0.01
    ((counter++))
done

if [[ $counter -eq $TRIES ]]; then
    echo "Could not connect to qbl socket"
    echo "Starting a new shell should solve the issue"
    exit 1
fi

coproc CO_NC_GIT { nc -U "$1"; }

# Loops over socket
while read -r path; do
    Q_GBRANCH= # Branch of current repo
    Q_GINFO= # Infos on current repo status
    Q_REMOTE= # Infos on history diff with remote
    # Get last queue item. Necessary because items could pile up if added during processing
    latest_path=$(drain_socket ${CO_NC_GIT[0]} "$path")
    cd "$latest_path"


    # if there are local changes
    output=$(git status --porcelain | cut -c -2)
    if [[ -n "$output" ]]; then
        untracked=${C_UNT}$(grep -c '^??' <<< "$output")"?"
        unstaged=${C_UNS}$(grep -c '^ .\|^MM' <<< "$output")"!"
        staged=${C_STA}$(grep -c '^. \|^MM' <<< "$output")"+"
        unmerged=$(grep -c '^D[DU]\|U[ADU]\|A[AU]' <<< "$output")
        [[ $unmerged != 0 ]] && unmerged="${C_UNM}${unmerged}#" || unmerged=""
        printf -v Q_GINFO "▕ ${staged}${unstaged}${untracked}${unmerged}${C_GEN_F}"
    fi


    # if history doesn't line up with remote
    head_line=$(git status --porcelain --branch | head -n 1 | grep "ahead\|behind" )
    if [[ -n "$head_line" ]]; then
        behind=$(grep -Po "behind \K\d+" <<< "$head_line")
        ahead=$(grep -Po "ahead \K\d+" <<< "$head_line")
        printf -v Q_REMOTE "▕ ${C_BHD}${behind:+$behind↓}${C_AHD}${ahead:+$ahead↑}"
    fi

    echo "${Q_GBRANCH}${Q_GINFO}${Q_REMOTE}" >&${CO_NC_GIT[1]}

done <&${CO_NC_GIT[0]}
