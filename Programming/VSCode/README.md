## C/C++  

### Building the project

- If you want to use Cmake, just follow the instruction [here](https://vector-of-bool.github.io/docs/vscode-cmake-tools/getting_started.html) to add Cmake configuration to the project.

- If you are on Windows with MinGW, follow the instructions [here](https://code.visualstudio.com/docs/cpp/config-mingw) to setup the project environment.

### Debugging the project

You should config `launch.json` in the .vscode directory. 
Add these configurations to the file:
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}\\build\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "Path to gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
```
In my case, the path to gdb is : 
`"C:\\Program Files\\mingw-w64\\x86_64-8.1.0-posix-seh-rt_v6-rev0\\mingw64\\bin\\gdb.exe"`

### Change VS Code terminal to Git Bash

Full answer is [here](https://stackoverflow.com/a/50527994/2328389).
1. Open Visual Studio Code and press and hold Ctrl + ` to open the terminal.
2. Open the command palette using Ctrl + Shift + P .
3. Type - Select Default Shell.
4. Select Git Bash from the options.
5. Click on the + icon in the terminal window.
The new terminal now will be a Git Bash terminal.

### VS Code currently do not support IBM power 9 servers remote development

If that is your case, you can:
1. Install the extention SFTP sftp/ftp sync
2. Follow the instructions to add the server information from [here](https://marketplace.visualstudio.com/items?itemName=liximomo.sftp).

### SFTP Extension:

1. `Ctrl+Shift+P` on Windows/Linux or `Cmd+Shift+P` on Mac open command palette, run SFTP: config command.
2. Add this configuration to the opened file:
```
{
    "name": "My Site",
    "host": "my.ftp.net",
    "protocol": "sftp",
    "port": 22,
    "username": "user",
    "password": "pass",
    "remotePath": "/home",
    "uploadOnSave": true,
    "interactiveAuth": true
}
```
If you are using your public/private key to login to the remote server, and if your key has a pass phrase, add this configuration as well:
`"passphrase": true,`


