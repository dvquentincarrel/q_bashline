# Q_bashline
This is a statusline for bash.

## Features
- Last exit code
- Current working directory
- NNN recursion depth
- Current Git branch/sha-1/tag
- Working tree status
- Git remotes status

Due to the time it may take to retrieve informations on large repos, this operation
is done asynchronously with IPC done through UNIX sockets.  
Due to limitations to either bash or my own knowledge,
status line gets updated only after every command.

Should the asynchronicity bother you, you could disable it by setting the env var
`$QBL_ASYNC` to false.

## Installation
To wire your bash to use this, run `make modify_bashrc=true` from inside this directory.  
If your bash automatically sources files inside some directory at start up, you
can put `qbl_init.bash` inside of it instead.
