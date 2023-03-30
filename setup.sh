#!/bin/bash
# Setup script, handles symlink creation, handles bashrc updating

update_bashrc=true

# Checks whether it looks like it's already been done. Allow user to abort update
if $(grep -qF "coproc CO_NC_GIT " "$HOME/.bashrc"); then
    echo "This configuration seems already present in your bashrc."
    echo -n "Are you sure you want to continue? y/any: "
    read answer
    [[ "$answer" != "y" ]] && update_bashrc=false
fi

if [[ "$update_bashrc" == "true" ]]; then
# Adds relevant lines to bashrc
    cat >> "$HOME/.bashrc" <<EOF
coproc CO_NC_GIT { nc -klU /tmp/.QBL_\$\$; } && disown \$!
git_lineutils \$\$ & disown \$!
LINEUTILS_PID=\$!
trap "rm -f /tmp/.QBL_\$$; kill \$LINEUTILS_PID" EXIT
EOF
    echo "Updated bashrc"
else
    echo "Bashrc left as-is"
fi

lbin="$HOME/.local/bin"
mkdir -p "$HOME/.local/bin"
for executable in \
        bashline_colors drain_socket \
        git_lineutils q_bashline; do
    ln -si "$PWD/$executable" "$lbin/$executable"
done
