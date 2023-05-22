#!/bin/bash
# Setup script, handles symlink creation, handles bashrc updating

update_bashrc=true

# Checks whether it looks like it's already been done. Allow user to abort update
if $(grep -qF "source qbl_init" "$HOME/.bashrc"); then
    echo "This configuration seems already present in your bashrc."
    echo -n "Are you sure you want to modify it? y/any: "
    read answer
    [[ "$answer" != "y" ]] && update_bashrc=false
fi

if [[ "$update_bashrc" == "true" ]]; then
    # Adds relevant lines to bashrc, ~/.local/bin to path if necessary
    grep -qv "$HOME/.local/bin" <<< "$PATH" && printf 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
    printf '\nsource qbl_init' >> "$HOME/.bashrc"
    echo "Updated bashrc"
else
    echo "Bashrc left as-is"
fi

lbin="$HOME/.local/bin"
mkdir -p "$HOME/.local/bin"
for executable in qbl_init \
        bashline_colors drain_socket \
        git_lineutils q_bashline; do
    if [[ -e "$lbin/$executable" ]]; then
        echo -n "$lbin/$executable already exists. Replace it? y/any: "
        read answer
        [[ "$answer" == "y" ]] && ln -sf "$PWD/$executable" "$lbin/$executable" && echo "File overwritten"
    else
        ln -s "$PWD/$executable" "$lbin/$executable"
        echo "Linked $executable"
    fi
done

# Asks to replace fancy glyphs if supporting fonts not found
if ! grep -qPi "nerd|powerglyph" <<< "$(fc-list)"; then
    echo 'Font that supports fancy glyphs not found.'
    echo -n 'Do you want to use ▐ & ▌ instead of &  ? y/any: '
    read answer
    [[ "$answer" == "y" ]] && sed -i -e 's//▐/' -e 's//▌/' q_bashline
fi
