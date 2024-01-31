#!/bin/bash
# Initializes everything needed for the bashline. Makes it so only a single line is needed in the bashrc

# Sets up coprocess for IPC, creates prompt maker, handles deletion of unix socket at process death, updates prompt
# Trap is to avoid killing nc coproc when sending ctrl-C to the shell
coproc CO_NC_GIT { trap -- "true" EXIT; nc -klU /tmp/.QBL_$$; } && disown $!
if [[ -n "$CO_NC_GIT" ]]; then
    git_lineutils $$ & disown $!
    LINEUTILS_PID=$!
    source bashline_colors
    PROMPT_COMMAND="source q_bashline${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    trap "rm -f /tmp/.QBL_$$ >/dev/null; kill $LINEUTILS_PID" EXIT
fi
