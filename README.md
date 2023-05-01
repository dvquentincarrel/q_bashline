# Q_bashline
This is a statusline for bash.

## Features
- Last exit code
- Current working directory
- NNN recursion depth
- Current git branch
- Working tree status

Due to the time it may take to retrieve informations on large repos, this operation
is done asynchronously with IPC done through UNIX sockets.  
Due to limitations to either bash or my own knowledge,
status line gets updated only after every command.

Should the asynchronicity bother you, you could disable it by setting the env var
`$GIT_ASYNC` to false.

## Installation
To wire your bash to use this, run `setup.sh` or add the corresponding lines
at the end of your bashrc:
~~~ bash
coproc CO_NC_GIT { trap -- "true" EXIT; nc -klU /tmp/.QBL_$$; } && disown $!
git_lineutils $$ & disown $!
LINEUTILS_PID=$!
trap "rm -f /tmp/.QBL_$$; kill $LINEUTILS_PID" EXIT
~~~
