#!/bin/sh
dependencies=" bash echo git grep head nc printf sleep tail wc which"
executables="bashline_colors drain_socket git_lineutils q_bashline"
configs="qbl_init"

bin_dir="$HOME/.local/bin"
bash_setup_dir="$HOME/.config/bash/setup"

mkdir -p "$bin_dir" "$bash_setup_dir"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "To install the files, run:\n"
    printf "\t./install.sh\n"
    printf "To uninstall the files, run:\n"
    printf "\t./install.sh -u\n"
    exit 0
elif [ "$1" = "-u" ]; then
    mode=uninstall
    operation=Uninstalling
else
    mode=install
    operation=Installing
fi

if [ "$mode" != "uninstall" ]; then
    echo "Dependencies check:"
    for dependency in $dependencies; do
        which "$dependency" >/dev/null 2>&1 && output='\e[32mOK' || { output='\e[31mnot found'; valid_deps=false; }
        printf "    %b %b\e[m\n" "$dependency" "$output"
    done
fi

if ! $valid_deps; then
    echo "Not all dependencies met. Aborting."
    exit 1
fi

echo "$operation executables..."
for executable in $executables; do
    if [ $mode = "uninstall" ]; then
        rm "$bin_dir/$executable"
    elif ! [ -e "$bin_dir/$executable" ]; then
        ln -Ts "$PWD/$executable."* "$bin_dir/$executable"
    fi
done

echo "$operation config..."
for config in $configs; do
    if [ $mode = "uninstall" ]; then
        rm "$bash_setup_dir/010.$config"
    elif ! [ -e "$bash_setup_dir/010.$config" ]; then
        ln -Ts "$PWD/$config."* "$bash_setup_dir/010.$config"
    fi
done

if ! grep -F 'for file in $(echo ${HOME}/.config/bash/setup/*); do source $file; done' "$HOME/.bashrc" >/dev/null 2>&1; then
    echo "Adding config file autosourcing to bashrc"
    printf '\nfor file in $(echo ${HOME}/.config/bash/setup/*); do source $file; done\n' >> "$HOME/.bashrc"
fi
