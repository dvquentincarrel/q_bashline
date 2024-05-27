# Initializes everything needed for the bashline. Makes it so only a single line is needed in the bashrc

_QBL_TMP="${XDG_RUNTIME_DIR:-$TMPDIR}"
_QBL_TMP="${_QBL_TMP:-/tmp}"
_QBL_TMP="${_QBL_TMP}/qbl"

mkdir -p "$_QBL_TMP" &>/dev/null

# Sets up coprocess for IPC, creates prompt maker, handles deletion of unix socket at process death, updates prompt
# Trap is to avoid killing nc coproc when sending ctrl-C to the shell
if [[ "$QBL_LOADED" -ne '1' ]]; then
    coproc CO_NC_GIT { trap -- "true" EXIT; nc -klU ${_QBL_TMP}/$$; } && disown $!
    if [[ -n "$CO_NC_GIT" ]]; then
        git_lineutils "$_QBL_TMP/$$" & disown $!
        LINEUTILS_PID=$!
        source bashline_colors
        PROMPT_COMMAND="source q_bashline"${PROMPT_COMMAND:+"; $PROMPT_COMMAND"}
        trap "rm -f ${_QBL_TMP}/$$ >/dev/null; kill $LINEUTILS_PID" EXIT
    fi
    QBL_LOADED=1
fi
