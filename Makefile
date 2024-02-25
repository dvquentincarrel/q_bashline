export bin_dir=$${HOME}/.local/bin
modify_bashrc = false

.IGNORE install:
	mkdir -p $(bin_dir)
	ln -Ts $$PWD/bashline_colors.bash $(bin_dir)/bashline_colors
	ln -Ts $$PWD/drain_socket.bash $(bin_dir)/drain_socket
	ln -Ts $$PWD/git_lineutils.bash $(bin_dir)/git_lineutils
	ln -Ts $$PWD/q_bashline.bash $(bin_dir)/q_bashline
	ln -Ts $$PWD/qbl_init.bash $(bin_dir)/qbl_init
ifeq ($(modify_bashrc), true)
	grep 'source qbl_init' "$${HOME}/.bashrc" || echo 'source qbl_init' >> "$${HOME}/.bashrc"
endif

uninstall:
	rm $(bin_dir)/bashline_colors
	rm $(bin_dir)/drain_socket
	rm $(bin_dir)/git_lineutils
	rm $(bin_dir)/q_bashline
	rm $(bin_dir)/qbl_init
ifeq ($(modify_bashrc), true)
	grep -v 'source qbl_init' "$${HOME}/.bashrc" > qblless_bashrc
	mv -f qblless_bashrc "$${HOME}/.bashrc"
endif
