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
To install the statusline, just run `./install`.  
To uninstall it, run `./install -u`. There should also be this line somewhere in your .bashrc:
```bash
for file in $(echo ${HOME}/.config/bash/setup/*); do source $file; done
```
