#!/bin/bash

# Status line for bash
# Structure:
#     exit_code / b64_time / nnn_depth / pwd / git-revision / git-status-infos

exit_code=$?

_exit=
_nnn=
_cwd=
QBL_SLEEP=${QBL_SLEEP:-0.02}
QBL_ASYNC=${QBL_ASYNC:-false} # Sync by default, overidden by the qbl.async git config key (true / false)
GIT_REV=
GIT_STASH= # How many stashed entries
REPO_INFO= # Remove if you don't want to reset output between each command

# Modular, en/disable certain parts
QBL_USE_EXIT=${QBL_USE_EXIT:-true}
QBL_USE_CWD=${QBL_USE_CWD:-true}
QBL_USE_TIME=${QBL_USE_TIME:-true}
QBL_USE_NNN=${QBL_USE_NNN:-true}
QBL_USE_GIT=${QBL_USE_GIT:-true}

# Displays error message ONCE, after the coproc died
if [[ -z $CO_NC_GIT ]] && $QBL_ALIVE; then
    QBL_ALIVE=false
    echo -e '\e[1;31mq_bashline died\e[0m'
fi


QBL_is_bare_repo=$(git rev-parse --is-bare-repository 2>/dev/null)
if [[ -n $QBL_is_bare_repo ]] && $QBL_is_bare_repo; then
    printf -v GIT_REV "▕ ${C_BAR_F}BARE${C_GEN_F}"
# If inside git repo
elif $QBL_USE_GIT && ( [[ -d .git ]] || git rev-parse --show-toplevel >/dev/null 2>&1); then

    # Get current branch name or tag or commit sha if detached
    QBL_head_info=$(git rev-parse HEAD >/dev/null 2>&1 && git tag --points-at HEAD | tail -n 1)
    QBL_head_color=${C_TAG_F}
    if [[ -z "$QBL_head_info" ]]; then
        QBL_head_info=$(git branch --show-current)
        QBL_head_color=${C_BRA_F}
    fi
    if [[ -z "$QBL_head_info" ]]; then
        QBL_head_info=$(git rev-parse --short HEAD)
        QBL_head_color=${C_DET_F}
    fi
    printf -v GIT_REV "▕ ${QBL_head_color}${QBL_head_info}${C_GEN_F}"


    QBL_stash_entries=$(git stash list | wc -l)
    if [[ $QBL_stash_entries -gt 0 ]]; then
        GIT_STASH="▕ ${C_TSH}${QBL_stash_entries}s${C_GEN_F}"
    fi


    # If coproc still alive
    if [[ -n $CO_NC_GIT ]]; then
        # Sends cwd to git_lineutils
        pwd -P >&${CO_NC_GIT[1]}
        # Get only the latest output produced by git linetuils
        if $(git config qbl.async || echo $QBL_ASYNC); then
            sleep $QBL_SLEEP # Unnoticeable, "long" enough to give time to git_lineutils to process its things, usually
            while read -t 0; do # While there's buffered data in the pipe
                read -r REPO_INFO <&${CO_NC_GIT[0]}
            done <&${CO_NC_GIT[0]}
        else
            read -t 1 -r REPO_INFO <&${CO_NC_GIT[0]}
            if [[ $? -gt 128 ]]; then # Happens if netcat attempts to connect to the pipe before creating it
                export QBL_USE_GIT=false
                echo -e "\x1b[31mERROR !\x1b[m QBL could not read from socket."
                echo -e "Disabled git integration"
                echo -e "Type \x1b[33mQBL_USE_GIT=true\x1b[m to attempt to re-enable it"
            fi
        fi
    fi
fi

if $QBL_USE_TIME && which b64_time &>/dev/null; then
    printf -v _time "▕ $(b64_time)"
fi

$QBL_USE_EXIT && printf -v _exit "${C_EXT_F}${exit_code}${C_GEN_F}"
$QBL_USE_CWD && printf -v _cwd "▕ ${C_CWD_F}\w${C_GEN_F}"

# if inside nnn
$QBL_USE_NNN && [[ -n "$NNNLVL" ]] && printf -v _nnn "▕ ${C_NNN_F}n${NNNLVL}${C_GEN_F}"

printf -v PS1 "${C_GEN_T}${C_GEN_B}${_exit}${_time}${_nnn}${_cwd}${GIT_REV}${GIT_STASH}${REPO_INFO}${C_GEN_T}${C_STP} "
printf "\e]0 $(basename '$PWD')" # Updates window title
