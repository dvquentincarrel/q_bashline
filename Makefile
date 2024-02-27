export bin_dir=$${HOME}/.local/bin
export bash_setup_dir = $${HOME}/.config/bash/setup
modify_bashrc = false

.IGNORE install:
	mkdir -p $(bin_dir)
	mkdir -p $(bash_setup_dir)
	ln -Ts $$PWD/bashline_colors.bash $(bin_dir)/bashline_colors
	ln -Ts $$PWD/drain_socket.bash $(bin_dir)/drain_socket
	ln -Ts $$PWD/git_lineutils.bash $(bin_dir)/git_lineutils
	ln -Ts $$PWD/q_bashline.bash $(bin_dir)/q_bashline
ifeq ($(modify_bashrc), true)
	grep 'source qbl_init' "$${HOME}/.bashrc" || echo 'source qbl_init' >> "$${HOME}/.bashrc"
else
	ln -Ts $$PWD/qbl_init.bash $(bash_setup_dir)/011.qbl_init
endif

uninstall:
	rm $(bin_dir)/bashline_colors
	rm $(bin_dir)/drain_socket
	rm $(bin_dir)/git_lineutils
	rm $(bin_dir)/q_bashline
ifeq ($(modify_bashrc), true)
	grep -v 'source qbl_init' "$${HOME}/.bashrc" > qblless_bashrc
	mv -f qblless_bashrc "$${HOME}/.bashrc"
else
	rm $(bash_setup_dir)/011.qbl_init
endif
